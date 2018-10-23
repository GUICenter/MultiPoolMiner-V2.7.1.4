using module ..\Include.psm1

$Path = ".\Bin\\SRBMiner\\SRBMiner-CN.exe"
$Uri = "http://www.srbminer.com/download.html"

$Commands = [PSCustomObject]@{
	"cryptonight-monero" = "" #CryptoNight-Monero
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
    [PSCustomObject]@{
        Type = "AMD"
        Path = $Path
        Arguments = "--ccryptonighttype normalv8 --cpool $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) --cwallet $($Pools.(Get-Algorithm $_).User) --cpassword $($Pools.(Get-Algorithm $_).Pass)$($Commands.$_) --cgputhreads 2 --cgpuintensity 0 --apienable true"
        HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
        API = "SRBMiner"
		Port = 21555
        URI = $Uri
    }
}
