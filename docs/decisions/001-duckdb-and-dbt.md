# Use DuckDB and dbt Core for the sample pipeline

## Context

The investigator needs a real, reproducible pipeline whose transformations, tests,
and dependencies can later provide evidence about failures. It must run locally
without paid services or accounts.

## Decision

Use DuckDB for local SQL execution and dbt Core with the `dbt-duckdb` adapter for
seeds, transformations, tests, and execution artifacts. Keep these tools in the
`pipeline` dependency group, separate from the investigator's runtime dependencies.

Small, fixed synthetic CSVs make expected results reviewable. dbt seeds load them
without a custom ingestion service. Explicit column types preserve identifiers
and make the starting schema reproducible.

## Alternatives and trade-offs

Python and SQL alone would require fewer dependencies, but we would need to build
test execution and dependency metadata ourselves. dbt brings those capabilities
along with a larger development dependency tree.

PostgreSQL would also support SQL transformations but requires a separate server.
DuckDB keeps this example in a single local file. It does not demonstrate a
distributed warehouse or concurrent production ingestion; those are outside the
scope of this sample. Seeds model small local inputs, not a production ingestion
strategy.
