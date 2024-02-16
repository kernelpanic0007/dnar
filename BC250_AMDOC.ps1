Clear-Host
$AMDOC = @(
    [PSCustomObject]@{
        ComputerName = "R03BC250-01"
        CoreClock = 1601
        CoreVoltage = 801
    }
    ,
    [PSCustomObject]@{
        ComputerName = "R03BC250-02"
        CoreClock = 1602
        CoreVoltage = 802
    }
)

$creds = (Get-Credential user)

Foreach ($oc in $AMDOC)
{
    # connect to rig 
    $session = New-SSHSession -ComputerName $oc.ComputerName -Credential $creds –AcceptKey
    $stream = New-SSHShellStream -SSHSession $session -TerminalName dumb

    # drop to the BASH shell
    $stream.WriteLine('shell')
    $stream.Read()
    sleep 1
    $cmd = ('sed -i "s/CORE_CLOCK=.*/CORE_CLOCK=\"' + $oc.CoreClock + '\"/g" /hive-config/amd-oc.conf && sed -i "s/CORE_VDDC=.*/CORE_VDDC=\"' + $oc.CoreVoltage + '\"/g" /hive-config/amd-oc.conf')
    Write-Host $cmd
    $stream.WriteLine($cmd)
    $stream.Read()
    sleep 3
    $stream.WriteLine('/hive/sbin/amd-oc')
    $stream.Read()
    sleep 3
    # close the SSH session and stream
    $stream.Close()
    # close session
    Remove-SSHSession -SSHSession $session | Out-Null
}
