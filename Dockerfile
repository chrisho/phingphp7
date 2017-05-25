FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

VOLUME /var/jenkins_home

RUN echo 'deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib' > /etc/apt/sources.list \
    && echo 'deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib' >> /etc/apt/sources.list \
    && echo 'deb-src http://mirrors.aliyun.com/debian/ jessie main non-free contrib' >> /etc/apt/sources.list \
    && echo 'deb-src http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib' >> /etc/apt/sources.list \
    && echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
    && echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
    && apt-get update

RUN cd /tmp \
    && wget https://www.dotdeb.org/dotdeb.gpg \
    && apt-key add dotdeb.gpg \
    && rm dotdeb.gpg \
    && apt-get update

RUN apt-get install -y init-system-helpers libapparmor1 libmagic1 libxslt1.1 \
      php7.0-common php7.0-json php7.0-opcache php7.0-readline php7.0-xml \
      php7.0 php7.0-fpm php7.0-cli php-pear phpmd phpcpd php7.0-mcrypt php7.0-mysql \
      phploc php7.0-mbstring php7.0-mongodb

RUN pear install PHP_CodeSniffer
RUN pear channel-discover pear.phing.info
RUN pear install phing/phing-2.16.0 \
    && pear install phing/phingdocs-2.16.0 

RUN wget http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -O /usr/local/bin/php-cs-fixer \
    && chmod +x /usr/local/bin/php-cs-fixer