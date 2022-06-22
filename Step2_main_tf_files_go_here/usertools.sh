#!/bin/bash
banner()
{
  echo "+------------------------------------------+"
  printf "| %-40s |\n" "`date`"
  echo "|                                          |"
  printf "| %-40s |\n" "$@"
  echo "+------------------------------------------+"
}

#--- Enable Repos ---
banner "Enabling Repos"
sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel

#--- Start of CEQUENCE's Stuff ---
banner "Starting CEQUENCE's Stuff"
#--- Install Terraform ---
banner "Installing Terraform 1.1.7"
curl -OL https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip
unzip terraform_1.1.7_linux_amd64.zip
rm terraform_1.1.7_linux_amd64.zip
mv terraform /usr/local/bin
#--- install docker ---
banner "Install Docker"
apt update -y
amazon-linux-extras install docker=latest  -y
#--- install ansible ---
banner "Install Ansible"
amazon-linux-extras install ansible2=latest -y
#--- Install kubectl ---
banner "Installing Kubectl"
curl -Lo /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl
#--- Install helm ---
banner "Installing helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
#--- Install k9s ---
banner  "Installing k9s"
curl -OL https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz
tar -C /usr/local/bin -zxvf k9s_Linux_x86_64.tar.gz k9s
#--- Installing krew stuff ---
banner "Installing Krew Stuff"
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-linux_amd64.tar.gz"
mkdir -p /tmp/krew
tar -zxvf krew-linux_amd64.tar.gz -C /tmp/krew
/tmp/krew/krew-linux_amd64 install krew
rm -Rf /tmp/krew
rm -Rf krew-linux_amd64.tar.gz
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
kubectl krew install ingress-nginx

#--- Install python3 ---
banner "Installing python3"
sudo yum install python3 -y
sudo python3 --version
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
pip --version

#--- Install awscliv2 python ---
banner "Installing awsc2 python"
python3 -m pip install boto3
pip install awsebcli --upgrade --user
python -m pip install awscliv2

#--- Install GIT ---
banner "Installing GIT"
sudo yum install git -y

#--- Install curl, jq ---
banner "Installing curl & jq"
sudo yum install curl zip jq -y
