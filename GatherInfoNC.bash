#!/bin/bash

echo "Enter the target IP address:"
read target_ip

echo "Enter the target port:"
read target_port

commands=$(cat << EOF
echo "==== Hostname ===="
hostname
echo ""
echo "==== Operating System ===="
uname -a
echo ""
echo "==== CPU Info ===="
lscpu
echo ""
echo "==== Memory Info ===="
free -h
echo ""
echo "==== Disk Space ===="
df -h
echo ""
echo "==== Running Processes ===="
ps aux
echo ""
echo "==== Running Services ===="
systemctl list-units --type=service --state=running
echo ""
echo "==== Installed Packages ===="
dpkg-query --show --showformat='${Package}\t${Version}\n' 2>/dev/null || rpm -qa
echo ""
EOF
)

temp_script="temp_commands.sh"
echo "#!/bin/bash" > $temp_script
echo "$commands" >> $temp_script
chmod +x $temp_script

nc -w 3 -q 3 $target_ip $target_port < $temp_script | while read line; do
  echo $line
done

rm $temp_script
