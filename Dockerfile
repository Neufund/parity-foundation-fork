FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y \
    curl \
    supervisor;

RUN curl --fail -o parity.deb http://d1h4xl4cr1h0mo.cloudfront.net/v1.9.7/x86_64-unknown-linux-gnu/parity_1.9.7_ubuntu_amd64.deb

RUN dpkg -i parity.deb

RUN mkdir /var/parity && \
    mkdir /var/parity/keys && \
    mkdir /var/parity/keys/foundation-fork/ && \
    mkdir /var/parity/signer

COPY foundation-fork.json /var/parity/chains/foundation-fork.json
COPY keys/ /var/parity/keys/foundation-fork/
COPY password /var/parity/password
COPY authcodes /var/parity/signer/authcodes

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:ethereum/ethereum && \
    apt-get update && \
    apt-get install -y ethminer
# RUN parity --chain /var/parity/chains/foundation-fork.json signer new-token
# RUN parity --datadir /var/parity signer new-token
# RUN parity --ui-path /var/parity/signer signer new-token

# EXPOSE 8180
CMD ["/usr/bin/supervisord"]
