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

# Download Uima-DUCC 3
wget http://ftp.halifax.rwth-aachen.de/apache//uima//uima-ducc-3.0.0/uima-ducc-3.0.0-bin.tar.gz -P /home/ducc

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
cd /home/ducc/ && tar xzf /home/ducc/uima-ducc-3.0.0-bin.tar.gz && mv apache-uima-ducc-3.0.0/* /home/ducc/ducc_runtime/
rm -Rf /home/ducc/apache-uima-ducc-3.0.0/
cd /home/ducc/ducc_runtime/admin/ && /home/ducc/ducc_runtime/admin/ducc_post_install

#Sleep for 30 seconds
sleep 30

chown ducc.ducc -Rf /home/ducc/
chmod 700 /home/ducc/ducc_runtime/admin/

# Create res folder to store the results
mkdir /tmp/res
chown ducc.ducc -Rf /tmp/res/
# Run check_ducc to check if UIMA is properly installed
export LOGNAME="ducc"
su - ducc -c "/home/ducc/ducc_runtime/admin/check_ducc"

# Install NFS (Filesystem Sharing)
apt-get update
apt install nfs-kernel-server

# Add Worker Node IP in hosts
# nano /etc/hosts

#Start DUCC
su - ducc -c "/home/ducc/ducc_runtime/admin/start_ducc" 


echo "==========================================================================================================="
echo "===================== TO ADD WORKER NODE TO CLUSTER PERFORM THE FOLLOWING STEPS ==========================="
echo "==========================================================================================================="

echo "nano /etc/exports"
echo "/home/ducc/ducc_runtime (Insert-Worker-Node-IP-Here)(rw,sync,no_subtree_check)"
echo "exportfs –a"
echo "systemctl restart nfs-kernel-server"
echo "ADD WORKER NODE IP TO HOST: nano /etc/hosts"

echo "==========================================================================================================="
echo "=========================================== SETUP COMPLETE ================================================"
echo "==========================================================================================================="
