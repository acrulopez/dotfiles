# List available global commands
default:
    @just --justfile ~/Work/personal/dotfiles/just/global.justfile --list

# Google Cloud Auth + Gdrive access
gauth:
    gcloud auth application-default login
    gcloud auth login --enable-gdrive-access --update-adc

# Git add + commit (with message) + push
gpush message:
    git add .
    git commit -m "{{message}}"
    git push

# Git amend last commit
gamend:
    git add .
    git commit --amend --no-edit
    git push --force-with-lease

# Format json
format-json json:
    echo {{json}} | jq .

# Deploy Claude Code config to ~/.claude (with diff approval per item)
claude-deploy:
    #!/usr/bin/env bash
    set -euo pipefail
    SRC=~/Work/personal/dotfiles/.claude
    DST=~/.claude
    for item in settings.json commands skills scripts; do
        echo ""
        echo "===== $item ====="
        if [ -e "$DST/$item" ]; then
            git diff --no-index -- "$DST/$item" "$SRC/$item" || true
        else
            echo "(new — does not exist in $DST yet)"
        fi
        read -p "Deploy $item? [y/N] " confirm
        if [[ "${confirm:-N}" =~ ^[Yy]$ ]]; then
            mkdir -p "$(dirname "$DST/$item")"
            if [ -d "$SRC/$item" ]; then
                rsync -av --delete "$SRC/$item/" "$DST/$item/"
            else
                rsync -av "$SRC/$item" "$DST/$item"
            fi
            echo "✓ $item deployed"
        else
            echo "⊘ $item skipped"
        fi
    done
