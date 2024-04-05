#!/bin/bash

# Set the MySQL username and password
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}

updates() {
    # Package installation
    yum install -y httpd wget expect yum-utils

    # Install EPEL and Remi repository
    yum install -y epel-release
    yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm

    # Enable PHP 7.4 Remi repository
    yum-config-manager --enable remi-php74
    yum install -y php php-mysqlnd php-gd php-xml php-mbstring php-intl

    # Add PHP to the system's PATH
    echo 'export PATH=/opt/remi/php74/root/usr/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
}

installMySQL() {
    # Add MariaDB repository
    echo -e "[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/10.6/centos7-amd64\ngpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1" > /etc/yum.repos.d/MariaDB.repo

    # Install MariaDB
    yum install -y MariaDB-server MariaDB-client

    # Start MariaDB
    systemctl start mariadb

    # Secure MariaDB installation
    SECURE_MYSQL=$(expect -c "
    set timeout 10
    spawn mysql_secure_installation
    expect \"Enter current password for root (enter for none):\"
    send \"\r\"
    expect \"Set root password? [Y/n]\"
    send \"Y\r\"
    expect \"New password:\"
    send \"$MYSQL_PASSWORD\r\"
    expect \"Re-enter new password:\"
    send \"$MYSQL_PASSWORD\r\"
    expect \"Remove anonymous users? [Y/n]\"
    send \"Y\r\"
    expect \"Disallow root login remotely? [Y/n]\"
    send \"Y\r\"
    expect \"Remove test database and access to it? [Y/n]\"
    send \"Y\r\"
    expect \"Reload privilege tables now? [Y/n]\"
    send \"Y\r\"
    expect eof
    ")

    echo "$SECURE_MYSQL"

    # Log into MySQL client and perform activities
    mysql -u $MYSQL_USER <<EOF
    CREATE USER 'wiki'@'localhost';
    CREATE DATABASE rbtest;
    GRANT ALL PRIVILEGES ON rbtest.* TO 'wiki'@'localhost';
    FLUSH PRIVILEGES;
    SHOW DATABASES;
    SHOW GRANTS FOR 'wiki'@'localhost';
EOF

    # Autostart webserver and database daemons (services)
    systemctl enable mariadb
    systemctl enable httpd
}


installMediaWiki() {
    # Install MediaWiki
    cd ~/
    wget https://releases.wikimedia.org/mediawiki/1.41/mediawiki-1.41.1.tar.gz
    wget https://releases.wikimedia.org/mediawiki/1.41/mediawiki-1.41.1.tar.gz.sig
    gpg --verify mediawiki-1.41.1.tar.gz.sig mediawiki-1.41.1.tar.gz

    tar -zxf ~/mediawiki-1.41.1.tar.gz -C /var/www
    ln -s /var/www/mediawiki-1.41.1 /var/www/mediawiki
    chown -R apache:apache /var/www/mediawiki-1.41.1

    # Webserver (Apache) post-install configuration
    sed -i 's|DocumentRoot "/var/www/html"|DocumentRoot "/var/www/mediawiki"|g' /etc/httpd/conf/httpd.conf
    sed -i 's|<Directory "/var/www/html">|<Directory "/var/www/mediawiki">|g' /etc/httpd/conf/httpd.conf
    sed -i 's|DirectoryIndex index.html|DirectoryIndex index.html index.html.var index.php|g' /etc/httpd/conf/httpd.conf

    systemctl restart httpd
}


security() {
    # Firewall configuration
    firewall-cmd --permanent --zone=public --add-service=http
    firewall-cmd --permanent --zone=public --add-service=https
    systemctl restart firewalld

    # SELinux
    getenforce
    restorecon -FR /var/www/mediawiki-1.41.1/
    restorecon -FR /var/www/mediawiki
    ls -lZ /var/www/
}

# RUN
updates
installMySQL
installMediaWiki
security
