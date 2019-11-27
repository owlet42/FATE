# runtime envrionment
ARG PREFIX=prefix
ARG BASE_TAG=tag
FROM ${PREFIX}/base-image:${BASE_TAG}

WORKDIR /data/projects/fate/python

COPY  fate_flow /data/projects/fate/python/fate_flow
COPY  arch /data/projects/fate/python/arch
COPY  federatedml /data/projects/fate/python/federatedml
COPY  examples /data/projects/fate/python/examples
ADD  eggroll-api-*.tar.gz /data/projects/fate/python/

ENV PYTHONPATH=/data/projects/fate/python
CMD sleep 5; source /data/projects/python/venv/bin/activate && cd /data/projects/fate/python/fate_flow && \
    python fate_flow_server.py