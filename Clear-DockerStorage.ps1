<#
  .SYNOPSIS
    Clear docker related storage.
  .DESCRIPTION
    Removes all docker images and volumes. Runs docker-leak-check to clear
    additional storage
#>

$ErrorActionPreference = 'Stop';

Write-Host 'The Clear-DockerStorage script should only be run after a reboot';
$selection = Read-Host -Prompt 'Reboot computer? [y/n]';

if ($selection -eq 'y') {
  Write-Host 'Rerun the script after reboot is complete';
  Restart-Computer -Force;
  return;
}

# Stop current container
$dockerArgs = @('rm','--force','buildbot');

Write-Host ('docker {0}' -f ($dockerArgs -join " "));
$p = Start-Process 'docker.exe' -ArgumentList $dockerArgs -PassThru -NoNewWindow -Wait;

if ($p.ExitCode -ne 0) {
  Write-Warning 'An error occurred when stopping buildbot container';
}

# Run system prune
$dockerArgs = @(
  'system',
  'prune',
  '--all',
  '--volumes',
  '--force'
)

Write-Host ('docker {0}' -f ($dockerArgs -join " "));
$p = Start-Process 'docker.exe' -ArgumentList $dockerArgs -PassThru -NoNewWindow -Wait;

if ($p.ExitCode -ne 0) {
  Write-Error 'Unable to prune system';
}

# Run docker leak check
$leakCheckExe = Join-Path $PSScriptRoot 'docker-leak-check.exe';

if (!(Test-Path $leakCheckExe)) {

  $scriptArgs = @{
    Uri = 'https://github.com/lowenna/docker-leak-check/raw/refs/heads/master/docker-leak-check.exe';
    OutFile = $leakCheckExe;
  };

  if (Test-Path env:HTTPS_PROXY) {
    $scriptArgs['Proxy'] = $env:HTTPS_PROXY;
  }

  Invoke-WebRequest @scriptArgs;
}

Stop-Service docker;

$dockerArgs = @('-remove')
Write-Host ('docker-leak-check {0}' -f ($dockerArgs -join " "));
$p = Start-Process $leakCheckExe -ArgumentList $dockerArgs -PassThru -NoNewWindow -Wait;

Start-Service docker;
