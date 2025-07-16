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
