FROM ubuntu:24.04 AS build
RUN apt-get update && apt-get install -y git cmake build-essential && rm -rf /var/lib/apt/lists/*
WORKDIR /src
RUN git clone https://github.com/ggerganov/llama.cpp.git .
RUN mkdir -p build && cd build && cmake -DLLAMA_BUILD_SERVER=ON .. && cmake --build . --config Release -j4

FROM ubuntu:24.04
RUN apt-get update && apt-get install -y ca-certificates curl && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/build/bin/llama-server /usr/local/bin/llama-server
WORKDIR /app
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh
EXPOSE 8080
CMD ["/app/run.sh"]
