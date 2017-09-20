#!/bin/bash

script=`realpath -s $0`
scriptpath=`dirname $script`
datapath=${scriptpath}/../../../data/stats/expg/expg_prepared_data

python project/prepare_data.py ${datapath}/extracted ${datapath}/prepared
