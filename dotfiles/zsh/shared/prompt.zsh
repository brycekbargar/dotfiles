autoload -U colors && colors
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '[%b] %u'
zstyle ':vcs_info:git:*' actionformats '[%b] (%a)'

function precmd {
  vcs_info

  # TODO: Base this off of prompt length
  local last_cmd="$(fc -ln $((HISTCMD-1)))"
  local last_cmd_text
  case $((${#${last_cmd}} > 50)) in
    0) last_cmd_text=last_cmd ;;
    1) last_cmd_text="..." ;;
  esac

  local -ah ps1
  ps1=(
    '%B'
    '%F{047}%n%F{205} @ %F{047}%m'
    ' %(?.%F{099}.%F{160})' "$last_cmd_text"
    ' %F{075}$(pwd | sed -e "s,^$HOME,~,")'
    ' %F{192}${vcs_info_msg_0_/ U/ *}'
    "%f%b"
    $'\n'
    "%#> ")

  PS1="${(j::)ps1}"
}
