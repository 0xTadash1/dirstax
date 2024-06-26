#!/usr/bin/env zsh

###
# Prerequisites
##
setopt AUTO_PUSHD

###
# Settings
##
typeset -Ax dirstax
: ${dirstax[keybind_upward]:='^[[1;4A'}    # shift + alt + ↑
: ${dirstax[keybind_forward]:='^[[1;4C'}   # shift + alt + →
: ${dirstax[keybind_backward]:='^[[1;4D'}  # shift + alt + ←
# for internal
dirstax[_backtracks]=0
dirstax[_moving]=no

###
# Main Widgets
##
dirstax-cd-upward() {
	zle push-input
	dirstax[_moving]=yes
	cd ..
	zle accept-line
}
dirstax-cd-forward() {
	(( dirstax[_backtracks] == 0 )) && return 1

	zle push-input
	dirstax[_moving]=yes
	if [[ ${options[PUSHD_MINUS]} == 'off' ]]; then
		pushd -0 >/dev/null 2>&1
	else
		pushd +0 >/dev/null 2>&1
	fi
	dirstax[_backtracks]=$(( dirstax[_backtracks] - 1 ))
	zle accept-line
}
dirstax-cd-backward() {
	(( dirstax[_backtracks] == ${#dirstack} )) && return 1

	zle push-input
	dirstax[_moving]=yes
	if [[ ${options[PUSHD_MINUS]} == 'off' ]]; then
		pushd +1 >/dev/null 2>&1
	else
		pushd -1 >/dev/null 2>&1
	fi
	dirstax[_backtracks]=$(( dirstax[_backtracks] + 1 ))
	zle accept-line
}
# register new widgets
zle -N dirstax-cd-upward
zle -N dirstax-cd-forward
zle -N dirstax-cd-backward

###
# Hook
##
autoload -Uz add-zsh-hook

dirstax-drop-dirstack-forward-history-on-chpwd() {
	if [[ "${dirstax[_moving]}" == 'yes' ]]; then
		dirstax[_moving]=no
		return 0
	fi
	if (( dirstax[_backtracks] != 0 )); then
		dirstack=("${dirstack[@]:: -${dirstax[_backtracks]}}")
		dirstax[_backtracks]=0
	fi
}

# register hook
add-zsh-hook chpwd dirstax-drop-dirstack-forward-history-on-chpwd

###
# Bindkey
##
bindkey "${dirstax[keybind_upward]}" dirstax-cd-upward
bindkey "${dirstax[keybind_forward]}" dirstax-cd-forward
bindkey "${dirstax[keybind_backward]}" dirstax-cd-backward
