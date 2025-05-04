#!/bin/bash

WORKSPACE_PATH=$(pwd)
VM_DIRECTORY=(master worker1 worker2 control)

echo "Removendo VMs..."

for vm in "${VM_DIRECTORY[@]}"; do
    echo "Removendo VM: $vm"
    
    if [ -f "$WORKSPACE_PATH/$vm/Vagrantfile" ]; then
        pushd "$WORKSPACE_PATH/$vm" > /dev/null
        vagrant halt && vagrant destroy -f && rm -rf .vagrant
        popd > /dev/null
    else
        echo "[AVISO] Diretório $vm não encontrado, pulando..."
    fi
done

echo "Todas as VMs foram removidas."
