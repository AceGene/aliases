#!/bin/bash
#
# descr: adds sourcing of this repo's src.bash in ~/.bash_aliases

set -u

__parse_script_arguments() {
    while (( "${#}" )); do
        case "${1}" in
            --operating-system|--os|-o)
                case "${2}" in
                    linux|windows|wsl) os="${2}"; shift ;;
                    *) echo "ERROR: unrecognized ${1} parameter ${2}" && return 1 ;;
                esac
                ;;
            *) echo "ERROR: arg ${1} is unexpected" && return 2 ;;
        esac
        shift
    done
    args="--os ${os}"
}

################&&!%@@%!&&################ AUTO GENERATED CODE BELOW THIS LINE ################&&!%@@%!&&################
# yymmdd: 210228
# generation cmd on the following line:
# python "${GWSPY}/write-btw.py" "-t" "bash" "-w" "${GWSA}/init/init.bash" "-x" "__echo" "__check_if_objs_exist" "__append_line_to_file_if_not_found"

__echo(){
    #### echo that can watch the silent and verbose variables from the scope it was called from
    local out=''
    local send_out='false'; local stderr='false'; local obj_set='false'; local end_char='\n'
    while (( "${#}" )); do
        case "${1}" in
            --err|-e) stderr='true';;
            --verbose|-v) [ "${verbose}" == 'false' ] || send_out='true';;
            --silent|-s) [ "${silent}" == 'true' ] || send_out='true';;
            --no-newline|-n) end_char='';;
            -*) # convert flags grouped as in -vrb to -v -r -b
                case "${1:1}" in
                    "") echo "ERROR: arg ${1} is unexpected" && return 2;;
                    '-') break;;
                    [a-zA-Z]) echo "ERROR: arg ${1} is unexpected" && return 2;;
                    *[!a-zA-Z]*) echo "ERROR: arg ${1} is unexpected" && return 2;;
                    *);;
                esac
                set -- 'dummy' $(for ((i=1;i<${#1};i++)); do echo "-${1:$i:1}"; done) "${@:2}" # implicit shift
                ;;
            *)
                [ "${obj_set}" == 'false' ] && obj_set='true' || ! echo "ERROR: too many objs for __echo" || return 2
                out="${1}"
                ;;
        esac
        shift
    done
    [ "${send_out}" == 'false' ] || { [ "${stderr}" == 'true' ] && >&2 printf "${out}${end_char}" || printf "${out}${end_char}"; }
}

__check_if_objs_exist() {
    local objs=(); local type=''; local out=''
    local create='false'; local verbose='false'; local silent='false'; local send_out='false'; local obj_set='false'
    while (( "${#}" )); do
        case "${1}" in
            --type|-t)
                case "${2}" in
                    file|f|dir|d) type="${2}"; shift;;
                    *) __echo -se "ERROR: bad cmd arg combination '${1} ${2}'"; return 1;;
                esac
                ;;
            --create|-c) create='true';;
            --out|-o) send_out='true';;
            --verbose|-v) verbose='true';;
            --silent|-s) silent='true';;
            -*) # convert flags grouped as in -vrb to -v -r -b
                case "${1:1}" in
                    "") __echo -se "ERROR: arg ${1} is unexpected" && return 2;;
                    '-') break;;
                    [a-zA-Z]) __echo -se "ERROR: arg ${1} is unexpected" && return 2;;
                    *[!a-zA-Z]*) __echo -se "ERROR: arg ${1} is unexpected" && return 2;;
                    *);;
                esac
                set -- 'dummy' $(for ((i=1;i<${#1};i++)); do echo "-${1:$i:1}"; done) "${@:2}" # implicit shift
                ;;
            *) objs+=("${1}");;
        esac
        shift
    done

    local cmd=''; local flag=''
    case "${type}" in
        file|f) cmd='touch'; flag='f';;
        dir|d) cmd='mkdir'; flag='d';;
        *) __echo -se "ERROR: arg type '${1}' unexpected" && return 5;;
    esac
    for ((i=0; i<${#objs[@]}; i++)); do
        if [ "${create}" == 'true' ] && [ ! -"${flag}" "${objs[$i]}" ]; then
            "${cmd}" "${objs[$i]}" && __echo -ve "INFO: created ${type}: ${objs[$i]}" || ! __echo -se "ERROR: could not create ${type}: ${objs[$i]}" || return 4
            [ "${send_out}" == 'true' ] && out='created'
        fi
        [ ! -"${flag}" "${objs[$i]}" ] && __echo -ve "ERROR: ${objs[$i]} does not exist" && return 1
    done
    printf "${out}"
}

__append_line_to_file_if_not_found() {
    local file=''; local lines=()
    local verbose='false'; local silent='false'
    while (( "${#}" )); do
        case "${1}" in
            --file|-f) file="${2}"; shift;;
            --line|-l) line="${2}"; shift;;
            --verbose|-v) verbose='true';;
            --silent|-s) silent='true';;
            -*) # convert flags grouped as in -vrb to -v -r -b
                case "${1:1}" in
                    '-') break;;
                    "") echo "ERROR: arg ${1} is unexpected" && return 2;;
                    [a-zA-Z]) echo "ERROR: arg ${1} is unexpected" && return 2;;
                    *[!a-zA-Z]*) echo "ERROR: arg ${1} is unexpected" && return 2;;
                    *);;
                esac
                set -- 'dummy' $(for ((i=1;i<${#1};i++)); do echo "-${1:$i:1}"; done) "${@:2}" # implicit shift
                ;;
            *) lines+=("${1}");;
        esac
        shift
    done
    for line in "${@}"; do lines+=("${line}"); done
    [ ! -f "${file}" ] && __echo -se "ERROR: file not found: ${file}"
    for line in "${lines[@]}"; do
        if ! grep -qF -- "${line}" "${file}"; then
            [ "$(tail -c 1 "${file}")" != '' ] && printf '\n' >> "${file}" # ensure trailing new line
            printf "${line}\n" >> "${file}" && __echo -ve "INFO: '${line}' added to '${file}'" || ! __echo -se "ERROR: could not add ${line} to ${file}" || return 1
        fi
    done
}
################&&!%@@%!&&################ AUTO GENERATED CODE ABOVE THIS LINE ################&&!%@@%!&&################

_init () {
    ## paths
    #### hardcoded vars
    local path_this="${BASH_SOURCE[0]}"
    local dir_this="$(cd "$(dirname "${path_this}")"; pwd -P)" && [ "${dir_this}" != '' ] || ! __echo -se "ERROR: dir_this=''" || return 1
    local dir_repo="$(cd "${dir_this}" && cd $(git rev-parse --show-toplevel) && echo ${PWD})" && [ "${dir_repo}" != '' ] || ! __echo -se "ERROR: dir_repo=''" || return 1
    local dir_git_hooks="${dir_repo}/.git-hooks"
    ## files
    local bash_aliases="${HOME}/.bash_aliases"
    local bashrc="${HOME}/.bashrc"
    local src="${dir_repo}/src/src.bash"
    #### default vars
    local args=''; local os=''
    #### fill script vars with cmd line args and/or default values where applicable
    __parse_script_arguments "${@}" || return "1${?}"
    #### setup git hooks
    local dir_git_hooks_config="$(git config --local core.hooksPath)"
    [ "${dir_git_hooks_config}" != ${dir_git_hooks} ] && [ "${dir_git_hooks_config}" != '' ] && echo "WARNING: ${path_this}: overwriting old 'git config --local core.hooksPath' value of '${dir_git_hooks_config}'"
    [ "${dir_git_hooks_config}" != ${dir_git_hooks} ] && echo "EXEC: git config --local core.hooksPath ${dir_git_hooks}" && (cd "${dir_repo}"; git config --local core.hooksPath "${dir_git_hooks}")
    #### lines to add to files
    local lines_bash_aliases=('[ -f '"'${src}'"' ] && . '"'${src}' ${args}")
    #### create files/dirs if not found
    __check_if_objs_exist -ct 'file' "${bash_aliases}" || return "${?}"
    local status=''; status="$(__check_if_objs_exist -cot 'file' "${bashrc}")" || return "${?}"; [ "${status}" == 'created' ] && echo ". '${bash_aliases}'" >> "${bashrc}"    #### add lines to files if not found
    #### add lines to files if not found
    __append_line_to_file_if_not_found -vf "${bash_aliases}" "${lines_bash_aliases[@]}"
}

_init "${@}" || exit "${?}"