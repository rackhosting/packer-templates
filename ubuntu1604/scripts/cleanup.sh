#!/bin/bash
echo "==> Removing SSH host keys."
rm -rf /etc/ssh/ssh_host_*_key*
echo "==> Cleaning up DHCP leases."
rm /var/lib/dhcp/*
echo "==> Cleaning up udev."
rm -rf /dev/.udev/
touch /etc/udev/rules.d/75-persistent-net-generator.rules
echo "==> Cleaning up tmp."
rm -rf /tmp/*
echo "==> Autoremoving and cleaning."
apt-get autoremove -y
apt-get clean -y
echo "==> Removing linux headers."
dpkg --list | awk '{ print $2 }' | grep linux-headers | xargs apt-get -y purge
rm -rf /usr/src/linux-headers*
echo "==> Removing linux source."
dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge
echo "==> Removing development packages."
dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge
echo "==> Removing documentation."
dpkg --list | awk '{ print $2 }' | grep -- '-doc$' | xargs apt-get -y purge
echo "==> Remove Bash history."
unset HISTFILE
rm -f /root/.bash_history
echo "==> Clean up log files."
find /var/log -type f | while read f; do echo -ne '' > $f; done;
echo "==> Clearing last login information."
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp
echo "==> Syncing file system."
sync