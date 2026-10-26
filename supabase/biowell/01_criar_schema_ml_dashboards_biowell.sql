-- Schema próprio da BIOWELL: mesmas tabelas, views, funções e regras do
-- ml_dashboards da PCXpress, sem nenhum dado. Rode uma vez no SQL Editor do Supabase.
-- Gerado a partir da exportação da estrutura do ml_dashboards.
begin;

create schema if not exists ml_dashboards_biowell;

create sequence if not exists ml_dashboards_biowell.item_daily_snapshots_id_seq as bigint increment by 1 minvalue 1 maxvalue 9223372036854775807 start with 1;

create table if not exists ml_dashboards_biowell.accounts (
  id uuid default gen_random_uuid() not null,
  account_name text not null,
  ml_user_id bigint,
  nickname text,
  site_id text,
  active boolean default true not null,
  last_sync_at timestamp with time zone,
  created_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.devolucoes (
  account_id uuid not null,
  claim_id text not null,
  return_id text,
  order_id text,
  mlb_id text,
  titulo_anuncio text,
  familia_motivo text,
  reason_id text,
  status_atual text,
  etapa_atual text,
  data_venda date,
  data_abertura timestamp with time zone,
  data_envio_comprador timestamp with time zone,
  data_recebimento timestamp with time zone,
  data_reembolso timestamp with time zone,
  ultima_atualizacao timestamp with time zone,
  unidades_devolvidas integer,
  valor_devolvido numeric,
  custo_frete_devolucao numeric,
  logistic_type text,
  synced_at timestamp with time zone default now() not null,
  sku text,
  quantidade integer,
  valor_venda numeric,
  valor_reembolsado numeric,
  comprador_apelido text,
  motivo_descricao text,
  etapa_ml text,
  status_reclamacao text,
  status_retorno text,
  descricao_status text,
  data_prevista timestamp with time zone,
  destino_retorno text,
  rastreio text,
  prazo_acao_vendedor timestamp with time zone,
  acao_pendente text,
  resultado text
);

create table if not exists ml_dashboards_biowell.devolucoes_claims_sem_devolucao (
  account_id uuid not null,
  claim_id text not null,
  ultima_atualizacao timestamp with time zone,
  verificado_em timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.devolucoes_motivos (
  account_id uuid not null,
  reason_id text not null,
  familia text,
  nome text,
  detalhe text,
  erro_operacional boolean,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.devolucoes_status (
  account_id uuid not null,
  claim_id text not null,
  status text not null,
  etapa text,
  data_status timestamp with time zone not null,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.item_backfill_failures (
  account_id uuid not null,
  seller_id bigint not null,
  item_id text not null,
  order_item_title text,
  first_order_date timestamp with time zone,
  last_order_date timestamp with time zone,
  orders_count integer default 0 not null,
  units_sold integer default 0 not null,
  gross_amount numeric default 0 not null,
  error_code integer,
  error_message text,
  raw_error jsonb default '{}'::jsonb not null,
  attempted_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.item_daily_snapshots (
  id bigint default nextval('ml_dashboards_biowell.item_daily_snapshots_id_seq'::regclass) not null,
  account_id text not null,
  seller_id text not null,
  item_id text not null,
  snapshot_date date not null,
  status text,
  price numeric,
  base_price numeric,
  original_price numeric,
  available_quantity integer,
  sold_quantity integer,
  listing_type_id text,
  free_shipping boolean,
  logistic_type text,
  raw jsonb default '{}'::jsonb not null,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.item_visits_daily (
  account_id uuid not null,
  seller_id bigint not null,
  item_id text not null,
  visit_date date not null,
  visits integer default 0 not null,
  total_visits_window integer,
  visits_detail jsonb default '[]'::jsonb not null,
  raw jsonb default '{}'::jsonb not null,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.items_current (
  item_id text not null,
  account_id text not null,
  seller_id text not null,
  title text,
  category_id text,
  status text,
  price numeric,
  base_price numeric,
  original_price numeric,
  available_quantity integer,
  sold_quantity integer,
  listing_type_id text,
  condition text,
  catalog_listing boolean,
  free_shipping boolean,
  logistic_type text,
  permalink text,
  thumbnail text,
  last_updated timestamp with time zone,
  raw jsonb default '{}'::jsonb not null,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.items_historical_from_orders (
  account_id uuid not null,
  seller_id bigint not null,
  item_id text not null,
  title text,
  category_id text,
  listing_type_id text,
  first_order_date timestamp with time zone,
  last_order_date timestamp with time zone,
  orders_count integer default 0 not null,
  units_sold integer default 0 not null,
  gross_amount numeric default 0 not null,
  avg_unit_price numeric,
  source text default 'order_items'::text not null,
  enrichment_status text default 'api_nao_devolveu_item'::text not null,
  enrichment_error_code integer,
  enrichment_error_message text,
  first_seen_at timestamp with time zone default now() not null,
  updated_at timestamp with time zone default now() not null,
  raw jsonb default '{}'::jsonb not null
);

create table if not exists ml_dashboards_biowell.oauth_tokens (
  account_id uuid not null,
  ml_user_id bigint,
  access_token text,
  refresh_token text not null,
  token_type text,
  expires_in integer,
  scope text,
  expires_at timestamp with time zone,
  updated_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.order_daily_snapshots (
  account_id uuid not null,
  seller_id bigint not null,
  snapshot_date date not null,
  orders_count integer default 0 not null,
  paid_orders_count integer default 0 not null,
  canceled_orders_count integer default 0 not null,
  units_sold integer default 0 not null,
  gross_amount numeric default 0 not null,
  paid_amount numeric default 0 not null,
  avg_ticket numeric,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.order_items (
  line_id text not null,
  order_id text not null,
  account_id uuid not null,
  seller_id bigint not null,
  item_id text,
  variation_id text,
  title text,
  category_id text,
  seller_sku text,
  listing_type_id text,
  quantity integer,
  unit_price numeric,
  full_unit_price numeric,
  sale_fee numeric,
  currency_id text,
  raw jsonb default '{}'::jsonb not null,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.orders_current (
  order_id text not null,
  account_id uuid not null,
  seller_id bigint not null,
  buyer_id bigint,
  pack_id text,
  shipping_id text,
  status text,
  status_detail_code text,
  status_detail_description text,
  currency_id text,
  total_amount numeric,
  paid_amount numeric,
  fulfilled boolean,
  buying_mode text,
  tags text[],
  date_created timestamp with time zone,
  date_closed timestamp with time zone,
  expiration_date timestamp with time zone,
  date_last_updated timestamp with time zone,
  raw jsonb default '{}'::jsonb not null,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.seller_daily_snapshots (
  account_id uuid not null,
  seller_id bigint not null,
  snapshot_date date default CURRENT_DATE not null,
  reputation_level_id text,
  power_seller_status text,
  transactions_total integer,
  transactions_completed integer,
  transactions_canceled integer,
  rating_positive numeric,
  rating_neutral numeric,
  rating_negative numeric,
  sales_completed integer,
  claims_rate numeric,
  claims_value numeric,
  delayed_handling_time_rate numeric,
  delayed_handling_time_value numeric,
  cancellations_rate numeric,
  cancellations_value numeric,
  raw jsonb not null,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.sellers_current (
  seller_id bigint not null,
  account_id uuid,
  nickname text,
  email text,
  first_name text,
  last_name text,
  registration_date timestamp with time zone,
  country_id text,
  site_id text,
  user_type text,
  permalink text,
  points integer,
  tags text[],
  seller_experience text,
  status jsonb,
  reputation_level_id text,
  power_seller_status text,
  reputation_real_level text,
  protection_end_date timestamp with time zone,
  transactions_period text,
  transactions_total integer,
  transactions_completed integer,
  transactions_canceled integer,
  rating_positive numeric,
  rating_neutral numeric,
  rating_negative numeric,
  sales_completed integer,
  claims_rate numeric,
  claims_value numeric,
  delayed_handling_time_rate numeric,
  delayed_handling_time_value numeric,
  cancellations_rate numeric,
  cancellations_value numeric,
  raw jsonb not null,
  synced_at timestamp with time zone default now() not null
);

create table if not exists ml_dashboards_biowell.sync_runs (
  id uuid default gen_random_uuid() not null,
  account_id uuid,
  workflow_name text not null,
  status text not null,
  started_at timestamp with time zone default now() not null,
  finished_at timestamp with time zone,
  error_message text,
  raw_error jsonb
);

alter table ml_dashboards_biowell.accounts add constraint accounts_pkey PRIMARY KEY (id);

alter table ml_dashboards_biowell.devolucoes add constraint devolucoes_pkey PRIMARY KEY (account_id, claim_id);

alter table ml_dashboards_biowell.devolucoes_claims_sem_devolucao add constraint devolucoes_claims_sem_devolucao_pkey PRIMARY KEY (account_id, claim_id);

alter table ml_dashboards_biowell.devolucoes_motivos add constraint devolucoes_motivos_pkey PRIMARY KEY (account_id, reason_id);

alter table ml_dashboards_biowell.devolucoes_status add constraint devolucoes_status_pkey PRIMARY KEY (account_id, claim_id, status, data_status);

alter table ml_dashboards_biowell.item_backfill_failures add constraint item_backfill_failures_pkey PRIMARY KEY (account_id, item_id);

alter table ml_dashboards_biowell.item_daily_snapshots add constraint item_daily_snapshots_pkey PRIMARY KEY (id);

alter table ml_dashboards_biowell.item_visits_daily add constraint item_visits_daily_pkey PRIMARY KEY (account_id, item_id, visit_date);

alter table ml_dashboards_biowell.items_current add constraint items_current_pkey PRIMARY KEY (item_id);

alter table ml_dashboards_biowell.items_historical_from_orders add constraint items_historical_from_orders_pkey PRIMARY KEY (account_id, item_id);

alter table ml_dashboards_biowell.oauth_tokens add constraint oauth_tokens_pkey PRIMARY KEY (account_id);

alter table ml_dashboards_biowell.order_daily_snapshots add constraint order_daily_snapshots_pkey PRIMARY KEY (account_id, snapshot_date);

alter table ml_dashboards_biowell.order_items add constraint order_items_pkey PRIMARY KEY (line_id);

alter table ml_dashboards_biowell.orders_current add constraint orders_current_pkey PRIMARY KEY (order_id);

alter table ml_dashboards_biowell.seller_daily_snapshots add constraint seller_daily_snapshots_pkey PRIMARY KEY (account_id, snapshot_date);

alter table ml_dashboards_biowell.sellers_current add constraint sellers_current_pkey PRIMARY KEY (seller_id);

alter table ml_dashboards_biowell.sync_runs add constraint sync_runs_pkey PRIMARY KEY (id);

alter table ml_dashboards_biowell.accounts add constraint accounts_ml_user_id_key UNIQUE (ml_user_id);

alter table ml_dashboards_biowell.item_daily_snapshots add constraint item_daily_snapshots_item_id_snapshot_date_key UNIQUE (item_id, snapshot_date);

alter table ml_dashboards_biowell.devolucoes add constraint devolucoes_etapa_valida CHECK (((etapa_atual IS NULL) OR (etapa_atual = ANY (ARRAY['aberta'::text, 'enviada_pelo_comprador'::text, 'recebida'::text, 'revisada'::text, 'reembolsada'::text, 'encerrada_sem_devolucao'::text]))));

alter table ml_dashboards_biowell.devolucoes add constraint devolucoes_familia_valida CHECK (((familia_motivo IS NULL) OR (familia_motivo = ANY (ARRAY['PDD'::text, 'PNR'::text]))));

alter table ml_dashboards_biowell.devolucoes add constraint devolucoes_fila_valores_validos CHECK ((((quantidade IS NULL) OR (quantidade >= 0)) AND ((valor_venda IS NULL) OR (valor_venda >= (0)::numeric)) AND ((valor_reembolsado IS NULL) OR (valor_reembolsado >= (0)::numeric)) AND ((status_reclamacao IS NULL) OR (status_reclamacao = ANY (ARRAY['opened'::text, 'closed'::text])))));

alter table ml_dashboards_biowell.devolucoes add constraint devolucoes_valores_nao_negativos CHECK ((((unidades_devolvidas IS NULL) OR (unidades_devolvidas >= 0)) AND ((valor_devolvido IS NULL) OR (valor_devolvido >= (0)::numeric)) AND ((custo_frete_devolucao IS NULL) OR (custo_frete_devolucao >= (0)::numeric))));

alter table ml_dashboards_biowell.devolucoes_motivos add constraint devolucoes_motivos_familia_valida CHECK (((familia IS NULL) OR (familia = ANY (ARRAY['PDD'::text, 'PNR'::text]))));

alter table ml_dashboards_biowell.devolucoes_status add constraint devolucoes_status_etapa_valida CHECK (((etapa IS NULL) OR (etapa = ANY (ARRAY['aberta'::text, 'enviada_pelo_comprador'::text, 'recebida'::text, 'revisada'::text, 'reembolsada'::text, 'encerrada_sem_devolucao'::text]))));

alter table ml_dashboards_biowell.devolucoes add constraint devolucoes_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.devolucoes_claims_sem_devolucao add constraint devolucoes_claims_sem_devolucao_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.devolucoes_motivos add constraint devolucoes_motivos_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.devolucoes_status add constraint devolucoes_status_account_id_claim_id_fkey FOREIGN KEY (account_id, claim_id) REFERENCES ml_dashboards_biowell.devolucoes(account_id, claim_id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.item_backfill_failures add constraint item_backfill_failures_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.item_visits_daily add constraint item_visits_daily_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.items_historical_from_orders add constraint items_historical_from_orders_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.oauth_tokens add constraint oauth_tokens_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.order_daily_snapshots add constraint order_daily_snapshots_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.order_items add constraint order_items_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.order_items add constraint order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES ml_dashboards_biowell.orders_current(order_id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.orders_current add constraint orders_current_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.seller_daily_snapshots add constraint seller_daily_snapshots_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.sellers_current add constraint sellers_current_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

alter table ml_dashboards_biowell.sync_runs add constraint sync_runs_account_id_fkey FOREIGN KEY (account_id) REFERENCES ml_dashboards_biowell.accounts(id) ON DELETE CASCADE;

CREATE INDEX idx_devolucoes_abertura ON ml_dashboards_biowell.devolucoes USING btree (account_id, data_abertura DESC);

CREATE INDEX idx_devolucoes_status ON ml_dashboards_biowell.devolucoes USING btree (account_id, status_atual);

CREATE INDEX idx_devolucoes_status_claim ON ml_dashboards_biowell.devolucoes_status USING btree (account_id, claim_id, data_status);

CREATE INDEX idx_devolucoes_status_reclamacao ON ml_dashboards_biowell.devolucoes USING btree (account_id, status_reclamacao);

CREATE INDEX idx_devolucoes_venda ON ml_dashboards_biowell.devolucoes USING btree (account_id, data_venda);

CREATE INDEX idx_item_daily_snapshots_account_date ON ml_dashboards_biowell.item_daily_snapshots USING btree (account_id, snapshot_date DESC);

CREATE INDEX idx_item_daily_snapshots_item_date ON ml_dashboards_biowell.item_daily_snapshots USING btree (item_id, snapshot_date DESC);

CREATE INDEX idx_item_visits_daily_item_date ON ml_dashboards_biowell.item_visits_daily USING btree (item_id, visit_date DESC);

CREATE INDEX idx_item_visits_daily_seller_date ON ml_dashboards_biowell.item_visits_daily USING btree (seller_id, visit_date DESC);

CREATE INDEX idx_items_current_account_id ON ml_dashboards_biowell.items_current USING btree (account_id);

CREATE INDEX idx_items_current_seller_id ON ml_dashboards_biowell.items_current USING btree (seller_id);

CREATE INDEX idx_items_current_status ON ml_dashboards_biowell.items_current USING btree (status);

CREATE INDEX idx_items_historical_from_orders_account_date ON ml_dashboards_biowell.items_historical_from_orders USING btree (account_id, last_order_date DESC);

CREATE INDEX idx_items_historical_from_orders_seller_date ON ml_dashboards_biowell.items_historical_from_orders USING btree (seller_id, last_order_date DESC);

CREATE INDEX idx_ml_accounts_active ON ml_dashboards_biowell.accounts USING btree (active);

CREATE INDEX idx_ml_accounts_ml_user_id ON ml_dashboards_biowell.accounts USING btree (ml_user_id);

CREATE INDEX idx_ml_oauth_tokens_ml_user_id ON ml_dashboards_biowell.oauth_tokens USING btree (ml_user_id);

CREATE INDEX idx_ml_seller_daily_snapshots_date ON ml_dashboards_biowell.seller_daily_snapshots USING btree (snapshot_date);

CREATE INDEX idx_ml_seller_daily_snapshots_seller_id ON ml_dashboards_biowell.seller_daily_snapshots USING btree (seller_id);

CREATE INDEX idx_ml_sellers_current_account_id ON ml_dashboards_biowell.sellers_current USING btree (account_id);

CREATE INDEX idx_ml_sync_runs_account_id ON ml_dashboards_biowell.sync_runs USING btree (account_id);

CREATE INDEX idx_ml_sync_runs_started_at ON ml_dashboards_biowell.sync_runs USING btree (started_at);

CREATE INDEX idx_order_daily_snapshots_seller_date ON ml_dashboards_biowell.order_daily_snapshots USING btree (seller_id, snapshot_date DESC);

CREATE INDEX idx_order_items_account_item ON ml_dashboards_biowell.order_items USING btree (account_id, item_id);

CREATE INDEX idx_order_items_order_id ON ml_dashboards_biowell.order_items USING btree (order_id);

CREATE INDEX idx_order_items_seller_item ON ml_dashboards_biowell.order_items USING btree (seller_id, item_id);

CREATE INDEX idx_orders_current_account_date ON ml_dashboards_biowell.orders_current USING btree (account_id, date_created DESC);

CREATE INDEX idx_orders_current_seller_date ON ml_dashboards_biowell.orders_current USING btree (seller_id, date_created DESC);

CREATE INDEX idx_orders_current_shipping_id ON ml_dashboards_biowell.orders_current USING btree (shipping_id);

CREATE INDEX idx_orders_current_status ON ml_dashboards_biowell.orders_current USING btree (status);

create or replace view ml_dashboards_biowell.dashboard_daily_order_impact as
 SELECT o.account_id,
    o.seller_id,
    date((o.date_created AT TIME ZONE 'America/Sao_Paulo'::text)) AS performance_date,
    count(*)::integer AS orders_count,
    count(*) FILTER (WHERE o.status = 'paid'::text)::integer AS paid_orders_count,
    count(*) FILTER (WHERE o.status = ANY (ARRAY['cancelled'::text, 'canceled'::text]))::integer AS canceled_orders_count,
    COALESCE(sum(o.total_amount), 0::numeric) AS gross_amount,
    COALESCE(sum(
        CASE
            WHEN o.status = 'paid'::text THEN o.paid_amount
            ELSE 0::numeric
        END), 0::numeric) AS paid_amount,
    COALESCE(sum(
        CASE
            WHEN o.status = ANY (ARRAY['cancelled'::text, 'canceled'::text]) THEN o.total_amount
            ELSE 0::numeric
        END), 0::numeric) AS canceled_amount,
    round(100::numeric * count(*) FILTER (WHERE o.status = ANY (ARRAY['cancelled'::text, 'canceled'::text]))::numeric / NULLIF(count(*)::numeric, 0::numeric), 2) AS canceled_orders_percent,
    round(100::numeric * COALESCE(sum(
        CASE
            WHEN o.status = ANY (ARRAY['cancelled'::text, 'canceled'::text]) THEN o.total_amount
            ELSE 0::numeric
        END), 0::numeric) / NULLIF(COALESCE(sum(o.total_amount), 0::numeric), 0::numeric), 2) AS canceled_amount_percent,
    round(COALESCE(sum(
        CASE
            WHEN o.status = ANY (ARRAY['cancelled'::text, 'canceled'::text]) THEN o.total_amount
            ELSE 0::numeric
        END), 0::numeric) / NULLIF(count(*) FILTER (WHERE o.status = ANY (ARRAY['cancelled'::text, 'canceled'::text]))::numeric, 0::numeric), 2) AS average_canceled_ticket,
    max(o.synced_at) AS synced_at
   FROM ml_dashboards_biowell.orders_current o
  WHERE o.date_created IS NOT NULL
  GROUP BY o.account_id, o.seller_id, (date((o.date_created AT TIME ZONE 'America/Sao_Paulo'::text)));

create or replace view ml_dashboards_biowell.dashboard_item_catalog as
 WITH current_items AS (
         SELECT a.id AS account_id,
            i.seller_id::bigint AS seller_id,
            i.item_id,
            i.title,
            i.category_id,
            i.status,
            i.price,
            i.base_price,
            i.original_price,
            i.available_quantity,
            i.sold_quantity,
            i.listing_type_id,
            i.condition,
            i.catalog_listing,
            i.free_shipping,
            i.logistic_type,
            i.permalink,
            i.thumbnail,
            i.last_updated,
            i.synced_at,
            'items_current'::text AS catalog_source
           FROM ml_dashboards_biowell.items_current i
             JOIN ml_dashboards_biowell.accounts a ON a.id::text = i.account_id
        ), sold_items AS (
         SELECT oi.account_id,
            oi.seller_id,
            oi.item_id,
            (array_agg(oi.title ORDER BY oi.synced_at DESC NULLS LAST))[1] AS title,
            (array_agg(oi.category_id ORDER BY oi.synced_at DESC NULLS LAST))[1] AS category_id,
            NULL::text AS status,
            round(avg(oi.unit_price), 2) AS price,
            NULL::numeric AS base_price,
            NULL::numeric AS original_price,
            NULL::integer AS available_quantity,
            sum(COALESCE(oi.quantity, 0))::integer AS sold_quantity,
            (array_agg(oi.listing_type_id ORDER BY oi.synced_at DESC NULLS LAST))[1] AS listing_type_id,
            NULL::text AS condition,
            NULL::boolean AS catalog_listing,
            NULL::boolean AS free_shipping,
            NULL::text AS logistic_type,
            NULL::text AS permalink,
            NULL::text AS thumbnail,
            NULL::timestamp with time zone AS last_updated,
            max(oi.synced_at) AS synced_at,
            'order_items_fallback'::text AS catalog_source
           FROM ml_dashboards_biowell.order_items oi
          WHERE oi.item_id IS NOT NULL
          GROUP BY oi.account_id, oi.seller_id, oi.item_id
        ), sold_items_missing_current AS (
         SELECT s.account_id,
            s.seller_id,
            s.item_id,
            s.title,
            s.category_id,
            s.status,
            s.price,
            s.base_price,
            s.original_price,
            s.available_quantity,
            s.sold_quantity,
            s.listing_type_id,
            s.condition,
            s.catalog_listing,
            s.free_shipping,
            s.logistic_type,
            s.permalink,
            s.thumbnail,
            s.last_updated,
            s.synced_at,
            s.catalog_source
           FROM sold_items s
             LEFT JOIN current_items c ON c.account_id = s.account_id AND c.item_id = s.item_id
          WHERE c.item_id IS NULL
        )
 SELECT current_items.account_id,
    current_items.seller_id,
    current_items.item_id,
    current_items.title,
    current_items.category_id,
    current_items.status,
    current_items.price,
    current_items.base_price,
    current_items.original_price,
    current_items.available_quantity,
    current_items.sold_quantity,
    current_items.listing_type_id,
    current_items.condition,
    current_items.catalog_listing,
    current_items.free_shipping,
    current_items.logistic_type,
    current_items.permalink,
    current_items.thumbnail,
    current_items.last_updated,
    current_items.synced_at,
    current_items.catalog_source
   FROM current_items
UNION ALL
 SELECT sold_items_missing_current.account_id,
    sold_items_missing_current.seller_id,
    sold_items_missing_current.item_id,
    sold_items_missing_current.title,
    sold_items_missing_current.category_id,
    sold_items_missing_current.status,
    sold_items_missing_current.price,
    sold_items_missing_current.base_price,
    sold_items_missing_current.original_price,
    sold_items_missing_current.available_quantity,
    sold_items_missing_current.sold_quantity,
    sold_items_missing_current.listing_type_id,
    sold_items_missing_current.condition,
    sold_items_missing_current.catalog_listing,
    sold_items_missing_current.free_shipping,
    sold_items_missing_current.logistic_type,
    sold_items_missing_current.permalink,
    sold_items_missing_current.thumbnail,
    sold_items_missing_current.last_updated,
    sold_items_missing_current.synced_at,
    sold_items_missing_current.catalog_source
   FROM sold_items_missing_current;

create or replace view ml_dashboards_biowell.devolucoes_base_vendas_diaria with (security_invoker=true) as
 SELECT o.account_id,
    date((o.date_created AT TIME ZONE 'America/Sao_Paulo'::text)) AS data_venda,
    count(DISTINCT o.order_id)::integer AS pedidos_pagos,
    COALESCE(sum(oi.quantity), 0::bigint)::integer AS unidades_pagas,
    COALESCE(sum(COALESCE(oi.quantity, 0)::numeric * COALESCE(oi.unit_price, 0::numeric)), 0::numeric) AS faturamento_pago
   FROM ml_dashboards_biowell.orders_current o
     JOIN ml_dashboards_biowell.order_items oi ON oi.order_id = o.order_id
  WHERE o.status = 'paid'::text AND o.date_created IS NOT NULL
  GROUP BY o.account_id, (date((o.date_created AT TIME ZONE 'America/Sao_Paulo'::text)));

create or replace view ml_dashboards_biowell.item_backfill_queue as
 SELECT oi.account_id,
    oi.seller_id,
    oi.item_id,
    (array_agg(oi.title ORDER BY oi.synced_at DESC NULLS LAST))[1] AS order_item_title,
    min(o.date_created) AS first_order_date,
    max(o.date_created) AS last_order_date,
    count(DISTINCT oi.order_id)::integer AS orders_count,
    sum(COALESCE(oi.quantity, 0))::integer AS units_sold,
    sum(COALESCE(oi.quantity, 0)::numeric * COALESCE(oi.unit_price, 0::numeric)) AS gross_amount
   FROM ml_dashboards_biowell.order_items oi
     JOIN ml_dashboards_biowell.orders_current o ON o.order_id = oi.order_id
     LEFT JOIN ml_dashboards_biowell.items_current i ON i.account_id = oi.account_id::text AND i.item_id = oi.item_id
  WHERE oi.item_id IS NOT NULL AND i.item_id IS NULL
  GROUP BY oi.account_id, oi.seller_id, oi.item_id;

create or replace view ml_dashboards_biowell.item_performance_daily as
 WITH sales_by_item_day AS (
         SELECT oi.account_id,
            oi.seller_id,
            oi.item_id,
            date((o.date_created AT TIME ZONE 'America/Sao_Paulo'::text)) AS performance_date,
            sum(COALESCE(oi.quantity, 0))::integer AS units_sold,
            sum(COALESCE(oi.quantity, 0)::numeric * COALESCE(oi.unit_price, 0::numeric)) AS gross_amount,
            count(DISTINCT oi.order_id)::integer AS orders_count
           FROM ml_dashboards_biowell.order_items oi
             JOIN ml_dashboards_biowell.orders_current o ON o.order_id = oi.order_id
          WHERE oi.item_id IS NOT NULL
          GROUP BY oi.account_id, oi.seller_id, oi.item_id, (date((o.date_created AT TIME ZONE 'America/Sao_Paulo'::text)))
        )
 SELECT v.account_id,
    v.seller_id,
    v.item_id,
    i.title,
    i.status,
    i.price,
    v.visit_date AS performance_date,
    v.visits,
    COALESCE(s.units_sold, 0) AS units_sold,
    COALESCE(s.orders_count, 0) AS orders_count,
    COALESCE(s.gross_amount, 0::numeric) AS gross_amount,
        CASE
            WHEN v.visits > 0 THEN round(COALESCE(s.units_sold, 0)::numeric / v.visits::numeric * 100::numeric, 4)
            ELSE NULL::numeric
        END AS conversion_rate_percent,
    v.synced_at AS visits_synced_at
   FROM ml_dashboards_biowell.item_visits_daily v
     LEFT JOIN sales_by_item_day s ON s.account_id = v.account_id AND s.item_id = v.item_id AND s.performance_date = v.visit_date
     LEFT JOIN ml_dashboards_biowell.items_current i ON i.account_id = v.account_id::text AND i.item_id = v.item_id;

create or replace view ml_dashboards_biowell.items_catalog_all as
 SELECT a.id AS account_id,
    i.seller_id::bigint AS seller_id,
    i.item_id,
    i.title,
    i.category_id,
    i.status,
    i.price,
    i.base_price,
    i.original_price,
    i.available_quantity,
    i.sold_quantity,
    i.listing_type_id,
    i.condition,
    i.catalog_listing,
    i.free_shipping,
    i.logistic_type,
    i.permalink,
    i.thumbnail,
    i.last_updated,
    NULL::timestamp with time zone AS first_order_date,
    NULL::timestamp with time zone AS last_order_date,
    NULL::integer AS orders_count,
    NULL::numeric AS gross_amount,
    'items_current'::text AS source,
    'api_enriquecido'::text AS enrichment_status,
    i.synced_at
   FROM ml_dashboards_biowell.items_current i
     JOIN ml_dashboards_biowell.accounts a ON a.id::text = i.account_id
UNION ALL
 SELECT h.account_id,
    h.seller_id,
    h.item_id,
    h.title,
    h.category_id,
    'historical'::text AS status,
    h.avg_unit_price AS price,
    NULL::numeric AS base_price,
    NULL::numeric AS original_price,
    NULL::integer AS available_quantity,
    h.units_sold AS sold_quantity,
    h.listing_type_id,
    NULL::text AS condition,
    NULL::boolean AS catalog_listing,
    NULL::boolean AS free_shipping,
    NULL::text AS logistic_type,
    NULL::text AS permalink,
    NULL::text AS thumbnail,
    NULL::timestamp with time zone AS last_updated,
    h.first_order_date,
    h.last_order_date,
    h.orders_count,
    h.gross_amount,
    h.source,
    h.enrichment_status,
    h.updated_at AS synced_at
   FROM ml_dashboards_biowell.items_historical_from_orders h
  WHERE NOT (EXISTS ( SELECT 1
           FROM ml_dashboards_biowell.items_current i
          WHERE i.account_id = h.account_id::text AND i.item_id = h.item_id));

create or replace view ml_dashboards_biowell.dashboard_daily_item_performance as
 WITH sales_by_item_day AS (
         SELECT oi.account_id,
            oi.seller_id,
            oi.item_id,
            date((o.date_created AT TIME ZONE 'America/Sao_Paulo'::text)) AS performance_date,
            count(DISTINCT oi.order_id)::integer AS orders_count,
            sum(COALESCE(oi.quantity, 0))::integer AS units_sold,
            sum(COALESCE(oi.quantity, 0)::numeric * COALESCE(oi.unit_price, 0::numeric)) AS gross_amount,
            sum(
                CASE
                    WHEN o.status = 'paid'::text THEN COALESCE(oi.quantity, 0)::numeric * COALESCE(oi.unit_price, 0::numeric)
                    ELSE 0::numeric
                END) AS paid_gross_amount
           FROM ml_dashboards_biowell.order_items oi
             JOIN ml_dashboards_biowell.orders_current o ON o.order_id = oi.order_id
          WHERE oi.item_id IS NOT NULL
          GROUP BY oi.account_id, oi.seller_id, oi.item_id, (date((o.date_created AT TIME ZONE 'America/Sao_Paulo'::text)))
        ), visits_by_item_day AS (
         SELECT v.account_id,
            v.seller_id,
            v.item_id,
            v.visit_date AS performance_date,
            sum(v.visits)::integer AS visits,
            max(v.synced_at) AS visits_synced_at
           FROM ml_dashboards_biowell.item_visits_daily v
          GROUP BY v.account_id, v.seller_id, v.item_id, v.visit_date
        ), combined AS (
         SELECT COALESCE(v.account_id, s.account_id) AS account_id,
            COALESCE(v.seller_id, s.seller_id) AS seller_id,
            COALESCE(v.item_id, s.item_id) AS item_id,
            COALESCE(v.performance_date, s.performance_date) AS performance_date,
            COALESCE(v.visits, 0) AS visits,
            COALESCE(s.units_sold, 0) AS units_sold,
            COALESCE(s.orders_count, 0) AS orders_count,
            COALESCE(s.gross_amount, 0::numeric) AS gross_amount,
            COALESCE(s.paid_gross_amount, 0::numeric) AS paid_gross_amount,
            v.visits_synced_at
           FROM visits_by_item_day v
             FULL JOIN sales_by_item_day s ON s.account_id = v.account_id AND s.item_id = v.item_id AND s.performance_date = v.performance_date
        )
 SELECT c.account_id,
    a.account_name,
    c.seller_id,
    c.item_id,
    ic.title,
    ic.category_id,
    ic.status,
    ic.price,
    ic.available_quantity,
    ic.sold_quantity AS current_sold_quantity,
    ic.listing_type_id,
    ic.free_shipping,
    ic.logistic_type,
    ic.permalink,
    ic.thumbnail,
    ic.catalog_source,
    c.performance_date,
    c.visits,
    c.units_sold,
    c.orders_count,
    c.gross_amount,
    c.paid_gross_amount,
        CASE
            WHEN c.visits > 0 THEN round(c.units_sold::numeric / c.visits::numeric * 100::numeric, 4)
            ELSE NULL::numeric
        END AS conversion_rate_percent,
    c.visits_synced_at
   FROM combined c
     JOIN ml_dashboards_biowell.accounts a ON a.id = c.account_id
     LEFT JOIN ml_dashboards_biowell.dashboard_item_catalog ic ON ic.account_id = c.account_id AND ic.item_id = c.item_id;

create or replace view ml_dashboards_biowell.dashboard_daily_account_summary as
 SELECT dashboard_daily_item_performance.account_id,
    dashboard_daily_item_performance.account_name,
    dashboard_daily_item_performance.performance_date,
    count(DISTINCT dashboard_daily_item_performance.item_id) AS items_count,
    count(DISTINCT dashboard_daily_item_performance.item_id) FILTER (WHERE dashboard_daily_item_performance.catalog_source = 'order_items_fallback'::text) AS fallback_items_count,
    sum(dashboard_daily_item_performance.visits) AS visits,
    sum(dashboard_daily_item_performance.units_sold) AS units_sold,
    sum(dashboard_daily_item_performance.orders_count) AS orders_count,
    sum(dashboard_daily_item_performance.gross_amount) AS gross_amount,
    sum(dashboard_daily_item_performance.paid_gross_amount) AS paid_gross_amount,
    round(sum(dashboard_daily_item_performance.gross_amount) / NULLIF(sum(dashboard_daily_item_performance.orders_count), 0)::numeric, 2) AS avg_ticket,
    round(sum(dashboard_daily_item_performance.units_sold)::numeric / NULLIF(sum(dashboard_daily_item_performance.visits), 0)::numeric * 100::numeric, 4) AS conversion_rate_percent
   FROM ml_dashboards_biowell.dashboard_daily_item_performance
  GROUP BY dashboard_daily_item_performance.account_id, dashboard_daily_item_performance.account_name, dashboard_daily_item_performance.performance_date;

alter table ml_dashboards_biowell.accounts enable row level security;

alter table ml_dashboards_biowell.devolucoes enable row level security;

alter table ml_dashboards_biowell.devolucoes_claims_sem_devolucao enable row level security;

alter table ml_dashboards_biowell.devolucoes_motivos enable row level security;

alter table ml_dashboards_biowell.devolucoes_status enable row level security;

alter table ml_dashboards_biowell.item_daily_snapshots enable row level security;

alter table ml_dashboards_biowell.item_visits_daily enable row level security;

alter table ml_dashboards_biowell.items_current enable row level security;

alter table ml_dashboards_biowell.oauth_tokens enable row level security;

alter table ml_dashboards_biowell.order_daily_snapshots enable row level security;

alter table ml_dashboards_biowell.order_items enable row level security;

alter table ml_dashboards_biowell.orders_current enable row level security;

alter table ml_dashboards_biowell.seller_daily_snapshots enable row level security;

alter table ml_dashboards_biowell.sellers_current enable row level security;

alter table ml_dashboards_biowell.sync_runs enable row level security;


-- Permissões: igual ao ml_dashboards, só a service_role (usada pelo n8n e pelo
-- painel no servidor) acessa. anon e authenticated ficam sem acesso.
revoke all on schema ml_dashboards_biowell from public, anon, authenticated;
grant usage on schema ml_dashboards_biowell to service_role;
grant select, insert, update, delete on all tables in schema ml_dashboards_biowell to service_role;
grant usage, select on all sequences in schema ml_dashboards_biowell to service_role;
grant execute on all functions in schema ml_dashboards_biowell to service_role;

commit;

-- Depois de rodar: inclua ml_dashboards_biowell nos schemas expostos da Data API
-- (Settings > API > Exposed schemas; no Supabase self-hosted, PGRST_DB_SCHEMAS)
-- e recarregue o cache do PostgREST:
notify pgrst, 'reload schema';
