FROM alpine:3.18

RUN apk add --no-cache bash

WORKDIR /abc
COPY shared/geth /abc/geth
COPY shared/start-node.sh /abc/start.sh

RUN chmod +x /abc/geth
RUN sed -i 's/\r$//' /abc/start.sh
RUN chmod +x /abc/start.sh