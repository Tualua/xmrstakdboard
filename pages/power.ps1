$udlayoutPower = New-UDLayout -Columns 4 -Content {
    ForEach ($miner in $Cache:Miners)
    {
        New-UDMonitor -Title $miner.macaddr -Type Line -DataPointHistory 10 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63' -Endpoint {
            Get-InstantPowerReading -Hostname $miner.bmc -Username $miner.bmc_user -Password $miner.bmc_user_pass -IPMITool $IPMITool.FullName| Out-UDMonitorData
        }    
    }    
}
$udpagePower = New-UDPage -Name 'Power' -Content {
    $udlayoutPower    
}