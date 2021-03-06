#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "VPS Manager 2.0.1" ; tput sgr0
tput setaf 3 ; tput bold ; echo "" ; echo "Este script irá:" ; echo ""
echo "● ตั้งค่าคอนฟิเกอเรชันของพร็อกซีปลาหมึก 80, 3128, 8080 e 8000" ; echo "  para permitir conexões SSH para este servidor"
echo "● การปรับตั้งค่า OpenSSH para rodar nas portas 22 e 143"
echo "● ติดตั้งสคริปต์ conjunto de scripts como comandos do sistema para o gerenciamento de usuários" ; tput sgr0
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
tput setaf 2 ; tput bold ; echo "	Termos de Uso" ; tput sgr0
echo ""
echo "Ao utilizar o 'VPS Manager 2.0' คำแนะนำสำหรับการใช้งาน:"
echo ""
echo "1. Você pode:"
echo "a. Instalar e usar o 'VPS Manager 2.0' no(s) seu(s) servidor(es)."
echo "b. Criar, gerenciar e remover um número ilimitado de สามารถใช้ร่วมกับสคริปต์เดสก์ท็อปได้"
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "2. Você não pode:"
echo "a. Editar, modificar, compartilhar ou redistribuir (gratuitamente ou comercialmente)"
echo "esse conjunto de scripts sem autorização do desenvolvedor."
echo "b. Modificar ou editar o conjunto de scripts para fazer você parecer o desenvolvedor dos scripts."
echo ""
echo "3. Você aceita que:"
echo "a. O valor pago por esse conjunto de scripts não inclui garantias ou suporte adicional,"
echo "porém o usuário poderá, de forma promocional e não obrigatória, por tempo limitado,"
echo "receber suporte e ajuda para solução de problemas desde que respeite os termos de uso."
echo "b. O usuário desse conjunto de scripts é o único resposável por qualquer tipo de implicação"
echo "ética ou legal causada pelo uso desse conjunto de scripts para qualquer tipo de finalidade."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "4. Você concorda que o desenvolvedor não se responsabilizará pelos:"
echo "a. Problemas causados pelo uso dos scripts distribuídos sem autorização."
echo "b. Problemas causados por conflitos entre este conjunto de scripts e scripts de outros desenvolvedores."
echo "c. Problemas causados por edições ou modificações do código do script sem autorização."
echo "d. Problemas do sistema causados por programas de terceiro ou modificações/experimentações do usuário."
echo "e. Problemas causados por modificações no sistema do servidor."
echo "f. Problemas causados pelo usuário não seguir as instruções da documentação do conjunto de scripts."
echo "g. Problemas ocorridos durante o uso dos scripts para obter lucro comercial."
echo "h. Problemas que possam ocorrer ao usar o conjunto de scripts em sistemas que não estão na lista de sistemas testados."
echo ""
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
IP=$(wget -qO- ipv4.icanhazip.com)
read -p "Para continuar confirme o IP deste servidor: " -e -i $IP ipdovps
if [ -z "$ipdovps" ]
then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "" ; echo " Você não digitou o IP deste servidor. Tente novamente. " ; echo "" ; echo "" ; tput sgr0
	exit 1
fi
if [ -f "/root/usuarios.db" ]
then
tput setaf 6 ; tput bold ;	echo ""
	echo "Uma base de dados de usuários ('usuarios.db') foi encontrada!"
	echo "Deseja mantê-la (preservando o limite de conexões simultâneas dos usuários)"
	echo "ou criar uma nova base de dados?"
	tput setaf 6 ; tput bold ;	echo ""
	echo "[1] รักษาฐานข้อมูลไว้เหมือนเดิม"
	echo "[2] ล้างฐานข้อมูลติดตั้งใหม่"
	echo "" ; tput sgr0
	read -p "Opção?: " -e -i 1 optiondb
else
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
echo ""
read -p "Deseja ativar a compressão SSH (pode aumentar o consumo de RAM)? [s/n]) " -e -i n sshcompression
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Aguarde a configuração automática" ; echo "" ; tput sgr0
sleep 3
apt-get update -y
apt-get upgrade -y
rm /bin/criarusuario /hin/statusvpn /bin/expcleaner /bin/sshlimiter /bin/addhost /bin/listar /bin/sshmonitor /bin/ajuda > /dev/null
rm /root/ExpCleaner.sh /root/CriarUsuario.sh /root/sshlimiter.sh > /dev/null
apt-get install squid3 bc screen nano unzip dos2unix wget -y
killall apache2
apt-get purge apache2 -y
if [ -f "/usr/sbin/ufw" ] ; then
	ufw allow 143/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8000/tcp ; ufw allow 8080/tcp
fi
if [ -d "/etc/squid3/" ]
then
        echo 'SQUID DEBIAN'
rm -rf /etc/squid3/squid.conf
touch /etc/squid3/squid.conf
echo 'acl ip dstdomain '$IP > /etc/squid3/squid.conf
echo 'acl payload dstdomain -i "/etc/payloads"
acl local dstdomain localhost
acl iplocal dstdomain 127.0.0.1
acl netflix dstdomain .netflix.
acl redelocal src 192.168.0.1-192.168.0.254
acl vpn src 10.8.0.1-10.8.0.254
acl videoprime dstdomain .videoprime.
acl ip4 dstdomain 127.0.0.2
acl oi dstdomain 200.222.108.241

http_access allow ip
http_access allow payload
http_access allow local
http_access allow iplocal
http_access allow redelocal
http_access allow vpn
http_access allow ip4
http_access allow oi
http_access allow netflix
http_access allow videoprime

http_port 80
http_port 8080
http_port 8000
http_port 3128

visible_hostname RNEOXBRASIL

http_access deny all

via off
forwarded_for off' >> /etc/squid3/squid.conf
	grep -v "^Port 143" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 143" >> /etc/ssh/sshd_config
	wget https://raw.githubusercontent.com/Panuwatbank/ssh/master/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/Panuwatbank/ssh/master/alterarsenha -O /bin/alterarsenha
	chmod +x /bin/alterarsenha
	wget https://raw.githubusercontent.com/Panuwatbank/ssh/master/criarusuario2.sh -O /bin/criarusuario
	chmod +x /bin/criarusuario
	https://raw.githubusercontent.com/Panuwatbank/user-bank/master/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/Panuwatbank/user-bank/master/expcleaner2.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/Panuwatbank/user-bank/master/mudardata.sh -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/Panuwatbank/user-bank/master/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/Panuwatbank/user-bank/master/sshlimiter2.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget http://raw.githubusercontent.com/Panuwatbank/user-bank/master/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget http://raw.githubusercontent.com/Panuwatbank/user-bank/master/ajuda.sh -O /bin/ajuda
	chmod +x /bin/ajuda
	wget http://raw.githubusercontent.com/Panuwatbank/user-bank/master/sshmonitor2.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid3" ]
	then
		service squid3 reload > /dev/null
	else
		/etc/init.d/squid3 reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi	
fi
if [ -d "/etc/squid/" ]
then
	echo 'SQUID UBUNTU'
rm -rf /etc/squid/squid.conf
touch /etc/squid/squid.conf
echo 'acl ip dstdomain '$IP > /etc/squid/squid.conf
echo 'acl payload dstdomain -i "/etc/payloads"
acl local dstdomain localhost
acl iplocal dstdomain 127.0.0.1
acl netflix dstdomain .netflix.
acl redelocal src 192.168.0.1-192.168.0.254
acl vpn src 10.8.0.1-10.8.0.254
acl videoprime dstdomain .videoprime.
acl ip4 dstdomain 127.0.0.2
acl oi dstdomain 200.222.108.241

http_access allow ip
http_access allow payload
http_access allow local
http_access allow iplocal
http_access allow redelocal
http_access allow vpn
http_access allow ip4
http_access allow oi
http_access allow netflix
http_access allow videoprime

http_port 80
http_port 8080
http_port 8000
http_port 3128

visible_hostname เย็ดเป็ด

http_access deny all

via off
forwarded_for off' >> /etc/squid/squid.conf
rm squidconf
	grep -v "^Port 143" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 143" >> /etc/ssh/sshd_config
	wget https://raw.githubusercontent.com/Panuwatbank/vpn/master/web/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/Panuwatbank/vpn/master/alterarsenha.sh -O /bin/alterarsenha
	chmod +x /bin/alterarsenha
	wget https://raw.githubusercontent.com/Panuwatbank/wy/master/criarusuario -O /bin/criarusuario
	chmod +x /bin/criarusuario
	wget https://raw.githubusercontent.com/Panuwatbank/vpn/master/web/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/Panuwatbank/vpn/master/expcleaner2.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/Panuwatbank/vpn/master/mudardata.sh -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/Panuwatbank/vpn/master/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/Panuwatbank/vpn/master/sshlimiter2.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://raw.githubusercontent.com/Panuwatbank/vpn/master/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://raw.githubusercontent.com/Panuwatbank/wy/master/ajuda.sh -O /bin/ajuda
	chmod +x /bin/ajuda
	wget https://raw.githubusercontent.com/Panuwatbank/vpn/master/sshmonitor2.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid" ]
	then
		service squid reload > /dev/null
	else
		/etc/init.d/squid reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Proxy Squid Instalado e rodando nas portas: 80, 3128, 8080 e 8000" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "OpenSSH rodando nas portas 22 e 143" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Scripts para gerenciamento de usuário instalados" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Leia a documentação para evitar dúvidas e problemas!" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Para ver os comandos disponíveis use o comando: ajuda" ; tput sgr0
echo ""
if [[ "$optiondb" = '2' ]]; then
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
if [[ "$sshcompression" = 's' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
	echo "Compression yes" >> /etc/ssh/sshd_config
fi
if [[ "$sshcompression" = 'n' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
exit 1
