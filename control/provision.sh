#!/bin/sh

echo "Instalando libs e Python"
sudo apt update
sudo apt install -y python3 python3-pip curl zip
python3 -m pip install --upgrade pip
# python3 --version

echo "Inicio da instalação do Ansible"
sudo apt install ansible -y
# ansible --version

# Remove a exigência de senha para uso do sudo pelo usuário 'vagrant'
echo "Configurando NOPASSWD para vagrant."
cat <<EOT >> /etc/sudoers.d/vagrant
vagrant    ALL=(ALL:ALL)    NOPASSWD:ALL
EOT
# sudo cat /etc/sudoers.d/vagrant

# Configura o /etc/hosts com os aliases das máquinas
echo "Configurando /etc/hosts"
cat <<EOT >> /etc/hosts
192.168.1.2 control
192.168.1.3 master
192.168.1.4 worker1
192.168.1.5 worker2
EOT

# cat /etc/hosts

# Cria o inventário do Ansible
echo "Adicionando máquinas ao inventário do Ansible"
sudo mkdir -p /etc/ansible
cat <<EOT | sudo tee /etc/ansible/hosts > /dev/null
[master]
master ansible_host=192.168.1.3

[workers]
worker1 ansible_host=192.168.1.4
worker2 ansible_host=192.168.1.5

EOT

# cat /etc/ansible/hosts

# Configura o SSH para aceitar senha
echo "Configurando SSH"
# Garantir que o usuário 'vagrant' tenha a senha 'vagrant'
echo 'vagrant:vagrant' | sudo chpasswd

# Habilita autenticação por senha no SSH (sshd_config principal)
echo 'PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config

# Corrige configurações conflitantes em arquivos adicionais
echo "Corrigindo arquivos em /etc/ssh/sshd_config.d/..."
sudo sed -i '/^\s*PasswordAuthentication\s\+no/s/no/yes/' /etc/ssh/sshd_config.d/*.conf 2>/dev/null || true

# grep -ri PasswordAuthentication /etc/ssh/sshd_config.d/

# Reinicia o serviço SSH para aplicar as mudanças
echo "Reiniciando o serviço SSH."
sudo systemctl restart ssh

# Gera chave SSH para o usuário vagrant
echo "Gerando chave SSH para o usuário vagrant"
sudo -u vagrant mkdir -p /home/vagrant/.ssh
sudo -u vagrant bash -c "yes | ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa -q -N \"\""

# Instala sshpass para envio de chave automatizado
sudo apt install sshpass -y

# Copia a chave para os nós remotos
# echo "Copiando chave para acessar master"
# sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@master
