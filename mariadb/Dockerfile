FROM mariadb:10.11

# Activer le plugin disk
RUN echo "[mysqld]" >> /etc/mysql/mariadb.conf.d/50-disk.cnf \
    && echo "plugin-load-add=disk" >> /etc/mysql/mariadb.conf.d/50-disk.cnf


RUN apt-get update -qq && \
    apt-get install -qy \
    mariadb-plugin-rocksdb && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

