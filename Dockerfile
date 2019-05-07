FROM	centos:7


RUN 	yum -y update; \
	yum -y install net-tools \
	openssl098e httpd make mysql \
	php php-pear php-mysql psmisc \
	php-cli php-pdo php-pear php-pear \
	php-xml


COPY	files/fop2-2.31.21-centos-x86_64.tgz /tmp/
COPY	files/ns-start /usr/bin/
COPY	files/httpd.conf /etc/httpd/conf/
COPY	files/gen_conf /usr/bin/

RUN	cd /tmp; \
	tar -xzvf fop2-2.31.21-centos-x86_64.tgz; \
	cd fop2; \
	make


RUN     adduser --system --no-create-home asterisk --uid=10000; \
        groupmod -g 10000 asterisk; \
        chown -R asterisk.asterisk /etc/httpd; \
        chown -R asterisk.asterisk /var/log/httpd; \
        chown -R asterisk.asterisk /var/lib/php; \
	rm -rf /tmp/* ;\
	cp -rf /usr/local/fop2/fop2.cfg /opt/; \
	cp -rf /var/www/html/fop2/admin/config.php /opt/



RUN	chmod +x /usr/bin/ns-start; \
	chmod +x /usr/bin/gen_conf





ENTRYPOINT	["/usr/bin/ns-start"]
