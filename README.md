# what-broke-this-time

AI-powered incident investigator for data pipelines — because scrolling through 400 lines of logs is not a strategy.

Pipeline failures leave clues across logs, tests, schemas, and dependencies.
The goal is to bring those clues together into a structured diagnosis, with supporting evidence and explicit uncertainty.

I'm building this to connect my Data Engineering background with my work in AI Engineering: reproducible failures, useful context, and diagnoses we can test against known root causes.

## Current status

**Built:** an installable Python package, a dependency lockfile, an installation smoke test, and lint/format checks. There is no incident investigation logic yet.

**Next, after review:** a healthy local pipeline using synthetic data. Incident simulation, AI investigation, retrieval, evaluation, an API, and a frontend are later milestones.

The default workflow will stay free and local-first. No paid APIs or cloud services are required.

## Local development

Install [uv](https://docs.astral.sh/uv/getting-started/installation/), then run these commands from the repository root:

```sh
uv sync --locked
uv run --locked python -c "import app"
```

The project currently targets Python 3.13. uv uses `.python-version` to select it and can download Python if needed. `uv sync --locked` creates `.venv` and installs the package and development tools at the versions in `uv.lock`.
Initial setup needs internet access for downloads; the checks run locally.
The import command exits silently on success. There is no application to start yet.

Run the checks:

```sh
uv run --locked pytest
uv run --locked ruff check .
uv run --locked ruff format --check .
```

Backend code lives in `src/backend/app/`; tests live in `tests/`. The installation
test imports the package from outside the repository with Python's isolated mode,
so it checks the installed package without relying on the working directory or `PYTHONPATH`.

## License

[MIT](LICENSE) — Copyright (c) 2026 Anna Garcia.
