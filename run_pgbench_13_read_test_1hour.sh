#!/bin/sh

mkdir -p pgbench_logs_orioledb
shard_id=0
export PGPASSWORD=orioledb_wgtest
/usr/pgsql-13/bin/pgbench -h localhost -p5445 -U orioledb_wgtest --no-vacuum --progress=10 --jobs=5 \
        --define=shard_num=$shard_id  --time=3600 --client=50 \
        --report-latencies -f pgbench_read_orioledb.sql  orioledb_wgtest > pgbench_logs_orioledb/pgbench_read_$shard_id_`date "+%Y-%m-%dT%H:%M:%S.%N"`.log 2>&1 
