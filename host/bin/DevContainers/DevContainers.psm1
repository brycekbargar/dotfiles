<#
.Synopsis
Builds a candidate dev container with latest deps/tools
.Description
Calls docker build and tags it with testing.
Uses --no-cache flag to ensure latest deps/tools (unless you unforce the cache bust).
Go make some tea, this will take awhile.
.Parameter Force
Whether to bust the docker build cache. Defaults to True
#>
function New-DevContainer {
    param (
        [Boolean]$Force = $True
    )
    $cache = If ($Force) { "--no-cache" } Else { "" }
    $dateTag = Get-Date -Format "MM-dd-yy"
    &docker build `
        $cache `
        -t (Get-Image-Name -Tag "testing") `
        -t (Get-Image-Name -Tag $dateTag) `
        -f "$HOME\_setup\dotfiles\Dockerfile" `
        "$HOME\_setup"
}
Set-Alias -Name ide-build -Value New-DevContainer

<#
.Synopsis
Promotes the current candidate dev container to the latest tag
.Description
Juggles tags from testing -> stable -> oldstable.
Warning! It will stop any running containers.
#>
function Convert-DevContainer {
    $testing = docker image ls --format "{{ .ID }}" (Get-Image-Name -Tag "testing")
    if ($testing -eq "") {
        Write-Warning -Message "No testing container to promote!"
        return
    }
    Remove-DevContainer -Tag "oldstable"
    Remove-DevContainer -Tag "stable"
    Remove-DevContainer -Tag "testing"

    $stable = docker image ls --format "{{ .ID }}" (Get-Image-Name -Tag "stable")
    if ($stable -ne "") {
        &docker tag `
        (Get-Image-Name -Tag "stable") `
        (Get-Image-Name -Tag "oldstable")
    }
    &docker tag `
    (Get-Image-Name -Tag "testing") `
    (Get-Image-Name -Tag "stable")
    &docker rmi (Get-Image-Name -Tag "testing")
}
Set-Alias -Name ide-promote -Value Convert-DevContainer

<#
.Synopsis
Launches a dev container shell
.Description
If the container doesn't exist, a new one is launched.
If the container does exist, a new shell session is attached.
.Parameter Tag
The image tag to enter. Defaults to "stable", but can be "testing" or "oldstable"
#>
function Enter-DevContainer {
    param (
        [String]$Tag = "stable"
    )
    # Creating them is idempotent as long as it uses the same driver
    &docker create volume code
    &docker create volume conda-envs
    &docker create volume conda-pkgs

    # https://github.com/lemonade-command/lemonade
    $clipboards = Get-Job -Name "Lemonade" -ErrorAction ContinueSilently |
        Where-Object { $_.State -eq "Running" } |
        Measure-Object
    if ($clipboards.count -lt 1) {
        Start-Job -Name "Lemonade" -ScriptBlock { lemonade.exe server }
    }

    $container = Get-Container-Name -Tag Tag
    $state = docker ps --all --filter "name=$container" --format "{{ .State }}"
    if ($state -eq "running") {
        &docker exec -it "$container" /usr/bin/zsh -i
    }
    elseif ($state -eq "stopped") {
        &docker start -a "$container"
    }
    elseif ($state -eq "") {
        &docker run -it --user 1111 `
            --mount type=volume, src=conda-envs, target=/conda/envs `
            --mount type=volume, src=conda-pkgs, target=/conda/pkgs `
            --mount type=volume, src=code, target=/home/bryce/code `
            -v /var/run/docker.sock:/var/run/docker.sock `
            --name "$container" `
        (Get-Image-Name -Tag $Tag)
    }
    else {
        Write-Warning "$container found but with a weird state: $state"
    }
}
Set-Alias -Name ide-up -Value Enter-DevContainer

<#
.Synopsis
Stops a dev container shell
.Description
The container will be force removed along with any anonymous volumes.
.Parameter Tag
The image tag to enter. Defaults to "stable", but can be "testing" or "oldstable"
#>
function Remove-DevContainer {
    param (
        [String]$Tag = "stable"
    )
    Remove-Job -Name "Lemonade" -Force

    $container = Get-Container-Name -Tag Tag
    $state = docker ps --all --filter "name=$container" --format "{{ .State }}"
    if ($state -ne "") {
        &docker rm -v -f "$container"
    }
}
Set-Alias -Name ide-down -Value Remove-DevContainer

function Get-Container-Name {
    param (
        [String]$Tag
    )
    return "$Tag-dev-container"
}
function Get-Image-Name {
    param (
        [String]$Tag
    )
    return "brycekbargar/dev-container:$Tag"
}
