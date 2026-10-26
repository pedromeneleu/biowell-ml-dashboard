# Schema da BIOWELL no Supabase

A BIOWELL usa o mesmo servidor Supabase da PCXpress, mas um schema próprio,
`ml_dashboards_biowell`, com as mesmas tabelas, views, funções e regras do
`ml_dashboards`. Os dados das duas contas não se misturam.

## Como criar

1. No SQL Editor do Supabase, rode `00_exportar_estrutura_ml_dashboards.sql`. Ele só lê a
   estrutura do `ml_dashboards` (sem dados) e devolve tudo numa célula (`ddl`).
2. Salve o resultado (texto da célula, JSON copiado ou CSV baixado) num arquivo e gere o script:

   ```bash
   python3 supabase/biowell/gerar_schema_biowell.py exportacao.sql supabase/biowell/01_criar_schema_ml_dashboards_biowell.sql
   ```

3. Rode `01_criar_schema_ml_dashboards_biowell.sql` uma vez no SQL Editor. Ele roda numa
   transação: se algo falhar (por exemplo, se o schema já tiver sido criado), nada é alterado.
4. Inclua `ml_dashboards_biowell` nos schemas expostos da Data API
   (Settings > API > Exposed schemas; no Supabase self-hosted, `PGRST_DB_SCHEMAS`).

Acesso: igual ao `ml_dashboards`, só a `service_role`. `anon` e `authenticated` ficam sem acesso.

## Migrações futuras

Toda migração nova do painel PCXpress (`supabase/migrations/`) precisa rodar também aqui,
trocando `ml_dashboards.` por `ml_dashboards_biowell.`.
