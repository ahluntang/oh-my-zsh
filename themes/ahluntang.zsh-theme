#ahluntang: ZSH Theme based on 'frosted' and 'gnzh'


# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

# make some aliases for the colours: (coud use normal escap.seq's too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# Check the UID
if [[ $UID -eq 0 ]]; then # root
  eval PR_USER='%{$PR_RED$PR_BOLD%}%n%{$PR_NO_COLOR%}'
  local PR_PROMPT='%{$PR_RED$PR_BOLD%}◇%{$PR_NO_COLOR%} '
else # normal user
  eval PR_USER='%{$PR_RED$PR_BOLD%}%n%{$PR_NO_COLOR%}'
  #local PR_PROMPT='%{$PR_NO_COLOR%}➤ '
  local PR_PROMPT='%{$PR_NO_COLOR%}◇ '
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
  eval PR_HOST='%{$PR_YELLOW$PR_BOLD%}%M%{$PR_NO_COLOR%}' #SSH
else
  eval PR_HOST='%{$PR_YELLOW$PR_BOLD%}%M%{$PR_NO_COLOR%}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"

local user_host='%{$PR_RED%}${PR_USER}%{$PR_WHITE%}@${PR_HOST}'
local current_dir='%{$PR_BOLD$PR_GREEN%}${PWD/#$HOME/~}%{$PR_NO_COLOR%}'

# Construct the git prompt
function git_prompt {
        gp="$(git_prompt_short_sha)$(git_prompt_info)$(git_prompt_ahead)"
        if [ "x$gp" != "x" ]; then
                echo "${GIT_PRE}${gp}${GIT_POST}"
        else
                echo ""
        fi
}
local git_branch='$(git_prompt)%{$PR_NO_COLOR%}'

# The time
local p_time="%{$PR_BOLD%}%D{%T}%{$PR_NO_COLOR%}"

PROMPT="
%{$PR_WHITE%}╭─<${user_host}%{$PR_WHITE%}>-<${current_dir}%{$PR_WHITE%}>-${git_branch}%{$PR_WHITE%}◇
%{$PR_WHITE%}╰─<%{$PR_YELLOW$PR_BOLD%}${p_time}%{$PR_WHITE%}>─$PR_PROMPT"
RPS1="${return_code}"

local GIT_PRE="<%{$PR_MAGENTA%}"
local GIT_POST="%{$PR_NO_COLOR$PR_WHITE%}>-"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_BOLD$PR_WHITE%}∙%{$PR_NO_COLOR$PR_MAGENTA%}%{$PR_BOLD%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$PR_NO_COLOR$PR_WHITE%}∙%{$PR_RED%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$PR_NO_COLOR$PR_WHITE%}∙%{$PR_GREEN%}✔"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$PR_YELLOW$PR_BOLD%}⚡"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=""
ZSH_THEME_GIT_PROMPT_SHA_AFTER=""