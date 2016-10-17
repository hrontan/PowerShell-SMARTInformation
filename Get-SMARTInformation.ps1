function Get-SMARTInformation(){
	$attributes=@{
		0x01="Raw Read Error Rate";
		0x02="Throughput Performance";
		0x03="Spin Up Time";
		0x04="Start/Stop Count";
		0x05="Reallocated Sectors Count";
		0x07="Seek Error Rate";
		0x08="Seek Time Performance";
		0x09="Power-On Hours";
		0x0A="Spin Retry Count";
		0x0B="Recalibration Retries";
		0x0C="Device Power Cycle Count";
		0x0D="Soft Read Error Rate";
		0xC1="Load/Unload Cycle Count";
		0xC2="Temperature";
		0xC3="Hardware ECC recovered";
		0xC4="Reallocation Event Count";
		0xC5="Current Pending Sector Count";
		0xC6="Off-Line Scan Uncorrectable Sector Count";
		0xC7="UltraDMA CRC Error Count";
		0xC8="Write Error Rate (Multi Zone Error Rate)";
		0xC9="Soft Read Error Rate";
		0xCA="Data Address Mark Error";
		0xCB="Run Out Cancel";
		0xCC="Soft ECC Correction";
		0xCD="Thermal Asperity Rate";
		0xCE="Flying Height";
		0xCF="Spin High Current";
		0xD0="Spin Buzz";
		0xD1="Offline Seek Performance";
		0xD2="Vibration During Write";
		0xD3="Vibration During Read";
		0xD4="Shock During Write";
		0xDC="Disk Shift";
		0xDD="G-Sense Error Rate";
		0xDE="Loaded Hours";
		0xDF="Load/Unload Retry Count";
		0xE0="Load Friction";
		0xE2="Load-in Time";
		0xE3="Torque Amplification Count";
		0xE4="Power-Off Retract Count";
		0xE6="GMR Head Amplitude";
		0xF0="Head Flying Hours";
		0xFA="Read Error Retry Rate";
	}

	$attrname = "Value", "Worst", "Raw1", "Raw2", "Raw3", "Raw4", "Raw5", "Raw6", "-";

	$smart_data=Get-WmiObject -Namespace root/WMI -Class MSStorageDriver_ATAPISmartData;

	for($di=0; $di -lt $smart_data.Length; $di++){

		$vender_specific=$smart_data[$di].VendorSpecific;

		$path = $smart_data[$di].__PATH;
		$pattern = ".*Prod_(.*)\\\\.*";
		Write-Host "Name: $($path -replace $pattern,'$1')"

		Write-Host "$('ID'.PadLeft(3)) |" -NoNewLine;
		Write-Host "$('Attribute Name'.PadRight(40)) |" -NoNewLine;
		Write-Host "$('Flags'.PadRight('6')) |" -NoNewLine;
	
		for($i=0;$i -lt $attrname.Length;$i++){
			Write-Host "$($attrname[$i].PadLeft('6'))" -NoNewLine;
		}
		Write-Host;

		for($i=0;$i -lt 109;$i++){
			Write-Host "-" -NoNewLine;
		}
		Write-Host;

		for($i=2;$i -lt $vender_specific.Length;$i+=12){

			if(!$attributes.ContainsKey([int]$vender_specific[$i])){
				continue;
			}
		
			Write-Host "$($vender_specific[$i].ToString('X2').PadLeft(3)) |" -NoNewLine;
			Write-Host "$($attributes[[int]$vender_specific[$i]].PadRight(40)) |" -NoNewLine;
			Write-Host "$($vender_Specific[$i+1].ToString('X2').PadLeft(3))" -NoNewLine;
			Write-Host "$($vender_Specific[$i+2].ToString('X2').PadLeft(3)) |" -NoNewLine;

			for($j=3;$j -lt 12;$j++){
				Write-Host $vender_specific[$i+$j].ToString().PadLeft(6) -NoNewLine;
			}
			Write-Host;

		}
		Write-Host;
	}
}
