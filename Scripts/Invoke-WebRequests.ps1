$ErrorActionPreference = 'Stop';

Write-Host 'Running Invoke-WebRequests.ps1';

$commandletArgs = @{
  UseBasicParsing = $true;
  Method = 'Head'
};
$urls = @(
  'https://aws.amazon.com'
);

if (Test-Path env:HTTPS_PROXY) {
  $commandletArgs['Proxy'] = $env:HTTPS_PROXY;
}

foreach ($url in $urls) {
  $commandletArgs['Uri'] = $url;
  Write-Host ('Requesting {0}' -f $url);
  Invoke-WebRequest @commandletArgs;
}
