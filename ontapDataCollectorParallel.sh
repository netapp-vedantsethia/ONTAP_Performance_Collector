#!/bin/bash

# NetApp Solutions Engineering Team
# Pre-requisites:
# 1. Ensure host has connectivity to the ONTAP system
# 2. sshpass and ssh modules should be pre-installed. if not install using "sudo apt-get install sshpass ssh"

# Running the script
# 1. Run the command "chmod +x ontapDataColectorParallel.sh" 
# 2. Execute the script "./ontapDataCollectorParallel.sh"

# User inputs
read -p "Please enter your ONTAP endpoint: " ONTAPEndpoint
read -p "Please enter your username: " ONTAPUsername
read -s -p "Please enter your password: " ONTAPPassword
echo
read -p "Get System Statistics (yes/no): " runCommand1
read -p "Get Volume Latency (yes/no): " runCommand2
read -p "Get Volume Performance (yes/no): " runCommand3
read -p "Get Volume Characteristics (yes/no): " runCommand4
read -p "Enter the number of iterations (1-30): " iterations

# Define the commands to run and their respective output files
if [ "$runCommand1" = "yes" ]; then sshpass -p "$ONTAPPassword" ssh -o 'StrictHostKeyChecking no' $ONTAPUsername@$ONTAPEndpoint "statistics system show -interval 5 -iterations $iterations" > systemStats.txt & fi
if [ "$runCommand2" = "yes" ]; then sshpass -p "$ONTAPPassword" ssh -o 'StrictHostKeyChecking no' $ONTAPUsername@$ONTAPEndpoint "qos statistics volume latency show -iterations $iterations" > volLatency.txt & fi
if [ "$runCommand3" = "yes" ]; then sshpass -p "$ONTAPPassword" ssh -o 'StrictHostKeyChecking no' $ONTAPUsername@$ONTAPEndpoint "qos statistics volume performance show -iterations $iterations" > volPerf.txt & fi
if [ "$runCommand4" = "yes" ]; then sshpass -p "$ONTAPPassword" ssh -o 'StrictHostKeyChecking no' $ONTAPUsername@$ONTAPEndpoint "qos statistics volume characteristics show -iterations $iterations" > volCharacteristics.txt & fi

# Wait for all background jobs to finish
echo "Collecting Data.........."
wait