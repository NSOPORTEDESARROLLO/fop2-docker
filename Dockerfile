FROM	debian:8


RUN 	        apt-get update; \
				apt-get -y upgrade; \
				apt-get -y install mysql-client php5 openssl make php5-mysql php5-xmlrpc apache2 netcat php5-sqlite net-tools dnsutils



COPY	files/fop2-2.31.21-debian-x86_64.tgz /tmp/
COPY	files/ns-start /usr/bin/
COPY	files/000-default.conf /etc/apache2/sites-enabled/
COPY	files/envvars /etc/apache2/
COPY	files/ports.conf /etc/apache2/ 
COPY	files/gen_conf /usr/bin/
COPY	files/healtcheck /usr/bin/


RUN     addgroup asterisk --gid=10000; \
		adduser --system --no-create-home asterisk --uid=10000 --gid=10000; \
        chown -R asterisk.asterisk /etc/apache2; \
        chown -R asterisk.asterisk /var/log/apache2; \
        chown -R asterisk.asterisk /var/lib/php5


RUN	cd /tmp; \
	tar -xzvf fop2-2.31.21-debian-x86_64.tgz; \
	cd fop2; \
	make



RUN 	rm -rf /tmp/* ;\
		cp -rf /usr/local/fop2/fop2.cfg /opt/; \
		cp -rf /var/www/html/fop2/admin/config.php /opt/



RUN	chmod +x /usr/bin/ns-start; \
	chmod +x /usr/bin/gen_conf; \
	chmod +x /usr/bin/healtcheck
 


HEALTHCHECK --interval=30s --timeout=5s --retries=2 CMD /usr/bin/healtcheck

ENTRYPOINT	["/usr/bin/ns-start"]
