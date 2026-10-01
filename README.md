# what-broke-this-time

AI-powered incident investigator for data pipelines — because scrolling through 400 lines of logs is not a strategy.

Pipeline failures leave clues across logs, tests, schemas, and dependencies.
The goal is to bring those clues together into a structured diagnosis, with supporting evidence and explicit uncertainty.

I'm building this to connect my Data Engineering background with my work in AI Engineering: reproducible failures, useful context, and diagnoses we can test against known root causes.

## Current status

**Built:** a Python project foundation and a local sample pipeline using synthetic CSVs, DuckDB, and dbt Core. The pipeline has data quality checks and a regression test for its expected output.

**Next, after review:** deterministic incident simulation. Incident investigation, AI, retrieval, evaluation, an API, and a frontend are later milestones.

The default workflow will stay free and local-first. No paid APIs or cloud services are required.

## Local development

Install [uv](https://docs.astral.sh/uv/getting-started/installation/), then run these commands from the repository root:

```sh
uv sync --locked
uv run --locked python -c "import app"
```

The project currently targets Python 3.13. uv uses `.python-version` to select it and can download Python if needed. `uv sync --locked` creates `.venv` and installs the package and development tools at the versions in `uv.lock`.
Initial setup needs internet access for downloads; the checks run locally.
The import command exits silently on success. The investigator backend is still a package skeleton.

Run the checks:

```sh
uv run --locked pytest
uv run --locked ruff check .
uv run --locked ruff format --check .
```

Backend code lives in `src/backend/app/`; tests live in `tests/`. The installation
test imports the package from outside the repository with Python's isolated mode,
so it checks the installed package without relying on the working directory or `PYTHONPATH`.

## Sample pipeline

From the repository root:

```sh
uv sync --locked --group pipeline
uv run --locked --group pipeline dbt build --project-dir pipeline --profiles-dir pipeline
```

The `pipeline` dependency group installs dbt Core and its DuckDB adapter separately
from the backend's dependencies. The profile is local and contains no credentials;
anonymous dbt usage reporting is disabled.

```text
raw_customers.csv -> stg_customers --+
                                   +-> customer_orders
raw_orders.csv ----> stg_orders ----+
```

dbt seeds load four synthetic customers and six orders. Staging views normalize
country codes and order status and convert integer euro cents to `DECIMAL(12, 2)`.
The `customer_orders` table contains one row per completed order, joined to its
customer. Pending and cancelled orders are excluded; customers without completed
orders do not appear. The sample produces **4 rows totaling EUR 200.50**.

The database is written to `pipeline/customer_orders.duckdb`, with all relations
in the `main` schema. Override `WBTT_DUCKDB_PATH` with an absolute file path to use
a separate database. Repeating the build reloads the seeds and rebuilds the models
without accumulating rows. This sample database is disposable and should not hold
unrelated data. After editing seed column types, use `dbt build --full-refresh`
with the same project and profile flags.

Tests cover non-null and unique keys, customer relationships, allowed statuses,
non-negative amounts, and the exact expected completed orders. The fixed-data
regression test must be updated if the sample dataset intentionally changes.

Inspect the output:

```sh
uv run --locked --group pipeline dbt show --project-dir pipeline --profiles-dir pipeline --inline "select * from {{ ref('customer_orders') }} order by order_id"
```

dbt writes `manifest.json` and `run_results.json` under `pipeline/target/` and logs
under `pipeline/logs/`. These generated files and the database are ignored by Git.
They provide real execution evidence, but no incident collector exists yet.

See [why DuckDB and dbt Core](docs/decisions/001-duckdb-and-dbt.md) for the decision
and its limitations.

## License

[MIT](LICENSE) — Copyright (c) 2026 Anna Garcia.
