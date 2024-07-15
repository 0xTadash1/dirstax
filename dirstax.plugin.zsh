#!/usr/bin/env zsh

# Entrypoint
.dirstax.init() {
	.dirstax.prerequisites
	.dirstax.settings

	.dirstax.setup_widgets
	.dirstax.bind_widgets
	.dirstax.setup_hook
}

.dirstax.prerequisites() {
	setopt AUTO_PUSHD
}

.dirstax.settings() {
	# Don't initialize with `=()` to avoid overriding user-defined key bindings
	typeset -Ax dirstax

	if [[ "$(uname -s)" == 'Darwin' ]]; then
		: ${dirstax[keybind_upward]:='^[[1;9A'}    # ⌘ + ↑
		: ${dirstax[keybind_forward]:='^[[1;9C'}   # ⌘ + →
		: ${dirstax[keybind_backward]:='^[[1;9D'}  # ⌘ + ←
	else
		: ${dirstax[keybind_upward]:='^[[1;3A'}    # alt + ↑
		: ${dirstax[keybind_forward]:='^[[1;3C'}   # alt + →
		: ${dirstax[keybind_backward]:='^[[1;3D'}  # alt + ←
	fi

	# for internal
	dirstax[_backtracks]='0'
	dirstax[_moving]='no'
}

.dirstax.setup_widgets() {
	dirstax-cd-upward() {
		zle push-input
		dirstax[_moving]='yes'
		cd ..
		zle accept-line
	}
	dirstax-cd-forward() {
		(( dirstax[_backtracks] == 0 )) && return 1

		zle push-input
		dirstax[_moving]='yes'
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
		dirstax[_moving]='yes'
		if [[ ${options[PUSHD_MINUS]} == 'off' ]]; then
			pushd +1 >/dev/null 2>&1
		else
			pushd -1 >/dev/null 2>&1
		fi
		dirstax[_backtracks]=$(( dirstax[_backtracks] + 1 ))
		zle accept-line
	}

	# register
	zle -N dirstax-cd-upward
	zle -N dirstax-cd-forward
	zle -N dirstax-cd-backward
}

.dirstax.bind_widgets() {
	bindkey "${dirstax[keybind_upward]}"   dirstax-cd-upward
	bindkey "${dirstax[keybind_forward]}"  dirstax-cd-forward
	bindkey "${dirstax[keybind_backward]}" dirstax-cd-backward
}

.dirstax.setup_hook() {
	autoload -Uz add-zsh-hook

	dirstax-drop-dirstack-forward-history() {
		if [[ "${dirstax[_moving]}" == 'yes' ]]; then
			dirstax[_moving]='no'
			return 0
		fi
		if (( dirstax[_backtracks] != 0 )); then
			dirstack=("${dirstack[@]:: -${dirstax[_backtracks]}}")
			dirstax[_backtracks]='0'
		fi
	}

	# register hook
	add-zsh-hook chpwd dirstax-drop-dirstack-forward-history
}

.dirstax.init
