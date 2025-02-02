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
	setopt NO_PUSHD_IGNORE_DUPS
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
	dirstax[_status]='idle'
}

.dirstax.setup_widgets() {
	dirstax-cd-upward() {
		zle push-line-or-edit
		dirstax[_status]='cd-upward'
		# `pushd -q` does not trigger the `chpwd` hook
		cd ..
		zle accept-line
	}
	dirstax-cd-forward() {
		(( dirstax[_backtracks] == 0 )) && return 1

		zle push-line-or-edit
		dirstax[_status]='cd-forward'
		if [[ ${options[PUSHD_MINUS]} == 'off' ]]; then
			pushd -0 >/dev/null 2>&1
		else
			pushd +0 >/dev/null 2>&1
		fi
		zle accept-line
	}
	dirstax-cd-backward() {
		(( dirstax[_backtracks] == ${#dirstack} )) && return 1

		zle push-line-or-edit
		dirstax[_status]='cd-backward'
		if [[ ${options[PUSHD_MINUS]} == 'off' ]]; then
			pushd +1 >/dev/null 2>&1
		else
			pushd -1 >/dev/null 2>&1
		fi
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
		case "${dirstax[_status]}" in
			cd-backward)
				(( dirstax[_backtracks]++ )) ;;
			cd-forward)
				(( dirstax[_backtracks]-- )) ;;
			idle|cd-upward)
				if (( ${dirstax[_backtracks]} > 0 )); then
					dirstack=("${dirstack[@]:: -${dirstax[_backtracks]}}")
				fi
				dirstax[_backtracks]='0'
				;;
			*)
				print >/dev/stderr 'dirstax:' \
					'`${dirstax[_status]}` must be `idle`, `cd-upward`, `cd-backward` or `cd-forward`.'
				;;
		esac
		dirstax[_status]='idle'
	}

	# register hook
	add-zsh-hook chpwd dirstax-drop-dirstack-forward-history
}

.dirstax.init
