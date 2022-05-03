#!/bin/bash

ls /input_path

rm -r /benchmark/outputs || true

mkdir -p /benchmark/outputs/fast5_files
cp -r /input_path/* /benchmark/outputs/fast5_files

echo "Converting fast5 to mkr"
/benchmark-tools/time.py "mkr" -- mkr-convert-fast5 /input_path /benchmark/outputs/mkr_files

echo "Converting fast5 to slow5"
/benchmark-tools/time.py "slow5" -- /benchmark-tools/fast5_to_single_blow5.sh /input_path /benchmark/outputs/slow5_files

du -sh /benchmark/outputs/*