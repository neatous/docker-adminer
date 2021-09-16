FROM 	neatous/phpbase:8.0

ENV	ACCEPT_EULA=Y
ENV 	TERM xterm

ENV 	ADMINER_DG_VERION=1.28.1
ENV 	MEMORY=256M
ENV 	UPLOAD=2048M

RUN	apt-get update && apt-get -y install unixodbc unixodbc-dev

RUN	cd /tmp  && \
	wget https://packages.microsoft.com/debian/10/prod/pool/main/m/msodbcsql17/msodbcsql17_17.8.1.1-1_amd64.deb && \
	dpkg -i msodbcsql17_17.8.1.1-1_amd64.deb && \
	rm -f msodbcsql17_17.8.1.1-1_amd64.deb

RUN 	pecl install sqlsrv pdo_sqlsrv && \
	docker-php-ext-enable sqlsrv pdo_sqlsrv

RUN 	sed -i -e 's/MinProtocol = TLSv1.2/MinProtocol = TLSv1.0/g' /etc/ssl/openssl.cnf

RUN 	wget https://github.com/dg/adminer-custom/archive/v$ADMINER_DG_VERION.tar.gz -O /srv/adminer.tgz && \
	tar zxvf /srv/adminer.tgz --strip-components=1 -C /srv && \
	rm /srv/adminer.tgz

WORKDIR /srv
EXPOSE 	80

CMD 	php \
	-d memory_limit=$MEMORY \
	-d upload_max_filesize=$UPLOAD \
	-d post_max_size=$UPLOAD \
	-S 0.0.0.0:80
