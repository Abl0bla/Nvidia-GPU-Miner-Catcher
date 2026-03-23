# Get raw data from NVIDIA GPU (Utilization, Power, Temp, Clock)
$data = nvidia-smi --query-gpu=utilization.gpu,power.draw,temperature.gpu,clocks.current.graphics --format=csv,noheader,nounits
$split = $data.Split(',')

# Parsing data into variables
$usage = $split[0].Trim(); $watts = $split[1].Trim(); $temp = $split[2].Trim(); $clock = $split[3].Trim()
$timestamp = Get-Date -Format "HH:mm:ss"

# Identify the process with the highest CPU consumption at the time of logging
$topProcess = (Get-Process | Sort-Object CPU -Descending | Select-Object -First 1).Name

# Format and append log to Public Documents (environment agnostic)
$logPath = "$env:PUBLIC\Documents\WinSelfDiag.log"
$logEntry = "$timestamp | GPU: $usage% | Pwr: $watts W | Tmp: $temp C | Clk: $clock MHz | Owner: $topProcess"
$logEntry | Out-File -FilePath $logPath -Append