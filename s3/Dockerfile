FROM innovativetravel/aws-s3-mount
LABEL author="Bruno Melo <bruno.melo@idor.org>"


RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        nfs-server nfs-kernel-server && \
    apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y


RUN echo "/mnt    web(rw,sync,fsid=1,no_subtree_check) s3(rw,sync,fsid=1,no_subtree_check) localhost(rw,sync,fsid=1,no_subtree_check) 172.19.0.5(rw,sync,fsid=1,no_subtree_check)" >> /etc/exports && \
    exportfs -a && \
    service nfs-kernel-server restart && \
    service rpcbind restart


EXPOSE 2049 111 32767

