# Buildbot Scripts
> Scripts for administering WebKit Buildbot workers

## Downloading
The scripts are meant to run on a Windows Server without access to a GUI so the
following commands can be used to download and extract the zip file within a
Powershell prompt.

```powershell
Invoke-WebRequest `
  -Uri https://github.com/WebKitForWindows/buildbot-scripts/archive/refs/heads/main.zip `
  -OutFile scripts.zip

Expand-Archive `
  -Path scripts.zip `
  -DestinationPath . `
  -Force
```

## Worker Administration Scripts
The repository contains scripts to administer a Buildbot Worker.

#### Clear-DockerStorage.ps1
> Clears docker storage removing all images, containers and volumes

Use this to clear Docker storage on a Windows Server host before downloading an
updated Docker image for the Buildbot. Stop the locally running Buildbot
container before running the script to ensure all storage is cleared.

The script combines
[`docker system prune`](https://docs.docker.com/reference/cli/docker/system/prune)
with [`docker-leak-check`](https://github.com/lowenna/docker-leak-check) to
completely clear storage used by the Buildbot images.

> [!WARNING]  
> The script is only relevant for Windows Server hosts. Use
> `docker system prune` directly for storage cleanup on Windows 10/11.

```powershell
./Clear-DockerStorage.ps1
```
