# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/alejandrodelacruz/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/alejandrodelacruz/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/alejandrodelacruz/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/alejandrodelacruz/google-cloud-sdk/completion.zsh.inc'; fi

# Paths
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/bin
export PATH=$PATH:~/Work/personal/dotfiles/scripts

# Aliases
source ~/Work/personal/dotfiles/shell/aliases.sh

# Secrets
source ~/Work/personal/dotfiles/shell/export-secrets.sh

# Variables
source ~/Work/personal/dotfiles/shell/export-variables.sh
