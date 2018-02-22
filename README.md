# MQ LoRa gateway installation

1) Get the raspberry pi 3 board and get a 8gb micro sd card ready with the raspbian software.
On how to flash the os on the sd-card please follow the instructions here: https://www.raspberrypi.org/learning/hardware-guide/

2) Connect the raspberry pi to 5v 2amps power supply. THIS IS VERY IMPORTANT. The lora module may draw 700 mA peak during active wireless transactions and hence have a good power brick to power the raspberry pi.

3) Enable SPI & expand file system
sudo raspi-config
	Enable SPI
		[5] -> [4]

	Expand FileSystem
		[7] -> [1]
		
4) Install gateway packages

$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install git
$ git clone https://github.com/MQICTSolutions/lora-gateway
$ cd lora-gateway
$ sudo ./install.sh

**Note down EUI B827EBFFFED0230A in console log
			  ^^^^^^^^^^^^^^^^ this value different from gateways

5) Add gateway JSON configuration file (TBD)
			  
6) Configure LoRa Gateway Bridge
$ sudo nano /etc/lora-gateway-bridge/lora-gateway-bridge.toml
$ sudo systemctl restart lora-gateway-bridge

7) Configure email server for notification when board reboot
$ sudo nano /etc/ssmtp/ssmtp.conf

-----------------------------------------------------------------------------
# Config file for sSMTP sendmail
#
# The person who gets all mail for userids < 1000
# Make this empty to disable rewriting.
root=postmaster

# The place where the mail goes. The actual machine name is required no
# MX records are consulted. Commonly mailhosts are named mail.domain.com
mailhub=smtp.gmail.com:587

# Where will the mail seem to come from?
#rewriteDomain=

# The full hostname
hostname=mq-lora-gateway

# Are users allowed to set their own From: address?
# YES - Allow the user to specify their own From: address
# NO - Use the system generated From: address
#FromLineOverride=YES
AuthUser=mqictsolutions@gmail.com
AuthPass=***********
UseSTARTTLS=YES
-----------------------------------------------------------------------------
$ sudo chmod 774 /etc/ssmtp/ssmtp.conf
$ sudo nano /etc/ssmtp/revaliases

-----------------------------------------------------------------------------

# sSMTP aliases
#
# Format:       local_account:outgoing_address:mailhub
#
# Example: root:your_login@your.domain:mailhub.your.domain[:port]
# where [:port] is an optional port number that defaults to 25.
root:mqictsolutions@gmail.com:smtp.gmail.com:587

-----------------------------------------------------------------------------

# Test send email
$ echo "Test text" | mail -s "Test Mail" targetperson@example.com

