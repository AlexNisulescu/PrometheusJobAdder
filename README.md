# Bash script for adding a job to Prometheus

## Table of contents
  * [Index](#index)
  * [Introduction](#introduction)
  * [Requirements](#requirements)
  * [How to use it](#how-to-use-it)
  * [Contributors](#contributors)


## Introduction

This script was created from the need to simplify the way a job is added to Prometheus. Since making a mistake in this task can turn on alerts, I needed to make a safe way of doing so.
It was coded in a way that it will do all the work in creating the job. The script checks if the jobname is already used and if so, it quits. If it's not used the script adds the host IP to the /etc/hosts file with the job name, then adds the job to Prometheus. After that it will print the output of promtool chech on the prometheus.yml file and ask the user if he wants to reload Prometheus.

## Requirements

Prometheus service file needs to be coded in a way that it will allow the service to be reloaded and not restarted.
Also you will need to have an exporter listening on a specific port for the host, in order for Prometheus to be able to pull data from it.
You will have to provide the parameters in the correct order for the script to work properly.

## How to use it
Syntax:

    ajp [Jobname] [IP_Address] [Port]

The options are:

    Jobname		The name you want for the job to have in the prometheus.yml file
    IP_Address	The IP address of the host you want to add to prometheus
    Port		The port on which the prometheus exporter is listenning (example: 9100, 9182)

Some examples of running it are:

    ajp LinuxHost 192.168.10.10 9100
    ajp WindowsHost 192.168.10.11 9182
    

## Contributors
    Creator: Alexandru Nișulescu
    Contact: alex.nisulescu1998@gmail.com
    Linkedin: https://www.linkedin.com/in/alex-nisulescu-45822b178/
