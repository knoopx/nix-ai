# DuckDB Best Practices

This document outlines best practices for using DuckDB. It is distilled from internal documentation and the latest recommendations for DuckDB usage.

## General DuckDB Usage

- **Use the `JSON` type** for columns that store arbitrary or nested data. In Python, serialize with `json.dumps()` and deserialize with `json.loads()`.
- **Leverage DuckDB's JSON functions** for querying and manipulating JSON data. See the [DuckDB JSON documentation](https://duckdb.org/docs/extensions/json.html).

## Reference

- [DuckDB Documentation](https://duckdb.org/docs/)
- [DuckDB JSON Extension](https://duckdb.org/docs/extensions/json.html)
- [DuckDB SQL Statements](https://duckdb.org/docs/stable/sql/statements/overview)
- [DuckDB SQL Functions](https://duckdb.org/docs/stable/sql/functions/overview)
