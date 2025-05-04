#!/bin/bash

HOST_LIST=(master worker1 worker2)

for host in "${HOST_LIST[@]}"; do
    echo "Adicionando chave SSH para $host"
    sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@$host
done
