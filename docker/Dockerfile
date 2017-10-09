FROM ruby:2.3
MAINTAINER admin@insales.ru

RUN \
    groupadd rails && \
    useradd rails -m -g rails && \
    usermod -a -G sudo,adm rails

RUN \
    apt-get update -qq \
    && apt-get install -y \
        supervisor \
        sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
    echo 'rails ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/rails_without_password && \
    chmod 600 /etc/sudoers.d/rails_without_password

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Do not copy gem package documentation
RUN echo "gem: --no-ri --no-rdoc" > /home/rails/.gemrc

RUN gem install bundler \
    && gem cleanup

COPY run-webapp.sh /home/rails/run-webapp.sh

RUN \
    chown rails:rails /home/rails/.gemrc \
        /home/rails/run-webapp.sh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
