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
