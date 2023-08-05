FROM centos:7

# Install necessary packages
RUN yum -y update && yum -y install httpd php php-mysqlnd git

# Clone e-commerce application
RUN git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/

# Update database host in e-commerce application configuration
RUN sed -i 's/172.20.1.101/db/g' /var/www/html/index.php

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
