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

## Worker Host Administration Scripts
The root of the repository contains scripts to administer the Windows host
running a Buildbot Worker. All scripts act on the Windows host directly and are
not used by the running container.

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

## Worker Container Administration Scripts
The [Scripts](Scripts) directory contains scripts that can be run within the
Buildbot container at startup. The
[`webkitdev:buildbot-worker` image](https://github.com/WebKitForWindows/docker-webkit-dev/tree/main/buildbot-worker)
looks for `.ps1` scripts within `C:/Scripts` and runs them before starting the
Buildbot worker. This allows injection of environment specific configuration
into the Buildbot worker through a Docker volume.

#### Invoke-WebRequests.ps1
> Setup certificates by requesting URLs used in the build process

The WebKit build process stores artifacts in Amazon's S3. Requesting the root
AWS URL populates the certificates preventing an error within Python code
interacting with S3.

> [!NOTE]
> This error is only seen running on Windows Server hosts so it is not included
> in `webkitdev/buildbot-worker`.
