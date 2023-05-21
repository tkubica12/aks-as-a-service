#!/bin/bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sudo snap install terraform --classic
sudo snap install helm --classic
sudo snap install kubectl --classic

wget https://github.com/derailed/k9s/releases/download/v0.27.3/k9s_Linux_amd64.tar.gz
tar xvf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/bin/
rm k9s_Linux_amd64.tar.gz

cat <<EOF > /etc/ssh/ssh_config.d/sftp.conf
Match User tomas
ChrootDirectory %h 
X11Forwarding no 
AllowTcpForwarding no 
ForceCommand internal-sf
HostKeyAlgorithms +ssh-rsa 
PubkeyAcceptedKeyTypes +ssh-rsa 
EOF

sudo systemctl restart ssh

cat <<EOF >> ~/.bashrc
alias azl='az login --tenant tkubica.biz --use-device-code'
alias t='terraform'
alias taa='terraform apply -auto-approve'
alias tda='terraform destroy -auto-approve'
alias tp='terraform plan'
alias tv='terraform validate'
alias k='kubectl'
EOF