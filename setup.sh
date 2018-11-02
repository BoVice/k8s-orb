#!/bin/bash

#install kubelet kubeadm kubectl
if which kubectl >/dev/null; then
    echo "kubectl already exists. Skipping..."
else
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    # sudo mkdir kops-linux-amd64
    # curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
    # sudo chmod +x kops-linux-amd64
    # sudo mv kops-linux-amd64 /usr/local/bin/kops
fi


#config
#env vars
# if [[ ! -v "K8S_MANIFEST" ]]; then
#   echo "K8S_MANIFEST is not set"
#   exit 1
# fi

# initializing kubeadm


# setup manifest
export K8S_CONFIG_FILE="k8s-config/config.yml"
export K8S_DEPLOY_FILE="k8s-config/deployment.yml"
export K8S_CONTEXT="dev-frontend"
sudo kubectl config --kubeconfig=$K8S_CONFIG_FILE use-context $K8S_CONTEXT
kubectl create -f $K8S_DEPLOY_FILE
kubectl set image -f $K8S_DEPLOY_FILE nginx=nginx:1.9.1 --local -o yaml

# setup 





