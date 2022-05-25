\set region_id 0
\set ns_id random_zipfian(1, 10, 1.1)
\set emitter random_zipfian(1000, 3000, 1.1)
\set root_player_id random(1, 100000*:scale)
\set currency_id random_zipfian(1, 50, 1.1)
\set amount random(1, 10000)
BEGIN;
INSERT INTO trx_pgbench_0
    (id, ns_id, idempotency_key,
     origin, type, hold, status, meta_data, internal_meta_data, emitter,
     root_player_id, reason)
VALUES
    (nextval('trx_pgbench_seq_0'),
     :ns_id, gen_random_uuid(), NULL, 'normal', NULL, 'finished',
     '{"reason": 0, "eventID": null}', NULL, :emitter, :root_player_id, 'game');

INSERT INTO op_pgbench_0
    (id, ns_id, player_id, trx_id, currency_id, amount, balance_id, type)
VALUES
    (nextval('op_pgbench_seq_0'),
     :ns_id, :root_player_id, currval('trx_pgbench_seq_0'),
     :currency_id, :amount, NULL, 'grant');


INSERT INTO balance_version_pgbench_0
    (root_player_id, balance_version)
VALUES
    (:root_player_id, nextval('balance_version_pgbench_seq_0'))
ON CONFLICT (root_player_id) DO UPDATE
    SET balance_version = excluded.balance_version;

INSERT INTO balance_pgbench_0
    (ns_id, player_id, currency_id, amount, classifier_id)
VALUES
    (:ns_id, :root_player_id, :currency_id, :amount, 0)
ON CONFLICT (ns_id, player_id, currency_id) DO UPDATE
    SET amount = balance_pgbench_0.amount + :amount;
END;
