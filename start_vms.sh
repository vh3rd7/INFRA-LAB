#!/bin/bash

WORKSPACE_PATH=$(pwd)
VM_DIRECTORY=(master worker1 worker2 control)

echo "Inicializando VMs..."

for vm in "${VM_DIRECTORY[@]}"; do
    echo "Iniciando VM: $vm"
    
    if [ -f "$WORKSPACE_PATH/$vm/Vagrantfile" ]; then
        pushd "$WORKSPACE_PATH/$vm" > /dev/null
        vagrant up
        popd > /dev/null
    else
        echo "[AVISO] Diretório $vm não encontrado, pulando..."
    fi
done

echo "Todas as VMs foram inicializadas."
