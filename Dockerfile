FROM codercom/code-server

WORKDIR /root
# install dependency
RUN apt-get update \
 && apt-get install -y \
    libx11-xcb1 \
    libasound2 \
    curl \
    gnupg2 \
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

# install dependency and extensions
RUN provision.sh \
 && install-extensions.sh

WORKDIR /root/project

CMD ["entrypoint.sh"]
