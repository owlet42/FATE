ARG PREFIX=prefix
ARG BASE_TAG=tag
FROM ${PREFIX}/base-image:${BASE_TAG}

ENV version 1.1.1
ENV egg_version 1.1

COPY eggroll-computing-${version}.tar.gz /data/projects/fate/eggroll/
COPY eggroll-api-${version}.tar.gz /data/projects/fate/eggroll/
COPY eggroll-egg-${version}.tar.gz /data/projects/fate/eggroll/
COPY eggroll-storage-service-cxx-${version}.tar.gz  /data/projects/fate/eggroll/
COPY third_party_eggrollv1.tar.gz /data/projects/fate/eggroll/
COPY federatedml /data/projects/fate/eggroll/python/federatedml
COPY arch /data/projects/fate/eggroll/python/arch
COPY fate_flow /data/projects/fate/eggroll/python/fate_flow

RUN rpm --rebuilddb && yum install -y which java-1.8.0-openjdk java-1.8.0-openjdk-devel && \
    cd /data/projects/fate/eggroll/ && \
    mkdir -p egg python/eggroll/api python/eggroll/computing storage-service-cxx && \
    tar -C ./egg -xvf eggroll-egg-${version}.tar.gz && rm eggroll-egg-${version}.tar.gz && \
    tar -C ./python/eggroll/computing -xvf eggroll-computing-${version}.tar.gz && rm eggroll-computing-${version}.tar.gz && \
    tar -C ./python/eggroll/api -xvf eggroll-api-${version}.tar.gz && rm eggroll-api-${version}.tar.gz && \
    tar -C ./storage-service-cxx -xvf eggroll-storage-service-cxx-${version}.tar.gz && rm eggroll-storage-service-cxx-${version}.tar.gz && \
    tar -C ./storage-service-cxx -xvf third_party_eggrollv1.tar.gz && rm third_party_eggrollv1.tar.gz && \
    cd storage-service-cxx && \
    sed -i "20s#-I. -I.*#-I. -I/data/projects/fate/eggroll/storage-service-cxx/third_party/include#g" ./Makefile && \
    sed -i "34s#LDFLAGS += -L.*#LDFLAGS += -L/data/projects/fate/eggroll/storage-service-cxx/third_party/lib -llmdb -lboost_system -lboost_filesystem -lglog -lgpr#g" ./Makefile && \
    sed -i "36s#PROTOC =.*#PROTOC = /data/projects/fate/eggroll/storage-service-cxx/third_party/bin/protoc#g" ./Makefile && \
    sed -i "37s#GRPC_CPP_PLUGIN =.*#GRPC_CPP_PLUGIN = /data/projects/fate/eggroll/storage-service-cxx/third_party/bin/grpc_cpp_plugin#g" ./Makefile && \
    make

CMD cd /data/projects/fate/eggroll/storage-service-cxx && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/data/projects/fate/eggroll/storage-service-cxx/third_party/lib && \
    mkdir logs && \
    ./storage-service -p 7778 -d /data/projects/fate/data-dir >> logs/console.log 2>>logs/error.log & \
    cd /data/projects/fate/eggroll/egg && \
    java -cp "conf/:lib/*:eggroll-egg-${egg_version}.jar" com.webank.ai.eggroll.framework.egg.Egg -c conf/egg.properties