<#
.Synopsis
Builds a candidate dev container with latest deps/tools
.Description
Calls docker build and tags it with testing.
Uses --no-cache flag to ensure latest deps/tools.
Go make some tea, this will take awhile.
#>
function New-DevContainer {
    $dateTag = Get-Date -Format "MM-dd-yy"
    &docker build `
        --no-cache `
        -t "brycekbargar/dev-container:testing" `
        -t "brycekbargar/dev-container:$dateTag" `
        -f "$HOME\_setup\dotfiles\Dockerfile" "$HOME\_setup"
}

<#
.Synopsis
Promotes the current candidate dev container to the latest tag
.Description
Juggles tags from testing -> stable -> oldstable
#>
function Convert-DevContainer {
    Remove-DevContainer -Tag "oldstable"
    &docker tag `
        "brycekbargar/dev-container:stable" `
        "brycekbargar/dev-container:oldstable"
    Remove-DevContainer -Tag "stable"
    &docker tag `
        "brycekbargar/dev-container:testing" `
        "brycekbargar/dev-container:stable"
    Remove-DevContainer -Tag "testing"
    &docker rmi "brycekbargar/dev-container:testing" `

}

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

    $container = "$Tag-dev-container"
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
            --name "$container"
        "brycekbargar/dev-container:$Tag"
    }
    else {
        throw "$container found but with a weird state: $state"
    }
}

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
    $container = "brycekbargar/dev-container-$Tag"
    $state = docker ps --all --filter "name=$container" --format "{{ .State }}"
    if ($state -ne "") {
        &docker rm -v -f "$container"
    }
}
