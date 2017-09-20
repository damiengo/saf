#!/bin/bash

script=`realpath -s $0`
scriptpath=`dirname $script`
datapath=${scriptpath}/../../../data/stats/expg/expg_prepared_data

python project/engineer_data.py ${datapath}/prepared ${datapath}/engineered
