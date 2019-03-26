#!/bin/sh

export OCP_RELEASE=$1
export OCP_VERSION-$2

echo "DEVS=/dev/sdb" > /etc/sysconfig/docker-storage-setup
echo "VG=docker-vg" >> /etc/sysconfig/docker-storage-setup

sed -i -e '$a\' -e 'net.ipv4.ip_forward=1' -e "/net.ipv4.ip_forward/d" /etc/sysctl.conf
sysctl -p

yum install -y docker-1.13.1 openshift-ansible iptables
systemctl start docker

ansible-playbook -vvv -i /tmp/ocp_inventory.yml /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
ansible-playbook -vvv -i /tmp/ocp_inventory.yml /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml