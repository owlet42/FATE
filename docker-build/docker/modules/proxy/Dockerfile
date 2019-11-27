FROM mcr.microsoft.com/java/jre:8u192-zulu-alpine

WORKDI /data/projects/fate

COPY fate-proxy-*.tar.gz /data/projects/fate/proxy/

RUN ln -s fate-proxy-*.jar fate-proxy.jar

EXPOSE 9370

CMD cd /data/projects/fate/proxy && \
    java -cp "conf/:lib/*:fate-proxy.jar" com.webank.ai.fate.networking.Proxy -c conf/proxy.properties
