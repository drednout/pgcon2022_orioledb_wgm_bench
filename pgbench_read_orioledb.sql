\set ns_id random_zipfian(1, 10, 1.1)
\set root_player_id random(1, 100000*:scale)
BEGIN;
SELECT ns_id, player_id, currency_id, amount from balance_pgbench_:shard_num WHERE ns_id=:ns_id AND player_id=:root_player_id AND amount > 0 ORDER BY classifier_id DESC, created;
SELECT balance_version FROM balance_version_pgbench_:shard_num WHERE root_player_id=:root_player_id;
END;
