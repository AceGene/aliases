# src.ps1
#
# descr: this file is sourced via this repo's init.ps1
#
# todos: name clashing with gc and gp
#        perl path not generalized
#        git tab completion
#        rm invoke cmds

$ErrorActionPreference = "Stop"

function _src {
    #### hardcoded values
    $path_this = $PSCommandPath # not compatible with PS version < 3.0
    $dir_this = $PSScriptRoot # not compatible with PS version < 3.0
    $dir_repo = "$(pushd $(git -C $($dir_this) rev-parse --show-toplevel); echo $PWD; popd)"
    $dir_bin = "$($dir_repo)\bin"
    $path_prof = "$($HOME)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    #### exports
    $global:GWSA = $dir_repo
    $env:PATH += ";$($dir_bin)"
    #### cfg
    $editor = 'code'
    $git_number = "$($dir_bin)\git-number"; $perl = 'C:\Program Files\Git\usr\bin\perl5.32.0.exe'
    $use_git_number = $false; if ($(Test-Path $git_number) -And $(Test-Path $perl)){$use_git_number = $true}
    if ($use_git_number){$gitcmd = $perl; $gitargs = @("'$($dir_bin)\git-number'")}
    else{echo "Warning: git-number or perl not found, defaulting to git"; $gitcmd = 'git'; $gitargs = @("-c","color.status=always")}
    #### funcs
    Invoke-Expression "function global:_git_or_gn {& '$($gitcmd)' $($gitargs -join ' ') @args}"
    function _cd_parent_aliases {
        $num_cd_aliases = $args[0]; $body = 'cd '; $name = '.'
        for ($i=0; $i -lt $num_cd_aliases; $i=$i+1 ) {
            $name += '.'; $body += '..\'
            Invoke-Expression "function global:$($name) {$($body)}"
        }
    }
    #### aliases
    ## git
    function global:gn {& _git_or_gn @args}
    Invoke-Expression "function global:gg {if (`$$use_git_number) { git -c color.status=always status -sb | select -first 1 && & global:_git_or_gn -s} else {git status -sb}}"
    function global:ga {& _git_or_gn 'add' @args}
    function global:gc {& _git_or_gn 'checkout' @args}
    function global:gr {& _git_or_gn 'reset' @args}
    function global:gd {& _git_or_gn 'diff' @args}
    function global:gf {git fetch}
    function global:gp {git pull}
    function global:grb {git rebase}
    function global:gcp {git cherry-pick}
    function global:gcm {git checkout master}
    function global:grom {git fetch && git rebase origin/master}
    function global:lg {git log --date=format:'%y-%m-%d %H:%M' --pretty=format:'%h%x20%x20%Cred%ad%x20%x20%Cblue%an%x20%x20%Creset%s'}
    function global:lg {global:gl}
    function global:log {git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n          %C(white)%s%C(reset)%n          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'}
    function global:ggg {git submodule foreach git status -sb}
    function global:gsu {git submodule update}
    function global:gss {git submodule status}
    ## dirs
    _cd_parent_aliases 10
    function global:dl {cd "$($HOME)/Downloads"}
    function global:dsk {cd "$($HOME)/Desktop"}
    function global:doc {cd "$($HOME)/Documents"}
    function global:gwsa {cd $global:GWSA; gg}
    function global:gwsv {cd $global:GWSA; gg}
    ## misc
    Set-Alias -Scope 'global' -Name 'op' -Value 'start'
    Invoke-Expression "function global:rc {& '$editor' '$path_prof'}"
    Invoke-Expression "function global:rcg {& '$editor' '$path_this'}"
    Invoke-Expression "function global:rcs {. '$path_prof'}"
    Invoke-Expression "function global:rcgs {. '$path_this'}"
    Set-Alias -Scope 'global' -Name 'rs' -Value 'clear'
}

_src @args