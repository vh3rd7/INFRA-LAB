# Infra-lab

Ambiente `Infra-lab` é um laboratório para testes.

🎯 Objetivo provisionar um cluster com **K3s** em máquinas virtuais utilizando **Vagrant**, **VirtualBox** e **Ansible** para fins de testes e aprendizado.

O **Ansible** será instalado automaticamente na máquina `control` durante o provisionamento inicial.

---

## 🧰 Dependências

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://developer.hashicorp.com/vagrant/install)
* Editor de texto recomendado: [VS Code](https://code.visualstudio.com/download)

---

## ⚙️ Estrutura e Scripts

As VMs utilizam o sistema operacional Ubuntu Jammy 64bit, com 1GB de memória RAM alocada para cada uma.

| Arquivo                                   | Descrição                                                 |
| ----------------------------------------- | --------------------------------------------------------- |
| `start_vms.sh`                            | Inicia todas as VMs com Vagrant                           |
| `remove_vms.sh`                           | Destroi todas as VMs do ambiente                          |
| `control/provision.sh`                    | Script de provisionamento da máquina **control**          |
| `provision_nodes.sh`                      | Script de provisionamento comum para as demais máquinas   |
| `control/data/add_key_hosts.sh`           | Adiciona a chave SSH da máquina **control** às demais     |
| `control/data/playbooks/k3s-cluster.yaml` | Playbook Ansible para configurar o cluster K3s            |
| `Vagrantfile`                             | Arquivo de configuração das máquinas                      |

---

## 🖥️ Subindo o Ambiente

O script `start_vms.sh` executa `vagrant up` nos diretórios que contêm um `Vagrantfile`.

```bash
./start_vms.sh
```

---

## 📌 Uso da Máquina `control`

A máquina `control` é responsável por gerenciar os demais nós via **Ansible**.

### Passos:

```bash
# 1. Acesse o diretório da máquina control
cd control

# 2. Acesse a máquina via SSH
vagrant ssh

# 3. Adicione a chave SSH para acesso às outras VMs
./data/add_key_hosts.sh

# 4. Teste a conexão com os nós
ansible -m ping all

# Caso o Ansible solicite confirmação da chave de autenticação (key fingerprint)
# ao tentar se conectar pela primeira vez,
# digite yes e pressione Enter para aceitar cada conexão com os hosts

# 5. Execute o playbook para criar o cluster K3s
ansible-playbook ./data/playbooks/k3s-cluster.yaml

# Para detalhar o log adicione o parâmetro -vvvv ao comando
# ansible-playbook ./data/playbooks/k3s-cluster.yaml -vvvv
```

---

## 🎯 Testando o `k3s`

```bash
# Acesse o diretório da máquina master
cd master1

# Conecte-se via SSH
vagrant ssh

# Verifique se os nós do cluster estão ativos
sudo kubectl get nodes
```

---

## 🏁 Finalizando

Se você chegou até aqui sem erros, seu ambiente de testes com Kubernetes está pronto para uso!

🖖

---
