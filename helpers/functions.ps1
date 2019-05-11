#Functions
function Get-MinersFromFile 
{
  param
  (
    [Parameter(Mandatory=$true)][string]
    $Path    
  )
  $hashMiners = @()
  $config = Get-Content -Path $Path | ConvertFrom-Json 
  ForEach ($miner in $config.miners)
  {
    $hashMiner = @{}
    foreach ($property in $miner.PSObject.Properties) 
    {
      $hashMiner[$property.Name] = $property.Value
    }
    $hashMiners += $hashMiner
    
  }  
  return $hashMiners
}
function Get-InstantPowerReading
{
  param (
    [string]$Hostname,
    [string]$Username,
    [string]$Password,
    [string]$IPMITool
  )
  $pinfo = New-Object System.Diagnostics.ProcessStartInfo
  $pinfo.FileName = $IPMITool
  $pinfo.RedirectStandardError = $true
  $pinfo.RedirectStandardOutput = $true
  $pinfo.UseShellExecute = $false
  $pinfo.Arguments = "-H $Hostname -U $Username -P $Password -I lanplus dcmi power reading"
  $p = New-Object System.Diagnostics.Process
  $p.StartInfo = $pinfo
  $p.Start() | Out-Null
  $p.WaitForExit()

  $out = @{}
  $line = $p.StandardOutput.ReadLine()

  Do
  {
    $line = $p.StandardOutput.ReadLine()
    If (($line) -and (($line.IndexOf(':') -ge 1)))
    {
      $out.Add($($line.Substring(0,$line.IndexOf(':'))).Trim(),$line.Substring($line.IndexOf(':')+1,$line.Length-$line.IndexOf(':')-1).Trim())
    
    }
  
  }
  While ($line -ne $null)
  return [int]$out['Instantaneous power reading'].Substring(0,$out['Instantaneous power reading'].IndexOf(' '))  
}