#!/bin/bash
#set -x # habilita debug
#set +x # desabilita debug
echo Move-se para a pasta $1
find './' -type d -iname '$1'
