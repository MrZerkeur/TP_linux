#!/bin/sh

# THIS SCRIPT HAVE TO BE RUN WITH ROOT PRIVILEDGE

echo "=========="
echo "Start setting up time"
echo "=========="


chmod +x time.sh
./time.sh

echo "=========="
echo "Finished setting up time"
echo "=========="


echo "=========="
echo "Start setting up network"
echo "=========="


chmod +x network.sh
./network.sh

echo "=========="
echo "Finished setting up network"
echo "=========="


echo "=========="
echo "Start setting up SSH"
echo "=========="


chmod +x ssh.sh
./ssh.sh

echo "=========="
echo "Finished setting up SSH"
echo "=========="

echo "=========="
echo "Start setting up additional security"
echo "=========="


chmod +x additional_security.sh
./additional_security.sh

echo "=========="
echo "Finished setting up additional security"
echo "=========="