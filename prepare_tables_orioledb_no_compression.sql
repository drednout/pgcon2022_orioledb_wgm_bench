CREATE EXTENSION orioledb;
CREATE TYPE trx_type AS ENUM ('void','normal');
CREATE TYPE trx_status AS ENUM ('finished','in_progress');
CREATE TYPE trx_hold AS ENUM ('begin','commit', 'rollback');
CREATE TYPE trx_origin AS ENUM ('receipt','invoice', 'game');
CREATE TYPE trx_reason AS ENUM ('game','purchase', 'other');

CREATE TYPE op_type AS ENUM ('grant','consume');

CREATE TABLE public.trx_pgbench_0 (
    id bigint NOT NULL,
    root_player_id bigint NOT NULL,
    emitter smallint NOT NULL,
    ns_id integer NOT NULL,
    idempotency_key uuid NOT NULL,
    type public.trx_type NOT NULL,
    origin public.trx_origin,
    meta_data jsonb,
    internal_meta_data jsonb,
    status public.trx_status DEFAULT 'finished'::public.trx_status NOT NULL,
    hold public.trx_hold,
    reason public.trx_reason,
    created timestamp without time zone DEFAULT timezone('UTC'::text, now()),
    updated timestamp without time zone DEFAULT timezone('UTC'::text, now())
) USING orioledb;


ALTER TABLE public.trx_pgbench_0 OWNER TO orioledb_wgtest;

--
-- Name: trx_pgbench_0 trx_pgbench_0_pkey; Type: CONSTRAINT; Schema: public; Owner: orioledb_wgtest
--

ALTER TABLE ONLY public.trx_pgbench_0
    ADD CONSTRAINT trx_pgbench_0_pkey PRIMARY KEY (id);


--
-- Name: trx_pgbench_0_idempotency_idx; Type: INDEX; Schema: public; Owner: orioledb_wgtest
--

CREATE UNIQUE INDEX trx_pgbench_0_idempotency_idx ON public.trx_pgbench_0 USING btree (root_player_id, emitter, idempotency_key, ns_id);


--
-- Name: trx_pgbench_0_status_holds_idx; Type: INDEX; Schema: public; Owner: orioledb_wgtest
--

CREATE INDEX trx_pgbench_0_status_holds_idx ON public.trx_pgbench_0 USING btree (status, hold);



CREATE TABLE public.balance_pgbench_0 (
    ns_id integer NOT NULL,
    player_id bigint NOT NULL,
    currency_id integer NOT NULL,
    amount bigint,
    expires_after timestamp without time zone,
    priority_id integer,
    created timestamp without time zone DEFAULT timezone('UTC'::text, now()),
    updated timestamp without time zone DEFAULT timezone('UTC'::text, now()),
    is_single boolean,
    classifier_id smallint DEFAULT 0 NOT NULL,
    CONSTRAINT balance_pgbench_0_amount_check CHECK ((amount >= 0))
) USING orioledb;


ALTER TABLE public.balance_pgbench_0 OWNER TO orioledb_wgtest;

--
-- Name: balance_pgbench_0 balance_pgbench_0_pkey; Type: CONSTRAINT; Schema: public; Owner: orioledb_wgtest
--

ALTER TABLE ONLY public.balance_pgbench_0
    ADD CONSTRAINT balance_pgbench_0_pkey PRIMARY KEY (ns_id, player_id, currency_id);

CREATE TABLE public.op_pgbench_0 (
    id bigint NOT NULL,
    ns_id integer NOT NULL,
    player_id bigint NOT NULL,
    trx_id bigint NOT NULL,
    currency_id integer,
    amount bigint,
    balance_id bigint,
    created timestamp without time zone DEFAULT timezone('UTC'::text, now()),
    type public.op_type NOT NULL,
    "order" smallint,
    CONSTRAINT op_pgbench_0_amount_check CHECK ((amount >= 0))
) USING orioledb;


ALTER TABLE public.op_pgbench_0 OWNER TO orioledb_wgtest;

--
-- Name: op_pgbench_0 op_pgbench_0_pkey; Type: CONSTRAINT; Schema: public; Owner: orioledb_wgtest
--

ALTER TABLE ONLY public.op_pgbench_0
    ADD CONSTRAINT op_pgbench_0_pkey PRIMARY KEY (id);

--
-- Name: op_pgbench_0_ns_player_id_idx; Type: INDEX; Schema: public; Owner: orioledb_wgtest
--

CREATE INDEX op_pgbench_0_ns_player_id_idx ON public.op_pgbench_0 USING btree (ns_id, player_id);


--
-- Name: op_pgbench_0_balance_id_idx; Type: INDEX; Schema: public; Owner: orioledb_wgtest
--

CREATE INDEX op_pgbench_0_balance_id_idx ON public.op_pgbench_0 USING btree (balance_id);


--
-- Name: op_pgbench_0_trx_id_idx; Type: INDEX; Schema: public; Owner: orioledb_wgtest
--

CREATE INDEX op_pgbench_0_trx_id_idx ON public.op_pgbench_0 USING btree (trx_id);


CREATE TABLE public.balance_version_pgbench_0 (
    root_player_id bigint NOT NULL,
    balance_version bigint NOT NULL
) USING orioledb;


ALTER TABLE public.balance_version_pgbench_0 OWNER TO orioledb_wgtest;

--
-- Name: balance_version_pgbench_0 balance_version_pgbench_0_pkey; Type: CONSTRAINT; Schema: public; Owner: orioledb_wgtest
--

ALTER TABLE ONLY public.balance_version_pgbench_0
    ADD CONSTRAINT balance_version_pgbench_0_pkey PRIMARY KEY (root_player_id);


create sequence IF NOT EXISTS trx_pgbench_seq_0 cache 1024;
create sequence IF NOT EXISTS op_pgbench_seq_0 cache 1024;
create sequence IF NOT EXISTS balance_version_pgbench_seq_0 cache 1024;
