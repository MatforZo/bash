#!/bin/bash

echo "System Information:"
echo "-------------------"

# Print the operating system
echo -e "Operating System:\t$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d "=" -f 2 | tr -d '"')"

# Print the kernel version
echo -e "Kernel Version:\t$(uname -r)"

# Print the CPU information
echo -e "\nCPU Information:"
echo "-----------------"
echo -e "CPU Model:\t\t$(lscpu | grep "Model name" | cut -d ":" -f 2 | tr -d '[:space:]')"
echo -e "Number of Cores:\t$(lscpu | grep "^CPU(s):" | awk '{print $2}')"
echo -e "Architecture:\t\t$(uname -m)"
echo -e "CPU Speed:\t\t$(lscpu | grep "CPU" | cut -d ":" -f 2 | tr -d '[:space:]') MHz"

# Print the memory information
echo -e "\nMemory Information:"
echo "-------------------"
echo -e "Total Memory:\t\t$(free -h | grep Mem | awk '{print $2}')"
echo -e "Used Memory:\t\t$(free -h | grep Mem | awk '{print $3}')"
echo -e "Free Memory:\t\t$(free -h | grep Mem | awk '{print $4}')"

# Print the disk space information
echo -e "\nDisk Space:"
echo "------------"
df -h

# Print the network information
echo -e "\nNetwork Information:"
echo "---------------------"
echo -e "IP Address:\t\t$(hostname -I)"
echo -e "Public IP Address:\t$(curl -s ifconfig.me)"

# Check for MySQL
if command -v mysql &> /dev/null; then
  echo -e "\nMySQL Information:"
  echo "------------------"
  echo -e "MySQL Version:\t\t$(mysql --version)"
  echo -e "MySQL Databases:\n$(mysql -e 'SHOW DATABASES;' | grep -Ev '(Database|information_schema|performance_schema|sys)')"
fi

# Check for PostgreSQL
if command -v psql &> /dev/null; then
  echo -e "\nPostgreSQL Information:"
  echo "-----------------------"
  echo -e "PostgreSQL Version:\t$(psql --version)"
  echo -e "PostgreSQL Databases:\n$(psql -l -t | cut -d '|' -f 1 | sed '/^\s*$/d')"
fi

# Check for MongoDB
if command -v mongod &> /dev/null; then
  echo -e "\nMongoDB Information:"
  echo "--------------------"
  echo -e "MongoDB Version:\t$(mongod --version | grep "db version" | cut -d " " -f 3)"
  echo -e "MongoDB Databases:\n$(mongo --quiet --eval "db.getMongo().getDBs()" | jq -r '.databases[].name')"
fi

# Print the user information
echo -e "\nUser Information:"
echo "------------------"
echo -e "Logged-in Users:\n$(who)"
echo -e "Last Login Information:\n$(last)"

# Print the process information
echo -e "\nTop Processes:"
echo "---------------"
echo -e "CPU\t\tMEM\t\tCMD"
echo "$(ps aux --sort=-%cpu | awk 'NR<=5 {print $3"\t\t"$4"\t\t"$11}')"

# Print the system uptime
echo -e "\nSystem Uptime:"
echo "--------------"
uptime

# Additional information can be added as needed

exit 0
