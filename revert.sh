#!/bin/bash

export LIBVIRT_DEFAULT_URI="qemu:///system"
PREFIX=lab6
#echo "remove hosts fingerprint"
for ip in 42 43 44 45 46
do
  ssh-keygen -R 10.9.0.$ip
done

for host in control control.lab6.example.com ansible1 ansible1.lab6.example.com ansible2 ansible2.lab6.example.com ansible3 ansible3.lab6.example.com ansible4 ansible4.lab6.example.com
do
	ssh-keygen -R $host
done

#echo "destroying vms"
for host in ${PREFIX}-control ${PREFIX}-ansible1 ${PREFIX}-ansible2 ${PREFIX}-ansible3 ${PREFIX}-ansible4
do
  virsh destroy $host
  virsh undefine $host
done

#echo "destroying pool"
virsh pool-destroy ${PREFIX}-images
virsh pool-undefine ${PREFIX}-images

#echo "destroying network"
virsh net-destroy ${PREFIX}-network
virsh net-undefine ${PREFIX}-network

#echo "removing dir"
sudo rm -fr /home/kvm/${PREFIX}

