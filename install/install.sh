#!/usr/bin/env bash
set -euo pipefail

VERSION="0.3.0"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

usage() {
  cat <<EOF
Reins Installer v$VERSION

Usage: ./install.sh --agent <target> [options]

Targets:
  claude       Install for Claude Code (user scope: ~/.claude/commands/)
  claude-proj  Install for Claude Code (project scope: .claude/commands/)
  codex        Install for Codex CLI (.agents/skills/ + AGENTS.md)
  opencode     Install for OpenCode (.opencode/skills/)
  cursor       Install for Cursor (.cursor/rules/)
  generic      Install to custom directory (requires --dest)

Options:
  --dest <dir>       Destination directory (required for generic, optional for others)
  --only <phase>     Install only specific phase(s). Comma-separated.
                     Phases: think, build, prove, meta, modes, constraints, agents
                     Shortcuts: security (constraints+prove), quality (build+prove)
  --with-hooks       Install pre-commit hooks to current git repo
  --with-ci          Copy GitHub Actions workflow to .github/workflows/
  --with-templates   Copy project templates to docs/reins/
  --update           Update existing installation (preserves project config)
  --uninstall        Remove Reins from the specified agent target
  --version          Show version and exit
  --help             Show this help

Examples:
  ./install.sh --agent claude                      # Full install for Claude Code
  ./install.sh --agent codex --only security       # Security skills only for Codex
  ./install.sh --agent claude --with-hooks --with-ci  # Full install + enforcement
  ./install.sh --agent claude --update             # Update to latest version
  ./install.sh --agent claude --uninstall          # Remove Reins
  ./install.sh --agent generic --dest ./my-project/.ai/skills
EOF
  exit 0
}

# --- Skill Copying ---

copy_all_skills() {
  local dest="$1"
  mkdir -p "$dest"
  cp -r "$SKILLS_DIR"/* "$dest/"
  echo "All skills copied to $dest"
}

copy_phase() {
  local dest="$1"
  local phase="$2"

  case "$phase" in
    think|build|prove|meta|modes|constraints|agents)
      if [ -d "$SKILLS_DIR/$phase" ]; then
        mkdir -p "$dest/$phase"
        cp -r "$SKILLS_DIR/$phase"/* "$dest/$phase/"
        echo "  ✓ $phase"
      fi
      ;;
    orchestrator)
      mkdir -p "$dest/orchestrator"
      cp "$SKILLS_DIR/orchestrator/SKILL.md" "$dest/orchestrator/"
      echo "  ✓ orchestrator"
      ;;
    security)
      copy_phase "$dest" "constraints"
      copy_phase "$dest" "prove"
      ;;
    quality)
      copy_phase "$dest" "build"
      copy_phase "$dest" "prove"
      ;;
    *)
      echo "Unknown phase: $phase"
      exit 1
      ;;
  esac
}

copy_selective() {
  local dest="$1"
  local phases="$2"
  mkdir -p "$dest"

  # Always copy orchestrator
  copy_phase "$dest" "orchestrator"

  IFS=',' read -ra PHASE_ARRAY <<< "$phases"
  for phase in "${PHASE_ARRAY[@]}"; do
    phase=$(echo "$phase" | tr -d ' ')
    copy_phase "$dest" "$phase"
  done
}

copy_agents_md() {
  local dest="$1"
  cp "$SCRIPT_DIR/AGENTS.md" "$dest/AGENTS.md"
  echo "AGENTS.md copied to $dest"
}

install_hooks() {
  if [ ! -d ".git" ]; then
    echo "Warning: Not a git repository. Skipping hooks installation."
    return
  fi
  mkdir -p .git/hooks
  ln -sf "$(pwd)/enforcement/hooks/pre-commit" .git/hooks/pre-commit 2>/dev/null || \
    cp "$SCRIPT_DIR/enforcement/hooks/pre-commit" .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
  echo "Pre-commit hook installed"
}

install_ci() {
  mkdir -p .github/workflows
  cp "$SCRIPT_DIR/enforcement/ci/reins-check.yml" .github/workflows/reins-check.yml
  echo "GitHub Actions workflow copied to .github/workflows/reins-check.yml"
}

install_templates() {
  mkdir -p docs/reins/{decisions,plans/archive,tickets,reports,design,test-plans,dod,stats,erd}
  cp "$SCRIPT_DIR/templates/reins.config.md" docs/reins/config.md 2>/dev/null || true
  cp "$SCRIPT_DIR/templates/decisions.md" docs/reins/decisions/.gitkeep 2>/dev/null || true
  cp "$SCRIPT_DIR/templates/memory.md" docs/reins/memory.md 2>/dev/null || true
  cp "$SCRIPT_DIR/templates/index.md" docs/reins/index.md 2>/dev/null || true
  cp "$SCRIPT_DIR/templates/glossary.md" docs/reins/glossary.md 2>/dev/null || true
  echo "Templates copied to docs/reins/"
}

uninstall_agent() {
  local dest="$1"
  if [ -d "$dest" ]; then
    rm -rf "$dest"
    echo "Reins removed from $dest"
  else
    echo "Reins not found at $dest — nothing to remove"
  fi
}

# --- Parse Arguments ---

AGENT=""
DEST=""
ONLY=""
WITH_HOOKS=false
WITH_CI=false
WITH_TEMPLATES=false
DO_UPDATE=false
DO_UNINSTALL=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --agent) AGENT="$2"; shift 2 ;;
    --dest)  DEST="$2"; shift 2 ;;
    --only)  ONLY="$2"; shift 2 ;;
    --with-hooks) WITH_HOOKS=true; shift ;;
    --with-ci) WITH_CI=true; shift ;;
    --with-templates) WITH_TEMPLATES=true; shift ;;
    --update) DO_UPDATE=true; shift ;;
    --uninstall) DO_UNINSTALL=true; shift ;;
    --version) echo "Reins v$VERSION"; exit 0 ;;
    --help)  usage ;;
    *)       echo "Unknown option: $1"; usage ;;
  esac
done

if [[ -z "$AGENT" ]]; then
  echo "Error: --agent is required"
  usage
fi

# --- Resolve Destination ---

resolve_dest() {
  case "$AGENT" in
    claude)      echo "${DEST:-$HOME/.claude/commands/reins}" ;;
    claude-proj) echo "${DEST:-.claude/commands/reins}" ;;
    codex)       echo "${DEST:-.agents/skills/reins}" ;;
    opencode)    echo "${DEST:-.opencode/skills/reins}" ;;
    cursor)      echo "${DEST:-.cursor/rules}" ;;
    generic)
      if [[ -z "$DEST" ]]; then
        echo "Error: --dest required for generic install" >&2
        exit 1
      fi
      echo "$DEST"
      ;;
    *)
      echo "Error: Unknown agent '$AGENT'" >&2
      exit 1
      ;;
  esac
}

TARGET_DEST=$(resolve_dest)

# --- Uninstall ---

if [ "$DO_UNINSTALL" = true ]; then
  echo "Uninstalling Reins v$VERSION from $AGENT..."
  uninstall_agent "$TARGET_DEST"

  # Clean up hooks
  if [ -f ".git/hooks/pre-commit" ]; then
    if grep -q "Reins Pre-Commit" .git/hooks/pre-commit 2>/dev/null; then
      rm .git/hooks/pre-commit
      echo "Pre-commit hook removed"
    fi
  fi

  # Clean up CI
  if [ -f ".github/workflows/reins-check.yml" ]; then
    rm .github/workflows/reins-check.yml
    echo "GitHub Actions workflow removed"
  fi

  # Clean up AGENTS.md if we created it
  if [ -f "AGENTS.md" ] && grep -q "Reins" AGENTS.md 2>/dev/null; then
    echo "Note: AGENTS.md left in place — remove manually if no longer needed"
  fi

  echo ""
  echo "Reins uninstalled. Project docs (docs/reins/) preserved — remove manually if desired."
  exit 0
fi

# --- Update ---

if [ "$DO_UPDATE" = true ]; then
  echo "Updating Reins to v$VERSION for $AGENT..."

  if [ ! -d "$TARGET_DEST" ]; then
    echo "Reins not found at $TARGET_DEST — running fresh install instead"
    DO_UPDATE=false
  else
    # Preserve project config before overwrite
    echo "Updating skills at $TARGET_DEST..."
    if [[ -n "$ONLY" ]]; then
      copy_selective "$TARGET_DEST" "$ONLY"
    else
      copy_all_skills "$TARGET_DEST"
    fi

    # Update hooks if installed
    if [ -f ".git/hooks/pre-commit" ] && grep -q "Reins" .git/hooks/pre-commit 2>/dev/null; then
      install_hooks
      echo "Pre-commit hook updated"
    fi

    # Update CI if installed
    if [ -f ".github/workflows/reins-check.yml" ]; then
      install_ci
      echo "CI workflow updated"
    fi

    echo ""
    echo "Reins updated to v$VERSION."
    echo "Project config (docs/reins/config.md) preserved."
    exit 0
  fi
fi

# --- Fresh Install ---

echo "Installing Reins v$VERSION for $AGENT..."

if [[ -n "$ONLY" ]]; then
  echo "Selective install: $ONLY"
  copy_selective "$TARGET_DEST" "$ONLY"
else
  copy_all_skills "$TARGET_DEST"
fi

# Agent-specific setup
case "$AGENT" in
  claude)
    echo ""
    echo "Reins installed for Claude Code (user scope)."
    echo "Skills available as /reins commands."
    ;;
  claude-proj)
    echo ""
    echo "Reins installed for Claude Code (project scope)."
    echo "Skills available as /reins commands in this project."
    ;;
  codex)
    copy_agents_md "."
    echo ""
    echo "Reins installed for Codex CLI."
    echo "AGENTS.md updated. Skills in $TARGET_DEST/"
    ;;
  opencode)
    copy_agents_md "."
    echo ""
    echo "Reins installed for OpenCode."
    echo "Skills in $TARGET_DEST/"
    echo "Use subagent patterns from skills/agents/subagent-patterns/ for multi-agent simulation."
    ;;
  cursor)
    mkdir -p "$TARGET_DEST"
    cp "$SKILLS_DIR/orchestrator/SKILL.md" "$TARGET_DEST/reins-orchestrator.md"
    copy_agents_md "."
    echo ""
    echo "Reins installed for Cursor."
    echo "Orchestrator in $TARGET_DEST/reins-orchestrator.md"
    echo "Full skills available via AGENTS.md reference."
    echo "Note: Cursor has limited skill support. Consider Claude Code or Codex for full Reins."
    ;;
  generic)
    copy_agents_md "$(dirname "$TARGET_DEST")"
    echo ""
    echo "Reins installed to $TARGET_DEST"
    ;;
esac

# Optional extras
[ "$WITH_HOOKS" = true ] && install_hooks
[ "$WITH_CI" = true ] && install_ci
[ "$WITH_TEMPLATES" = true ] && install_templates

echo ""
if [ "$WITH_TEMPLATES" != true ]; then
  echo "Optional: set up project-level config:"
  echo "  ./install.sh --agent $AGENT --with-templates"
  echo ""
  echo "Optional: add enforcement:"
  echo "  ./install.sh --agent $AGENT --with-hooks --with-ci"
fi
echo ""
echo "Reins v$VERSION installed successfully."
