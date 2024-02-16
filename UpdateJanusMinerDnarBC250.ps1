Clear-Host
$creds = (Get-Credential user)
#Host name, make sure you're able to nslookup the hostname 
$BC250miners = @('R01BC250','R02BC250','R03BC250')
Foreach ($rig in $BC250miners)
{
    For ($i=1; $i -le 12; $i++) {

    $hostid = $i.ToString("00")
    $computername = "$rig-$hostid"
    # connect to rig 
    $session = New-SSHSession -ComputerName $computername -Credential $creds –AcceptKey
    $stream = New-SSHShellStream -SSHSession $session -TerminalName dumb

    # drop to the BASH shell
    $stream.WriteLine('shell')
    $stream.Read()
    sleep 1
    $stream.WriteLine('wget -4 https://raw.githubusercontent.com/kernelpanic0007/dnar/main/customminer.sh -O /home/user/customminer.sh')
    $stream.Read()
    sleep 3
    $stream.WriteLine('chmod +x /home/user/customminer.sh')
    $stream.Read()
    sleep 3
    $stream.WriteLine("sed -i 's/walletaddress/WALLETADDRESS/g' /home/user/customminer.sh && sed -i 's/nodeipaddressvar/NODEIPADDRESS/g' /home/user/customminer.sh && sed -i 's/nodeipport/NODEPORT/g' /home/user/customminer.sh && /home/user/customminer.sh")
    $stream.Read()
    sleep 3

    # close the SSH session and stream
    $stream.Close()
    # close session
    Remove-SSHSession -SSHSession $session | Out-Null

    }

}