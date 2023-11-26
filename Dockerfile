FROM debian:stable-slim as builder

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl wget git ca-certificates gnupg && \
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y dotnet-sdk-7.0 && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=20 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install nodejs -y 

RUN cd /opt && git clone https://github.com/LANCommander/LANCommander.git && cd LANCommander && git checkout v0.1.3
WORKDIR /opt/LANCommander
RUN dotnet restore && cd LANCommander/wwwroot/scripts && npm install && cd /opt/LANCommander && \
    dotnet build "./LANCommander/LANCommander.csproj" --no-restore /p:Version="0.1.3" && \
    dotnet publish "./LANCommander/LANCommander.csproj" -c Release -o _Build --self-contained --os linux -p:PublishSignleFile=true && \
    mkdir _Build/data

FROM debian:stable-slim

RUN apt-get update && apt-get install -y wget && wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb && apt-get update && apt-get install -y aspnetcore-runtime-7.0
COPY --from=builder /opt/LANCommander/_Build /opt/LANCommander
WORKDIR /opt/LANCommander

EXPOSE 1337

CMD /opt/LANCommander/LANCommander
