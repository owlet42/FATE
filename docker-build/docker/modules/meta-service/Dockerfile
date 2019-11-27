FROM mcr.microsoft.com/java/jre:8u192-zulu-alpine

WORKDIR /data/projects/fate/meta-service

ADD eggroll-meta-service-*.tar.gz /data/projects/fate/meta-service/

RUN ln -s eggroll-meta-service-*.jar fate-meta-service.jar

EXPOSE 8590

CMD java -cp "conf/:lib/*:fate-meta-service.jar" com.webank.ai.eggroll.framework.MetaService -c conf/meta-service.properties

