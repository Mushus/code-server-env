#!/bin/sh

grep -v -e '^\s*#' -e '^\s*$' /root/extensions.txt | awk '{system("code --user-data-dir --extensions-dir /root/.code-server/extensions --install-extension "$1)}'
