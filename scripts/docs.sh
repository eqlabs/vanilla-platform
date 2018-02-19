#!/bin/sh

WORKDIR=`pwd`
CONTRACTS_DIR=./contracts

cd $CONTRACTS_DIR
for name in *.sol ; do
  node $WORKDIR/node_modules/solmd/lib/bin/solmd.js "${name%.sol}.sol" --dest $WORKDIR/docs/"${name%.*}".md
done
