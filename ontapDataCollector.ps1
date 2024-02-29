# NetApp Solutions Engineering Team
# Pre-requisites:
# 1. Ensure host has connectivity to the ONTAP system
# 2. "DataONTAP" module should be pre-installed. if not install using "Install-Module -Name DataONTAP -RequiredVersion 9.7.1.1"

# Running the script
# Execute the script "./ontapDataCollector.ps1"

# User inputs
$ONTAPEndpoint = Read-Host "Please enter your ONTAP endpoint"
$ONTAPUsername = Read-Host "Please enter your username"
$ONTAPPassword = Read-Host "Please enter your password" | ConvertTo-SecureString -AsPlainText -Force
$ONTAPCredential = New-Object System.Management.Automation.PSCredential($ONTAPUsername, $ONTAPPassword)

$runCommand1 = Read-Host "Get System Statistics (yes/no)"
$runCommand2 = Read-Host "Get Volume Latency (yes/no)"
$runCommand3 = Read-Host "Get Volume Performance (yes/no)"
$runCommand4 = Read-Host "Get Volume Characteristics (yes/no)"
$iterations = Read-Host "Enter the number of iterations"

# Check if DataONTAP module is available
if (!(Get-Module -ListAvailable -Name DataONTAP)) {
    Write-Host "DataONTAP module not found. Please install it and try again."
    exit
}

# Import the DataONTAP module
Import-Module DataONTAP

# Connect to the ONTAP instance
Connect-NcController $ONTAPEndpoint -Credential $ONTAPCredential

# Run the commands based on user input and save the output to respective files
if ($runCommand1 -eq "yes") {
    $command1 = Invoke-NcSsh "statistics system show -interval 5 -iterations $iterations"
    $command1 | Out-File -FilePath "systemStats.txt"
}

if ($runCommand2 -eq "yes") {
    $command2 = Invoke-NcSsh "qos statistics volume latency show -iterations $iterations"
    $command2 | Out-File -FilePath "volLatency.txt"
}

if ($runCommand3 -eq "yes") {
    $command3 = Invoke-NcSsh "qos statistics volume performance show -iterations $iterations"
    $command3 | Out-File -FilePath "volPerf.txt"
}

if ($runCommand4 -eq "yes") {
    $command4 = Invoke-NcSsh "qos statistics volume characteristics show -iterations $iterations"
    $command4 | Out-File -FilePath "volCharacteristics.txt"
}
  
 