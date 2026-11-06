# Single-stage Alpine build (no COPY --from: some PaaS builders cannot resolve
# the scratch-based official xray image stage). Downloads the official release.
FROM alpine:latest
RUN apk add --no-cache ca-certificates curl unzip \
  && curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v26.10.31/Xray-linux-64.zip \
  && echo "e4bd9119f50ae7c41658b1abd0679ae06f98bd864a2907ff33f2f2cf7081b214  /tmp/xray.zip" | sha256sum -c - \
  && unzip -o /tmp/xray.zip xray -d /usr/bin/ \
  && chmod +x /usr/bin/xray \
  && rm /tmp/xray.zip
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
