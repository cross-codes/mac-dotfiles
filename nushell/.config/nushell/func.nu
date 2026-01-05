# func.nu

use std

# XDG Desktop Portal libraries for screen sharing
export def ssmode [] {
  if ($nu.os-info.name == 'windows') {
    return;
  }

  nu -c (/usr/libexec/xdg-desktop-portal -r & /usr/libexec/xdg-desktop-portal-wlr)
}

# Synchronise clock
export def reset-clock [] {
  if ($nu.os-info.name == 'windows') {
    return;
  }

  nu -c (sudo timedatectl set-ntp off)
  nu -c (sudo systemctl daemon-reload)
  nu -c (sudo timedatectl set-ntp on)
}

# Modify TOS field for outgoing packets
export def mangle [] {
  if ($nu.os-info.name == 'windows') {
    return;
  }

  nu -c (sudo /sbin/iptables -A OUTPUT -t mangle -j TOS --set-tos 0x04)
}

# Function to determine an adjacent pane to the current wezterm pane
export def determine-adjacent-pane [] {
  if ($nu.os-info.name == 'windows') {
    return;
  }

try {
    let tbl = wezterm cli list | detect columns
    # Panes in front: Take the first entry
    let result = ($tbl | where PANEID > $env.WEZTERM_PANE | length)
    if ($result >= 1) {
      return ($tbl | where PANEID > $env.WEZTERM_PANE | first | get PANEID)
    } else {
      # Panes in back: Take the last entry
      let result = ($tbl | where PANEID < $env.WEZTERM_PANE | length)
      if ($result == 0) {
        return (-1 | into int);
      } else {
        return ($tbl | where PANEID < $env.WEZTERM_PANE | last | get PANEID)
      }
    }
  } catch {
    return (-1 | into int)
  }
}

# Function to set CWD. Uses FZF
export def --env set-project [] {
  if ($nu.os-info.name == 'windows') {
    return;
  }

  try {
    let result = (
    ^find /Users/cross/config
        /Users/cross/MockingDSA
        -mindepth 0 -type d
        -not -path "*/venv*"
        -not -path "*/node_modules*"
        -not -path "*/.git*"
        -not -path "*/__pycache__*"
        -not -path "*/dist*"
        -not -path "*/build*"
        -not -path "*/bin*"
        -not -path "*/.bin*"
        -not -path "*/obj*"
        -not -path "*/out*"
        -not -path "*/classes*"
        -not -path "*/.gradle*"
        -not -path "*/.idea*"
        -not -path "*/coverage*"
        -not -path "*/target*" |
    fzf --preview "eza --icons=auto --sort=name --group-directories-first --tree {}")

    if $result != "" {
      clear
      cd $result
    }
  } catch {
    return (-1 | into int)
  }
}

# Function to write a list of all installed binaries via the package manager
export def dnf-freeze [] {
  if ($nu.os-info.name != 'linux') {
    return;
  }

  if ((which dnf4 | length ) > 0) {
    dnf4 list installed | detect columns |
    get Installed |
    save ~/config/installed_packages.txt --force
  } else {
    print --stderr "Unable to find executable: dnf4"
  }
}

# Function to update all binaries installed from crates.io
# NOTE: Have to manually specify conditions for stuff not on crates.io
export def update-cargo-binaries [] {
  if ($nu.os-info.name == 'windows') {
    return;
  }

  if ((which cargo | length) > 0) {
    cargo install --list |
    parse "{package} v{version}" |
    get package |
    each {|p| if $p != "neovide" { cargo install $p }}
  } else {
    print --stderr "Unable to find executable: cargo"
  }
}

# Function to update all binaries installed via go install
export def update-go-binaries [] {
  if ($nu.os-info.name == 'windows') {
    return;
  }

  if ((which go | length) > 0) {
    ls ([ $env.HOME, "go/bin" ] | str join) |
    get name |
    each { |p|
      let path = (go version -m $p | detect columns --skip 1 | select path | get 0.path)
      go install ([$path, "@latest"] | str join)
    }
  } else {
    print --stderr "Unable to find executable: go"
  }
}

# Distribution upgrade
export def dup [ --exclude : string ] {
  if ($nu.os-info.name != 'linux') {
    return;
  }

  let exclude = $exclude
  # DNF
  print $"(ansi green_bold)\(1\) Syncing RPM packages...(ansi reset)"
  print $"(ansi blue)--------------------------(ansi reset)"
  nu -c ($"sudo dnf5 upgrade --refresh --exclude=($exclude)")
  print $"\n"

  # Snap
  if ((which snap | length) > 0)  {
    print $"(ansi green_bold)\(2\) Syncing snap packages...(ansi reset)"
    print $"(ansi blue)--------------------------(ansi reset)"
    sudo snap refresh
  } else {
    print $"(ansi blue_bold)Snap not configured for the current system. Skipping(ansi reset)"
  }
  print $"\n"

  # Cargo
  print $"(ansi green_bold)\(3\) Syncing cargo packages...(ansi reset)"
  print $"(ansi blue)--------------------------(ansi reset)"
  update-cargo-binaries
  print $"\n"

  # Go
  print $"(ansi green_bold)\(4\) Syncing go packages...(ansi reset)"
  print $"(ansi blue)--------------------------(ansi reset)"
  update-go-binaries
  print $"\n"

  # Flatpak
  if ((which flatpak | length) > 0) {
    print $"(ansi green_bold)\(5\) Syncing flatpak packages...(ansi reset)"
    print $"(ansi blue)--------------------------(ansi reset)"
    flatpak update
  } else {
    print $"(ansi blue_bold)Flatpak not configured for the current system. Skipping(ansi reset)"
  }
  print $"\n"

  # Finish
  print $"(ansi blue_bold)Distribution upgrade complete(ansi reset)"
}

# Execute binary with input from clipboard and timer
export def crun [] {
  if ($nu.os-info.name != 'linux') {
    return;
  }

  wl-paste | time -p ./sol.x86_64 | complete
}

# Custom java runner implementation
export def --wrapped jrun [ ...jar: string, --impl (-i) ] {
  if ($nu.os-info.name == 'windows') {
    return;
  }

  let input = $in
  mut logless = 0

  if $impl {
    $logless = 1
  }

  # Run step
  if $logless == 0 {
      print "-------------------"
      print $"(ansi white_bold)    BEGIN RUN(ansi reset)"
      print "-------------------"
  }

  if ($input | is-empty) {
    print (java -ea
                -XX:+UseSerialGC
                -XX:TieredStopAtLevel=1
                -XX:NewRatio=5
                -Xms8M
                -Xmx512M
                -Xss64M
                -DANTUMBRA=true
                -Dcom.sun.management.jmxremote.port=8080
                -Dcom.sun.management.jmxremote.authenticate=false
                -Dcom.sun.management.jmxremote.ssl=false
                -jar ...$jar |
           complete |
           update stderr { ($in | str replace --all --multiline --regex '\s{2,}' ' ') }
           )
  } else {
    print ($input |
           java -ea
                -XX:+UseSerialGC
                -XX:TieredStopAtLevel=1
                -XX:NewRatio=5
                -Xms8M
                -Xmx512M
                -Xss64M
                -DANTUMBRA=true
                -Dcom.sun.management.jmxremote.port=8080
                -Dcom.sun.management.jmxremote.authenticate=false
                -Dcom.sun.management.jmxremote.ssl=false
                -jar ...$jar |
           complete |
           update stderr { ($in | str replace --all --multiline --regex '\s{2,}' ' ') }
           )
  }

  if $logless == 0 {
      print "-------------------"
      print $"(ansi white_bold)      END RUN(ansi reset)"
      print "-------------------"
  }
}
