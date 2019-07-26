FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y \
    curl \
    supervisor;

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ethereum/ethereum && \
    apt-get update && \
    apt-get install -y ethminer


RUN curl --fail -o parity https://releases.parity.io/ethereum/v2.4.2/x86_64-unknown-linux-gnu/parity
RUN mv parity /usr/bin && chmod +x /usr/bin/parity

RUN mkdir /var/parity && \
    mkdir /var/parity/keys && \
    mkdir /var/parity/keys/foundation-fork/ && \
    mkdir /var/parity/signer

COPY foundation-fork.json /var/parity/chains/foundation-fork.json
COPY keys/ /var/parity/keys/foundation-fork/
COPY password /var/parity/password
COPY authcodes /var/parity/signer/authcodes
COPY peers.txt /var/parity/peers.txt

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY cleanup.sh /root/cleanup.sh

CMD ["/usr/bin/supervisord"]
