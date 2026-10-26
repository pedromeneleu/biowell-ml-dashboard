"""Gera o script do schema ml_dashboards_biowell a partir da exportação do ml_dashboards.

Uso: python3 -I gerar_schema_biowell.py <exportacao.sql> <saida.sql>
A exportação é o conteúdo da coluna "ddl" de exportar-estrutura-ml_dashboards.sql.
"""
import csv
import io
import json
import re
import sys

ORIGEM = "ml_dashboards"
DESTINO = "ml_dashboards_biowell"

exportacao = open(sys.argv[1], encoding="utf-8-sig").read()
# Aceita também o JSON copiado do resultado e o CSV baixado do SQL Editor.
if exportacao.lstrip().startswith("["):
    exportacao = json.loads(exportacao)[0]["ddl"]
elif exportacao.lstrip().startswith("objetos,"):
    linhas = list(csv.DictReader(io.StringIO(exportacao)))
    exportacao = linhas[0]["ddl"]
if f"{ORIGEM}." not in exportacao:
    raise SystemExit("A exportação não contém objetos de ml_dashboards.")

# Só troca o schema quando ele é usado como qualificador (ml_dashboards.<objeto>
# ou "ml_dashboards".<objeto>). Nomes como ml_dashboards_mvp1_seller_sync,
# gravados em sync_runs.workflow_name, ficam iguais.
corpo = re.sub(r'(?<![\w"])"?' + ORIGEM + r'"?\.', DESTINO + ".", exportacao)
corpo = re.sub(r"^-- Estrutura de ml_dashboards exportada em .*\n", "", corpo)

cabecalho = f"""-- Schema próprio da BIOWELL: mesmas tabelas, views, funções e regras do
-- ml_dashboards da PCXpress, sem nenhum dado. Rode uma vez no SQL Editor do Supabase.
-- Gerado a partir da exportação da estrutura do ml_dashboards.
begin;

create schema if not exists {DESTINO};
"""

rodape = f"""

-- Permissões: igual ao ml_dashboards, só a service_role (usada pelo n8n e pelo
-- painel no servidor) acessa. anon e authenticated ficam sem acesso.
revoke all on schema {DESTINO} from public, anon, authenticated;
grant usage on schema {DESTINO} to service_role;
grant select, insert, update, delete on all tables in schema {DESTINO} to service_role;
grant usage, select on all sequences in schema {DESTINO} to service_role;
grant execute on all functions in schema {DESTINO} to service_role;

commit;

-- Depois de rodar: inclua {DESTINO} nos schemas expostos da Data API
-- (Settings > API > Exposed schemas; no Supabase self-hosted, PGRST_DB_SCHEMAS)
-- e recarregue o cache do PostgREST:
notify pgrst, 'reload schema';
"""

open(sys.argv[2], "w", encoding="utf-8").write(cabecalho + "\n" + corpo.strip() + "\n" + rodape)
print(f"ok: {sys.argv[2]}")
