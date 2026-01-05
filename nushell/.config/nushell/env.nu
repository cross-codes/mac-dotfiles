# env.nu

use std "path add"

$env.ENV_CONVERSIONS = {
  "PATH": { from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
      to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
      from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
      to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

$env.NU_LIB_DIRS = [
  ($nu.default-config-dir | path join 'scripts')
  ($nu.data-dir | path join 'completions')
]

$env.NU_PLUGIN_DIRS = [
  ($nu.default-config-dir | path join 'plugins')
]

if $nu.os-info.name == 'linux' {
  $env.PATH = ($env.PATH | split row (char esep))
  path add ($env.HOME | path join ".local" "bin")
  path add ($env.HOME | path join "go")
  path add ($env.GOPATH | path join "bin")
  path add ($env.HOME | path join ".cargo" "bin")
  path add ($env.HOME | path join ".local" "share" "nvim" "mason" "bin")
  $env.PATH = ($env.PATH | uniq)

  ulimit -Sn 65535
}

if $nu.os-info.name == "macos" {
  source $"($nu.home-path)/.cargo/env.nu"
  $env.PATH = ($env.PATH | split row (char esep))
  path add "/opt/homebrew/bin"
  path add ($env.HOME | path join ".cargo" "bin")
  path add ($env.HOME | path join "go" "bin")

  let java_home = ( ^/usr/libexec/java_home | str trim )
  $env.JAVA_HOME = $java_home
  $env.PATH = ($env.PATH | prepend $"($java_home)/bin")

  $env.PATH = ($env.PATH | uniq)
  ulimit -Sn 65535
}


$env.FZF_DEFAULT_OPTS = "--color=fg:#d0d0d0,fg+:#d0d0d0,bg+:#282727
  --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
  --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
  --color=border:#0e0c15,label:#aeaeae,query:#d9d9d9
  --border=rounded --border-label= --preview-window=border-rounded --prompt='> '
  --marker='>' --pointer='◆' --separator='─' --scrollbar='│'"

$env.FZF_PREVIEW_FILE_CMD = "bat --color=always --style=numbers {} || eza --icons=auto --sort=name --group-directories-first --tree {}"

source "./alias.nu"
source "./func.nu"
source "./autostart.nu"
