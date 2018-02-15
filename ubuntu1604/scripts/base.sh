#!/bin/bash
echo "==> Updating packages."
apt-get update
apt-get upgrade -y
echo "==> Configuring SSH to not do reverse checks for connections."
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "==> Configuring Linux to use old style interface names (eth0)."
sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"net.ifnames=0 biosdevname=0\"/g' /etc/default/grub
update-grub2
echo "==> Installing VMware Tools and dbus."
apt-get install -y open-vm-tools dbus
echo "==> Fixing network configuration file."
sed -i 's/ens33/eth0/g' /etc/network/interfaces
echo "==> Creating script to ensure SSH keys."
cat <<'EOF' > /usr/local/bin/ensurekeys.sh
#!/bin/bash
genkey() {
if [ ! -f /etc/ssh/ssh_host_$1_key ]
then
  ssh-keygen -q -t $1 -N "" -f /etc/ssh/ssh_host_$1_key
  echo "[ensurekeys] $1 key created"
else
  echo "[ensurekeys] $1 key already exists"
fi
}

genkey rsa
genkey dsa
genkey ecdsa
genkey ed25519

EOF
chmod 774 /usr/local/bin/ensurekeys.sh
cat <<'EOF' > /etc/systemd/system/ensurekeys.service
[Unit]
Before=ssh.service

[Service]
ExecStart=/usr/local/bin/ensurekeys.sh

[Install]
WantedBy=default.target
EOF
chmod 644 /etc/systemd/system/ensurekeys.service
systemctl daemon-reload
systemctl enable ensurekeys.service
echo "==> Installing nameservers."
echo "nameserver 8.8.8.8" > /etc/resolvconf/resolv.conf.d/base
echo "nameserver 8.8.4.4" >> /etc/resolvconf/resolv.conf.d/base
echo "==> Disallowing login for root."
sed -i 's/PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
systemctl restart ssh
echo "==> Locking root user."
passwd -l root