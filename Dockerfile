FROM drydock-prod.workiva.net/workiva/dart2_base_image:1

ARG NPM_TOKEN
ARG NPM_CONFIG__AUTH
ARG NPM_CONFIG_REGISTRY=https://npm.workiva.net
ARG NPM_CONFIG_ALWAYS_AUTH=true

WORKDIR /build/
ADD . /build/
RUN pub get

RUN npm install
RUN mkdir /audit/
ARG BUILD_ARTIFACTS_AUDIT=/audit/*

RUN npm ls -s --json --depth=10 > /audit/npm.lock || [ $? -eq 1 ] || exit
FROM scratch
