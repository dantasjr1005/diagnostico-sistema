#!/bin/bash
# =============================================
# Script de Diagnóstico Rápido do Sistema
# Autor: Junior Dantas 
# GitHub: https://github.com/dantasjr1005
# =============================================

# Função para imprimir cabeçalho bonito
print_section() {
    echo ""
    echo "============================================="
    echo " $1"
    echo "============================================="
}

# 1. Informações do sistema
print_section "INFORMAÇÕES DO SISTEMA"
echo "Hostname: $(hostname)"
echo "Data/Hora: $(date)"
echo "Uptime: $(uptime -p)"
echo "Versão do Kernel: $(uname -r)"
echo "Distribuição Linux:"
lsb_release -d 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME

# 2. CPU
print_section "USO DE CPU"
lscpu | grep "Model name"
echo "Carga de CPU:"
top -bn1 | grep "Cpu(s)" | awk '{print "Uso de CPU: " $2 "%"}'

# 3. Memória
print_section "USO DE MEMÓRIA"
free -h

# 4. Disco
print_section "USO DE DISCO"
df -h --total | grep -E "(Filesystem|total)"

# 5. Top 5 processos por consumo de memória
print_section "TOP 5 PROCESSOS POR MEMÓRIA"
ps aux --sort=-%mem | head -n 6

# 6. Top 5 processos por consumo de CPU
print_section "TOP 5 PROCESSOS POR CPU"
ps aux --sort=-%cpu | head -n 6

# 7. Serviços ativos (systemd)
print_section "SERVIÇOS ATIVOS"
systemctl list-units --type=service --state=running | head -n 15

# 8. Conexões de rede
print_section "CONEXÕES DE REDE"
ss -tuln | head -n 10

# 9. Temperatura da CPU (se disponível)
if command -v sensors &> /dev/null; then
    print_section "TEMPERATURA DA CPU"
    sensors | grep -E 'Package id|Core'
fi

print_section "FIM DO DIAGNÓSTICO"
