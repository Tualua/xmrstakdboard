$udlayoutHome = New-UDLayout -Columns 1 -Content {
    New-UDCounter -Title "xmrstak miners" -Endpoint {
        $Cache:MinersCount
    }
    
}
$udpageHome = New-UDPage -Name 'Home' -Content {
    $udlayoutHome
}
