# llama/Dockerfile
# Build llama.cpp (llama-server) + install libs, then copy runtime with needed shared libraries

FROM ubuntu:24.04 AS build

RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    libcurl4-openssl-dev \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone https://github.com/ggerganov/llama.cpp.git .

# Build + install into /usr/local inside build stage (brings .so libs too)
RUN mkdir -p build && cd build \
  && cmake -DLLAMA_BUILD_SERVER=ON .. \
  && cmake --build . --config Release -j4 \
  && cmake --install . --prefix /usr/local

# -------------------------
# Runtime image
# -------------------------
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
  && rm -rf /var/lib/apt/lists/*

# Copy server binary AND all installed shared libs from build stage
COPY --from=build /usr/local/bin/llama-server /usr/local/bin/llama-server
COPY --from=build /usr/local/lib/ /usr/local/lib/

# Ensure the dynamic loader can find the libs
RUN ldconfig

WORKDIR /app
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

EXPOSE 8080
CMD ["/app/run.sh"]
