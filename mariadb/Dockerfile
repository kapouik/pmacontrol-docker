FROM mariadb:10.11


RUN apt-get update -qq && \
    apt-get install -qy \
    mariadb-plugin-rocksdb && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

