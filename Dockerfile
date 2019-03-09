FROM codercom/code-server

WORKDIR /root
# install dependency
RUN apt-get update \
 && apt-get install -y \
    libx11-xcb1 \
    libasound2 \
    curl \
    gnupg2 \
    git \
    python \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install vscode
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
 && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
 && rm microsoft.gpg \
 && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
 && apt-get update \
 && apt-get install -y code \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# https://go.microsoft.com/fwlink/?LinkID=760868
COPY scripts /usr/local/bin
COPY extensions.txt /root

# Install golang
ENV PATH /usr/local/go/bin:$PATH
ARG go_version="1.12"
ARG go_os="linux"
ARG go_arch="amd64"
RUN curl -O https://dl.google.com/go/go$go_version.$go_os-$go_arch.tar.gz \
 && tar -C /usr/local -xzf go$go_version.$go_os-$go_arch.tar.gz \
 && rm -f go$go_version.$go_os-$go_arch.tar.gz \
 && go get -u github.com/mdempsky/gocode \
 && go get -u github.com/uudashr/gopkgs/cmd/gopkgs \
 && go get -u github.com/ramya-rao-a/go-outline \
 && go get -u github.com/acroca/go-symbols \
 && go get -u golang.org/x/tools/cmd/guru \
 && go get -u golang.org/x/tools/cmd/gorename \
 && go get -u github.com/go-delve/delve/cmd/dlv \
 && go get -u github.com/stamblerre/gocode \
 && go get -u github.com/rogpeppe/godef \
 && go get -u github.com/sqs/goreturns \
 && go get -u golang.org/x/lint/golint \
 && go get -u github.com/cweill/gotests/... \
 && go get -u github.com/fatih/gomodifytags \
 && go get -u github.com/josharian/impl \
 && go get -u github.com/davidrjenni/reftools/cmd/fillstruct \
 && go get -u github.com/haya14busa/goplay/cmd/goplay

# Install node
ARG nvm_version="0.34.0"
ARG node_version="11.11.0"
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v$nvm_version/install.sh | bash \
 && . /root/.bashrc \
 && nvm install v$node_version \
 && nvm use v$node_version \
 && npm i -g yarn

# Install vscode extensions
RUN install-extensions.sh

COPY settings.json /root/.code-server/User/settings.json

WORKDIR /root/project

CMD ["entrypoint.sh"]
