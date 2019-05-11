Import-Module -Name "$PSSCriptRoot\xmrstak.psm1"
. "$PSSCriptRoot\pages\home.ps1"
. "$PSSCriptRoot\pages\power.ps1"
. "$PSSCriptRoot\pages\hashrate.ps1"

$configfile = Get-Item -Path ".\config\miners.json"
$IPMITool = Get-Item -Path ".\tools\ipmitool.exe"
$EndpointInit = New-UDEndpointInitialization -Function @("Get-InstantPowerReading","Get-MinersFromFile") -Variable @("configFile","IPMITool")
$Schedule5Min = New-UDEndpointSchedule -Every 1 -Minute
$udepMiners = New-UDEndpoint -Schedule $Schedule5Min -Endpoint {
    $Cache:MinersCount = 0
    $Cache:Miners = $(Get-MinersFromFile -Path $configfile)
    $Cache:MinersCount = $Cache:Miners.Count
}
$XMRStakDashboard = New-UDDashboard -Title 'xmrstak Dashboard' -Pages @($udpageHome,$udpagePower) -EndpointInitialization $EndpointInit
$Server = Start-UDDashboard -Port 1000 -Dashboard $XMRStakDashboard -Endpoint $udepMiners
