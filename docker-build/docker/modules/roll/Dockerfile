FROM mcr.microsoft.com/java/jre:8u192-zulu-alpine

WORKDIR /data/projects/fate/roll

ADD eggroll-roll-*.tar.gz /data/projects/fate/roll/

RUN ln -s eggroll-roll-*.jar fate-roll.jar

CMD cd roll && \
    java -cp "conf/:lib/*:fate-roll.jar" com.webank.ai.eggroll.framework.Roll -c conf/roll.properties

