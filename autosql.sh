#cd /tmp
#wget https://repo.mysql.com/ #versionDistro.deb
#sudo dpkg -i mysql-apt-config*
#sudo apt update
#sudo apt install mysql-server
# secure installation
# mysql_secure_installation
# 
# check service status
# sudo systemctl status mysql

# MySql installer Debian Buster

sudo apt-get remove mariadb* && sudo apt-get purge mariadb*
cd /tmp
wget https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb
sudo dpkg -i mysql-apt-config_0.8*
sudo apt update
sudo apt install mysql-server

# check service status
# sudo systemctl status mysql