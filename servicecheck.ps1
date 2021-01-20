[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function logMessage([string]$text)
{
	$currentTime = Get-Date -format "dd-MMM-yyyy HH:mm:ss"
	$toPrint = "$($currentTime) $($text)"
	Write-Host $toPrint
	Write $toPrint  | Out-File "results_$(get-date -f yyyyMMddHHmm).txt" -Append
}

logMessage "" 
logMessage "----------------------"
logMessage "Starting service check"
logMessage "----------------------"
logMessage ""

Get-Content .\wslist.txt | ForEach-Object {
	
	
	
    if ($_ -match $regex){
        
		if ($_) {
			
			$line = $_.Trim()
			
			if ($line.ToLower().StartsWith("www") -Or $line.ToLower().StartsWith("http://") -Or $line.ToLower().StartsWith("https://")) {
				
				if ($line.ToLower().StartsWith("www")) {
					$line = "http://$line"
				}						

				$HTTP_Request = [System.Net.WebRequest]::Create($line)
				$HTTP_Response = $HTTP_Request.GetResponse()
				$HTTP_Status = [int]$HTTP_Response.StatusCode
										
				If ($HTTP_Status -ge 200 -and $HTTP_Status -le 299) {
					logMessage "       $($HTTP_Status) => $($line)"
				}
				Else {
					logMessage "       The Site may be down, please check: $($line)"
				}
				
				If ($HTTP_Response -ne $null) { 
					$HTTP_Response.Close() 
				}	
				
			}
		} else {
			
		}
		
    }
	
	
}

logMessage ""
logMessage "-----------------------"
logMessage "Finishing service check"
logMessage "-----------------------"
logMessage ""





