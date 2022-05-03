#!/bin/bash

ls /input_path

rm -r /benchmark/outputs || true
# Ensure slow5 files are available in the output dir:
mkdir -p /benchmark/outputs/
cp -r /input_path/mkr_files /benchmark/outputs/mkr_files
cp -r /input_path/slow5_files /benchmark/outputs/slow5_files
cp -r /input_path/fast5_files /benchmark/outputs/fast5_files

echo "fast5"
/benchmark-tools/time.py "fast5" -- /benchmark-tools/find_and_get_fast5.py /input_path/fast5_files /benchmark/outputs/fast5_files

echo "mkr c_api"
/benchmark-tools/time.py "mkr" -- /benchmark-tools/find_and_get_mkr.py /input_path/mkr_files_c_api /benchmark/outputs/mkr_files_c_api --c-api

echo "mkr pyarrow"
/benchmark-tools/time.py "mkr" -- /benchmark-tools/find_and_get_mkr.py /input_path/mkr_files_pyarrow /benchmark/outputs/mkr_files_pyarrow

echo "slow5"
/benchmark-tools/time.py "slow5" -- /benchmark-tools/find_and_get_slow5.py /input_path/slow5_files /benchmark/outputs/slow5_files

echo "check"
/benchmark-tools/check_csvs_consistent.py /benchmark/outputs/fast5_files/read_ids.csv /benchmark/outputs/slow5_files/read_ids.csv
/benchmark-tools/check_csvs_consistent.py /benchmark/outputs/mkr_files_c_api/read_ids.csv /benchmark/outputs/slow5_files/read_ids.csv
/benchmark-tools/check_csvs_consistent.py /benchmark/outputs/mkr_files_pyarrow/read_ids.csv /benchmark/outputs/slow5_files/read_ids.csv