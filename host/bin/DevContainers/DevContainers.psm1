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
    $t_image = Get-Image-Name -Tag "testing"
    $d_image = Get-Image-Name -Tag (Get-Date -Format "MM-dd-yy")
    if ($Force) {
        Write-Verbose "Building $t_image, $d_image without cache"
        &docker build --no-cache -t $t_image -t $d_image -f "$HOME\_setup\dotfiles\Dockerfile" "$HOME\_setup"
    } else {
        Write-Verbose "Building $t_image, $d_image with cache"
        &docker build -t $t_image -t $d_image -f "$HOME\_setup\dotfiles\Dockerfile" "$HOME\_setup"
    }
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
    if ($testing -eq $null) {
        Write-Warning -Message "No testing container to promote!"
        return
    }
    Remove-DevContainer -Tag "oldstable"
    Remove-DevContainer -Tag "stable"
    Remove-DevContainer -Tag "testing"

    $os_image = Get-Image-Name -Tag "oldstable"
    $s_image = Get-Image-Name -Tag "stable"
    $t_image = Get-Image-Name -Tag "testing"

    $stable = docker image ls --format "{{ .ID }}" (Get-Image-Name -Tag "stable")
    if ($stable -ne $null) {
        Write-Verbose "Stable -> OldStable"
        &docker tag $s_image $os_image
    }

    Write-Verbose "Testing -> Stable"
    &docker tag $t_image $s_image

    Write-Verbose "Removing Testing"
    &docker rmi $t_image
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
.Parameter Ports
Ports to forward from the container + 10k. Defaults to 8080 and 4123
#>
function Enter-DevContainer {
    param (
        [String]$Tag = "stable"
        [String[]]$Ports = @()
    )
    # Creating them is idempotent as long as it uses the same driver
    Write-Verbose "Forwarding ports"
    $Ports = $Ports + $("8080", "4123")
    $Ports = $Ports | ForEach-Object { "--port 1$_:$_" }
    $Ports = $Ports -Join " "
    Write-Verbose "Forwarded ports"

    # Creating them is idempotent as long as it uses the same driver
    Write-Verbose "Creating runtime volumes"
    &docker volume create code
    &docker volume create conda-envs
    &docker volume create conda-pkgs
    Write-Verbose "Created runtime volumes"

    # https://github.com/lemonade-command/lemonade
    Write-Verbose "Ensuring lemonade is running"
    $clipboards = Get-Job -Name "Lemonade" -ErrorAction SilentlyContinue |
        Where-Object { $_.State -eq "Running" } |
        Measure-Object
    if ($clipboards.count -lt 1) {
        Write-Verbose "Starting lemonade"
        Start-Job -Name "Lemonade" -ScriptBlock { lemonade.exe server }
    } else {
        Write-Verbose "Lemonade already running"
    }

    $container = Get-Container-Name -Tag $Tag
    Write-Verbose "Ensuring container named $container"
    $state = docker ps --all --filter "name=$container" --format "{{ .State }}"
    if ($state -eq "running") {
        Write-Verbose "Container is already running, connecting"
        &docker exec -it "$container" /usr/bin/zsh -i
    }
    elseif (($state -eq "stopped") -or ($state -eq "exited") ) {
        Write-Verbose "Container was stopped, starting"
        &docker start -ai "$container"
    }
    elseif ($state -eq $null) {
        $image = Get-Image-Name -Tag $Tag
        Write-Verbose "Running $image as a new container"
        &docker run -it --user 1111 `
            "$Ports" `
            --mount type=volume,src=conda-envs,target=/opt/conda/envs `
            --mount type=volume,src=conda-pkgs,target=/opt/conda/pkgs `
            --mount type=volume,src=code,target=/home/bryce/code `
            -v /var/run/docker.sock:/var/run/docker.sock `
            --name "$container" `
            $image
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
    Write-Verbose "Stopping lemonade"
    Remove-Job -Name "Lemonade" -Force

    $container = Get-Container-Name -Tag $Tag
    $state = docker ps --all --filter "name=$container" --format "{{ .State }}"
    Write-Verbose "Removing $container in current state $state"
    if ($state -ne $null) {
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
    return "brycekbargar.com/dev-container:$Tag"
}
