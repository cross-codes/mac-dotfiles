# alias.nu

export def l [] {
  nu -c ([$env.HOME, "/go/bin/lazygit"] | str join)
}

export def lla [] {
  ls -a | reverse
}

alias imgcat = wezterm imgcat
alias :q = exit
alias cls = clear
alias rmdir = rm -rf
alias vim = nvim
alias vi = vim
alias idb = gdb-oneapi

alias ll = eza --icons
