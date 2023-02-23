# Nushell Environment Config File

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  PATH: {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

let-env NU_LIB_DIRS = [
  ($nu.config-path | path dirname | path join 'scripts')
]

let-env NU_PLUGIN_DIRS = [
  ($nu.config-path | path dirname | path join 'plugins')
]

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

mkdir ~/.cache/zoxide
zoxide init nushell | save -f ~/.cache/zoxide/init.nu

ssh-agent -c | lines | parse "setenv {name} {value};" | reduce -f {} {|it, acc| $acc | insert $it.name $it.value } | load-env
