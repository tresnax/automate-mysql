#!/bin/bash

#---------------------------------------------------------
#Automate mysql_secure_installation | tested with RHEL 8.1
#---------------------------------------------------------

#Example install for RHEL, CentOS & Fedora
#Install Packgae mysql-server & expect, you change it according to your Distro
dnf install mysql-server expect -y
systemctl enable mysqld
systemctl start mysqld

#You can skip and comment this if you didnt use RHEL Family
firewall-cmd --add-service=mysql --permanent 
firewall-cmd --reload

#Change mypassword to your password
yourpass="mypassword"

#Mysql Configuration using expect
expect << EOF
    set passuy ""
    spawn /bin/mysql -uroot -p --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED with mysql_native_password;"
    expect -exact "Enter password:"
    send -- "$passuy\r"
    spawn /bin/mysql -uroot -p --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$yourpass';"
    expect -exact "Enter password:"
    send -- "$passuy\r"
    spawn /bin/mysql -uroot -p$yourpass --connect-expired-password -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    spawn /bin/mysql -uroot -p$yourpass --connect-expired-password -e "DROP DATABASE IF EXISTS test;"
    spawn /bin/mysql -uroot -p$yourpass --connect-expired-password -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    spawn /bin/mysql -uroot -p$yourpass --connect-expired-password -e "FLUSH PRIVILEGES;"
    expect eof
EOF

#Installation Finish
echo "Installation Finish"