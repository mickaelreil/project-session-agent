file=$1
nb_proc=$(ps -aux | wc -l)
ipconfig=$(ip a)
date=$(date)
os=$(uname -a)
users=$(who)
memory=$(free)
cpu=$(lscpu | head -18)
devices=$(lsblk)
usb=$(lsusb)
hostname=$(uname -a)
echo "update time : $date" > $file
echo -e "\n">> $file
echo "hostname : $hostname" >> $file
echo -e "\n">> $file
echo "ip info : " >> $file
echo "$ipconfig" >> $file
echo -e "\n">> $file
echo "running processes : $nb_proc" >> $file
echo -e "\n">> $file
echo "OS : " >> $file
echo "$os" >> $file
echo -e "\n">> $file
echo "users :" >> $file
echo "$users" >> $file
echo -e "\n">> $file
echo "memory info : " >> $file
echo "$memory" >> $file
echo -e "\n">> $file
echo "cpu info : " >> $file
echo "$cpu" >> $file
echo -e "\n">> $file
echo "block devices : " >> $file
echo "$devices" >> $file
echo -e "\n">> $file
echo "USB controllers information : " >> $file
echo "$usb" >> $file
echo COPIE LOG
