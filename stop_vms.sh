#!/bin/bash

WORKSPACE_PATH=$(pwd)
VM_DIRECTORY=(master1 worker1 worker2 control)

echo "Parando VMs..."

for vm in "${VM_DIRECTORY[@]}"; do
  echo "Parando VM: $vm"

  if [ -f "$WORKSPACE_PATH/$vm/Vagrantfile" ]; then
    pushd "$WORKSPACE_PATH/$vm" > /dev/null
    vagrant halt
    popd > /dev/null
  else
    echo "[AVISO] Diretório $vm não encontrado, pulando..."
  fi
done

echo "VMs do lab foram paradas."
