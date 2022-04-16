#!/bin/bash
#Help Function
Help()
{
	echo "The script is used to add a job to Prometheus. It also adds an entry in /etc/hosts"
	echo
	echo "SYNTAX: ajp [Jobname] [IP_Address] [Port]"
	echo
	echo "OPTIONS:"
	echo "Jobname		The name you want for the job to have in the prometheus.yml file"
	echo "IP_Address	The IP address of the host you want to add to prometheus"
	echo "Port		The port on which the prometheus exporter is listenning (default: 9100 / 9182)"
	echo "                                                                                 Linux/Windows"
}

while getopts ":h" option; do
	case $option in
		h) # Displays Help
			Help
		   	exit;;
	   \?) # Invalid Option
	   		Help
			exit;;
	esac
done

jobname=$1
ip_addr=$2
port=$3
if [[ -n $jobname && -n $ip_addr && -n $port ]]
then
	duplicates=$(cat /etc/prometheus/prometheus.yml | grep -c $jobname)
        if [[ $duplicates > 0 ]]
        then
                echo "The job name is already used"
                exit;
        fi
	#All parameters were supplied
	#Adding the entry to hosts
	cat << EOF >> /etc/hosts
$ip_addr $jobname
EOF
	echo "Successfully added the IP in hosts"
	#Adding the job to prometheus
	cat << EOF >> /etc/prometheus/prometheus.yml

  - job_name: $jobname
    scrape_interval: 5s
    static_configs:
      - targets: ['$jobname:$port']
EOF
	sleep 1
	echo
	echo "Successfully added the job in prometheus"
	sleep 1
	promtool check config /etc/prometheus/prometheus.yml
	echo -n "Would you like to reload prometheus?[y/n]: "
	read choice
	if [[ $choice = 'y' ]]
	then
		systemctl reload prometheus
		sleep 1
		echo
		echo "Successfully reloaded prometheus"
		echo
		systemctl status prometheus
	else
		echo "Prometheus was not restarted"
		exit
	fi
else
	#Not all parameters were supplied
	echo "You must supply three parameters: jobname ip address and port number"
	exit
fi
