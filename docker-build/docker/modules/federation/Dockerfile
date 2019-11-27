FROM mcr.microsoft.com/java/jre:8u192-zulu-alpine

WORKDIR /data/projects/fate/federation

ADD fate-federation-*.tar.gz /data/projects/fate/federation/

RUN ln -s fate-federation-${federation_version}.jar fate-federation.jar

EXPOSE 9394

CMD cd /data/projects/fate/federation && \
    java -cp "conf/:lib/*:fate-federation.jar" com.webank.ai.fate.driver.Federation -c conf/federation.properties

