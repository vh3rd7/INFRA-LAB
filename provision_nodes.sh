#!/bin/sh

# Garante que o usuário 'vagrant' tenha a senha padrão 'vagrant'
echo 'vagrant:vagrant' | sudo chpasswd

# Remove a exigência de senha para uso do sudo pelo usuário 'vagrant'
echo "Configurando NOPASSWD para vagrant."
echo "vagrant    ALL=(ALL:ALL)    NOPASSWD:ALL" | sudo tee /etc/sudoers.d/vagrant > /dev/null
# sudo cat /etc/sudoers.d/vagrant

# Habilita autenticação por senha no SSH (sshd_config principal)
echo 'PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config

# Corrige configurações conflitantes nos arquivos de /etc/ssh/sshd_config.d/
echo "Corrigindo arquivos em /etc/ssh/sshd_config.d/..."
# sudo sed -i '/^\s*PasswordAuthentication\s\+no/s/no/yes/' /etc/ssh/sshd_config.d/*.conf 2>/dev/null || true
for file in /etc/ssh/sshd_config.d/*.conf; do
    if grep -qE '^\s*PasswordAuthentication\s+no' "$file"; then
        echo "Modificando $file"
        sudo sed -i '/^\s*PasswordAuthentication\s\+no/s/no/yes/' "$file"
    fi
done
# grep -ri PasswordAuthentication /etc/ssh/sshd_config.d/

# Reinicia o serviço SSH para aplicar as mudanças
echo "Reiniciando o serviço SSH."
sudo systemctl restart ssh
