FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

# install packages
RUN apt-get update -qq
RUN apt-get install -y syslog-ng-core \
                       syslog-ng \
                       postfix \
                       postfix-mysql \
                       dovecot-core \
                       dovecot-mysql \
                       dovecot-imapd \
                       dovecot-lmtpd \
                       spamassassin \
                       postfix-policyd-spf-python

# add vmail user and group
RUN groupadd -g 5000 vmail
RUN useradd -g vmail -u 5000 vmail -d /home/vmail
RUN mkdir /home/vmail
RUN chown -R vmail:vmail /home/vmail

# copy dovecot and postfix configurations
COPY dovecot /etc/dovecot
COPY postfix /etc/postfix
COPY postfix-policyd-spf-python /etc/postfix-policyd-spf-python

# enable spamassassin
RUN sed -i "s/ENABLED=0/ENABLED=1/g" /etc/default/spamassassin

# copy run script
COPY entrypoint.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/entrypoint.sh
RUN ln -s /usr/local/bin/entrypoint.sh /

# cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*


EXPOSE 25 587 993
#CMD [ "postfix start" ]
#CMD ["/usr/sbin/postfix", "start-fg", "&"]
ENTRYPOINT ["entrypoint.sh"]

