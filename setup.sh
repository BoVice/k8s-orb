#!/bin/bash

#install kubelet kubeadm kubectl
# if which kubectl >/dev/null; then
#     echo "kubectl already exists. Skipping..."
# else
#     sudo apt-get update && sudo apt-get install -y build-essential apt-transport-https ca-certificates lxc
#     sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
#     echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
#     sudo apt-get update
#     sudo apt-get install -y kubectl kubelet kubeadm
#     # sudo mkdir kops-linux-amd64
#     # curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
#     # sudo chmod +x kops-linux-amd64
#     # sudo mv kops-linux-amd64 /usr/local/bin/kops
# fi

# sudo apt-get update && apt-get install -y apt-transport-https curl
# sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# sudo cat <<EOF >sudo /etc/apt/sources.list.d/kubernetes.list
# sudo deb https://apt.kubernetes.io/ kubernetes-xenial main
# EOF
# sudo apt-get update
# sudo apt-get install -y kubelet kubeadm kubectl
# sudo apt-mark hold kubelet kubeadm kubectl

CNI_VERSION="v0.6.0"
sudo mkdir -p /opt/cni/bin
sudo wget -O cni-plugins-amd64-${CNI_VERSION}.tgz "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-amd64-${CNI_VERSION}.tgz"
sudo mv cni-plugins-amd64-${CNI_VERSION}.tgz /opt/cni/bin/
cd /opt/cni/bin/
sudo tar -xvzf /opt/cni/bin/cni-plugins-amd64-${CNI_VERSION}.tgz
sudo rm -rf cni-plugins-amd64-${CNI_VERSION}.tgz
cd -

CRICTL_VERSION="v1.11.1"
sudo mkdir -p /opt/bin
sudo chmod +x /opt/bin
sudo wget -O crictl-${CRICTL_VERSION}-linux-amd64.tar.gz "https://github.com/kubernetes-incubator/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz"
sudo mv crictl-${CRICTL_VERSION}-linux-amd64.tar.gz /opt/bin/
cd /opt/bin/
sudo tar -xvzf crictl-${CRICTL_VERSION}-linux-amd64.tar.gz
sudo rm -rf crictl-${CRICTL_VERSION}-linux-amd64.tar.gz



RELEASE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"

sudo curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/{kubeadm,kubelet,kubectl}
sudo chmod +x {kubeadm,kubelet,kubectl}

sudo touch /etc/systemd/system/kubelet.service
sudo chmod -R 100 /etc/systemd/system/kubelet.service
sudo curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/kubelet.service" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service

sudo mkdir -p /etc/systemd/system/kubelet.service.d
sudo touch /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo chmod -R 100 /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/10-kubeadm.conf" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

---

sudosystemctl enable kubelet && systemctl start kubelet

