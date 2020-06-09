FROM pandoc/latex:latest

WORKDIR /src
# RUN apk add bash git go jq qpdf

ADD https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip /src/pup.zip
ADD https://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz /src/kindlegen/kindlegen.tar.gz

RUN unzip pup.zip && \
    mv pup /usr/bin && \
    rm pup.zip && \
    cd kindlegen && \
    tar zxf kindlegen.tar.gz && \
    mv kindlegen /usr/bin && \
    cd .. && \
    rm -rf kindlegen && \
    apk add --no-cache bash jq qpdf

COPY cover.pdf cover.jpg generate.sh /src/

VOLUME /src/out

ENTRYPOINT ["/src/generate.sh"]
