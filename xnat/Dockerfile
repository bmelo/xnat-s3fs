#FROM tomcat:7-jre7-alpine
FROM tomcat:7-jre7
LABEL author="Bruno Melo <bruno.melo@idor.org>"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        gnupg2 \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends docker-ce && \
    apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y

RUN cd webapps && \
    rm -rf * && \
    curl -L -o ROOT.war https://api.bitbucket.org/2.0/repositories/xnatdev/xnat-web/downloads/xnat-web-1.7.5.3.war && \
    unzip -q ROOT.war -d ROOT && \
    rm ROOT.war

# CONFIGURING DIRECTORIES
RUN mkdir -p /data/xnat && cd /data/xnat && \
    mkdir home archive build cache ftp prearchive pipeline && \
    mkdir home/config home/logs home/plugins home/work

# Installing XNAT-PIPELINE ENGINE
RUN mkdir -p /tmp/pipeline && cd /tmp/pipeline && \
    curl -L -o xnat-pipeline.zip https://github.com/NrgXnat/xnat-pipeline-engine/archive/1.7.5.zip && \
    unzip xnat-pipeline.zip && rm *.zip && \
    mv *pipeline-engine* xnat-pipeline && cd /tmp/pipeline/xnat-pipeline && \
    echo xnatUrl=http://web:8080 >> gradle.properties && \
    echo siteName=XNAT >> gradle.properties && \
    echo adminEmail=bruno.melo@idor.org >> gradle.properties && \
    echo smtpServer=smtp >> gradle.properties && \
    echo destination=/data/xnat/pipeline >> gradle.properties && \
    ./gradlew && cd ~ && rm -rf /tmp/pipeline

# PREPARING TO USE S3 with YAS3FS (not working well)
# RUN apt-get update -q && apt-get install -y python-pip fuse \
# 	&& apt-get clean -y && rm -rf /var/lib/apt/lists/*
# RUN pip install yas3fs
# RUN sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf # uncomment user_allow_other
# RUN chmod a+r /etc/fuse.conf # make it readable by anybody, it is not the default on Ubuntu

# PREPARING TO USE S3 with S3FS
RUN apt-get update -y && \
    apt-get install -y build-essential git libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool pkg-config libssl-dev && \
    git clone https://github.com/s3fs-fuse/s3fs-fuse && \
    cd s3fs-fuse/ && \
    ./autogen.sh && ./configure --prefix=/usr --with-openssl && make && make install && \
    cd .. && rm -rf s3fs-fuse && \
    apt-get purge -y --auto-remove build-essential git libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool pkg-config libssl-dev && \
    apt-get install -y libfuse2 && \
    apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y
RUN mkdir /mnt/s3fsdata /tmp/s3cache

# LAST DATA
COPY home /data/xnat/home
COPY run.sh /
COPY ROOT webapps/ROOT
RUN chmod +x /run.sh
ENV CATALINA_OPTS="-Dxnat.home=/data/xnat/home \
 -Xms512m -Xmx1g -XX:+UseConcMarkSweepGC -XX:-OmitStackTraceInFastThrow" \
    JAVA_OPTS="-Djava.awt.headless=true"

#COPY conf/tomcat7.conf conf/
ENTRYPOINT [ "/run.sh" ]

EXPOSE 8080 8104
