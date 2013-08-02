#!/bin/sh

set -e

rm -rf /root/.nvm/v0.10.15/lib/node_modules/bace
rm -rf /root/.nvm/v0.10.15/bin/bace
scripts/compile.sh
npm publish /bace
npm i bace -g
