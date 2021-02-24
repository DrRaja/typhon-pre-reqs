#!/bin/bash
# Install OpenSSH
echo "==================INSTALLING OPEN-SSH===================="
apt-get update && apt-get install -y make gcc net-tools openssh-server
echo "==================OPEN-SSH INSTALLED SUCCESSFULLY===================="

# Create ducc user & copy ssh credentials
echo "==================ADDING DUCC USER WITH SSH CREDENTIALS===================="
useradd -m ducc -s /bin/bash
mkdir /home/ducc 
mkdir /home/ducc/.ssh
wget https://raw.githubusercontent.com/Salmation/typhon-pre-reqs/master/id_rsa -P /home/ducc/.ssh/
wget https://raw.githubusercontent.com/Salmation/typhon-pre-reqs/master/id_rsa.pub -P /home/ducc/.ssh/
echo "==================ADDING DUCC USER: SUCCESSFULL===================="

# Start SSH service
service ssh start
#Set Permissions
chmod 700 /home/ducc/.ssh
chmod 600 /home/ducc/.ssh/id_rsa
chmod +r /home/ducc/.ssh/id_rsa.pub
cp /home/ducc/.ssh/id_rsa.pub /home/ducc/.ssh/authorized_keys
echo "StrictHostKeyChecking=no" > /home/ducc/.ssh/config

# The same for root user
cp -Rf /home/ducc/.ssh/ /root/
chown -Rf root.root /home/ducc/.ssh/

# UIMA DUCC installation
mkdir /home/ducc/ducc_runtime

# Install NFS-Client (Filesystem Sharing)
apt-get update
apt-get install nfs-common

echo "============ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ================"
echo "============================== ADD WORKER NODE TO THE CLUSTER ============================="
echo "============ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ================"
echo "Add HOST Node IP in Worker Node Hosts File: nano /etc/hosts"
echo "Mount Shared folder: mount HOST-IP:/home/ducc/ducc_runtime  /home/ducc/ducc_runtime"
echo "Add Worker Node HOSTNAME to /home/ducc/ducc_runtime/resources/ducc.nodes on Shared Filesystem."
echo "Re-Run DUCC from Head Node or Worker Node:"
echo "(HEAD NODE): su - ducc -c '/home/ducc/ducc_runtime/admin/start_ducc'"
echo "OR"
echo "(WORKER NODE): su - ducc -c \"ssh HOST-IP-HERE '/home/ducc/ducc_runtime/admin/start_ducc'\""

echo "==========================================================================================================="
echo "=========================================== SETUP COMPLETE ================================================"
echo "==========================================================================================================="
