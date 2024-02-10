#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_pop.sh"

#==================================
# Print Section Title
#==================================
print_section "Shell Setup"

#==================================
# Install Fish
#==================================
print_title "Installing Fish"
apt_install "Fish" "fish"

#==================================
# Install Fisher
#==================================
fish <<'END_FISH'
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher >/dev/null 2>&1
END_FISH
print_result $? "Fisher" "true"

#==================================
# Install fish packages
#==================================
print_title "Installing Fish Packages"
fisher_install "Fisher" "jorgebucaran/fisher"
fisher_install "FZF" "PatrickF1/fzf.fish"
fisher_install "async-prompt" "acomagu/fish-async-prompt"
fisher_install "Forgit" "wfxr/forgit"
fisher_install "Autojump" "jethrokuan/z"
fisher_install "Autopair" "jorgebucaran/autopair.fish"
fisher_install "Puffer Fish" "nickeb96/puffer-fish"
fisher_install "Done" "franciscolourenco/done"
fisher_install "Abbreviation-tips" "gazorby/fish-abbreviation-tips"
fisher_install "Fish SSH Agent" "danhper/fish-ssh-agent"
fisher_install "Safe trash" "aluxian/fish-trash"

#==================================
# Install starship prompt
#==================================
print_title "Installing Starship Prompt"
curl -sS https://starship.rs/install.sh | sh -s -- -y >/dev/null 2>&1
print_result $? "Starship" "true"

#==================================
# Change Default Shell
#==================================
print_title "Changing Default Shell"

print_in_green "sed 1"
sudo sed -i '/auth       required   pam_shells.so/ s//auth       sufficient   pam_shells.so/g' /etc/pam.d/chsh >/dev/null 2>&1
print_in_green "tee fish -> shells"
which fish | sudo tee -a /etc/shells >/dev/null 2>&1
print_in_green "chsh which fish"
sudo chsh -s "$(which fish)" >/dev/null 2>&1
print_in_green "sed 2"
sudo sed -i '/auth       sufficient   pam_shells.so/ s//auth       required   pam_shells.so/g' /etc/pam.d/chsh >/dev/null 2>&1
execute "fish -c fish_update_completions >/dev/null 2>&1" "Updating fish completions"
print_result $? "Change fish as default shell" "true"

#==================================
# Micromamba Shell Init
#==================================
print_title "Micromamba Shell Init"
micromamba shell init -s fish -p ~/micromamba &> /dev/null
micromamba shell init -s zsh -p ~/micromamba &> /dev/null
micromamba shell init -s bash -p ~/micromamba &> /dev/null
print_result $? "Init micromamba Shell for bash, fish and zsh" "true"