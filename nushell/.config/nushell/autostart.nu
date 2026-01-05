# autostart.nu

if $nu.os-info.name != 'windows' {
  nu -c "printf '\\033]1337;SetUserVar=theme=%s\\007\' (echo ('carbon' | encode base64))"
  nu -c "krabby random 1-5 --no-title --no-gmax --no-regional"
}
