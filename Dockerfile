FROM centos:7

# Set up an alternative mirror
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Install necessary packages
RUN yum -y update && yum -y install httpd php php-mysqlnd git

# Clone e-commerce application
RUN git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/

# This command is used to update the Apache HTTP server (httpd) configuration to use index.php 
# instead of index.html as the default index file,
RUN sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf

# Update database host in e-commerce application configuration
RUN sed -i 's/172.20.1.101/13.126.135.30/g' /var/www/html/index.php

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]


# The command `sed -i 's/172.20.1.101/db/g' /var/www/html/index.php` replaces all occurrences of the IP address `172.20.1.101` 
# with the hostname `db` in the `/var/www/html/index.php` file.

# This change is necessary because when using Docker Compose, 
# services can communicate with each other using their service names as hostnames. 
# In this case, the `db` service runs a MariaDB server, 
# so by updating the e-commerce application's configuration to use `db` as the database host, 
# it will be able to connect to the MariaDB server running in the `db` service.
