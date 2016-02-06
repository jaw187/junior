#!/bin/bash

NODE_VERSION=$1

PATH=/node/bin:${PATH}
CURRENT=$(/node/bin/node --version)
if [ "${CURRENT}" == "${NODE_VERSION}" ];
then
    echo "Already at version ${NODE_VERSION}"
else
    cd /tmp
    curl -s -O "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz"
    tar xf node-v${NODE_VERSION}-linux-x64.tar.xz
    sudo mv node-v${NODE_VERSION}-linux-x64 /node
    sudo rm -rf node*

    NEW_VERSION=$(/node/bin/node --version)
    if [ "${NEW_VERSION}" != "${NODE_VERSION}" ];
    then
        echo "${NEW_VERSION} did not match ${NODE_VERSION}"
        exit 1
    fi
fi

## install global npm
for PACKAGE in npm
do
   LATEST=$(/node/bin/npm show ${PACKAGE} version | head -1)
   CURRENT=$(${PACKAGE} --version)
   if [ "${LATEST}" != "${CURRENT}" ];
   then
      echo "Upgrading ${PACKAGE} from version ${CURRENT} to version ${LATEST}"
      # npm attempts to write to /tmp
      # sudo chmod 1777 /tmp
      /node/bin/npm -g install ${PACKAGE}
   else
      echo "${PACKAGE} already at latest version ${LATEST}"
   fi
done
