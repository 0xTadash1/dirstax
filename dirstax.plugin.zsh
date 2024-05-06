#!/usr/bin/env zsh

###
# Prerequisites
##
setopt AUTO_PUSHD

###
# Settings
##
typeset -Ax dirstax
dirstax[backtracks]=0
: ${dirstax[keybind_up]:='^[[1;3A'}        # Alt + UP
: ${dirstax[keybind_forward]:='^[[1;3C'}   # Alt + RIGHT
: ${dirstax[keybind_backward]:='^[[1;3D'}  # Alt + LEFT
# for internal
dirstax[_moving]=no

###
# Main Widgets
##
cd-up() {
	zle push-input
	dirstax[_moving]=yes
	cd ..
	zle accept-line
}
cd-forward() {
	(( dirstax[backtracks] == 0 )) && return 1

	zle push-input
	dirstax[_moving]=yes
	if [[ ${options[PUSHD_MINUS]} == 'off' ]]; then
		pushd -0 >/dev/null 2>&1
	else
		pushd +0 >/dev/null 2>&1
	fi
	dirstax[backtracks]=$(( dirstax[backtracks] - 1 ))
	zle accept-line
}
cd-backward() {
	(( dirstax[backtracks] == ${#dirstack} )) && return 1

	zle push-input
	dirstax[_moving]=yes
	if [[ ${options[PUSHD_MINUS]} == 'off' ]]; then
		pushd +1 >/dev/null 2>&1
	else
		pushd -1 >/dev/null 2>&1
	fi
	dirstax[backtracks]=$(( dirstax[backtracks] + 1 ))
	zle accept-line
}
# register new widgets
zle -N cd-up
zle -N cd-forward
zle -N cd-backward

###
# Hook
##
drop-dirstack-forward-history-on-chpwd() {
	if [[ "${dirstax[_moving]}" == 'yes' ]]; then
		dirstax[_moving]=no
		return 0
	fi
	if (( dirstax[backtracks] != 0 )); then
		dirstack=("${dirstack[@]:: -${dirstax[backtracks]}}")
		dirstax[backtracks]=0
	fi
}

# register hook
add-zsh-hook chpwd drop-dirstack-forward-history-on-chpwd

###
# Bindkey
##
bindkey "${dirstax[keybind_up]}" cd-up
bindkey "${dirstax[keybind_forward]}" cd-forward
bindkey "${dirstax[keybind_backward]}" cd-backward
