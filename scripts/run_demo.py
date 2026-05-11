from __future__ import annotations

import json
import sqlite3
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "sql"
DB_PATH = ROOT / "warehouse_demo.db"


def execute_file(connection: sqlite3.Connection, filename: str) -> None:
    script = (SQL_DIR / filename).read_text(encoding="utf-8")
    connection.executescript(script)


def rows(connection: sqlite3.Connection, query: str) -> list[dict]:
    cursor = connection.execute(query)
    columns = [description[0] for description in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]


def build_demo() -> dict:
    if DB_PATH.exists():
        DB_PATH.unlink()

    connection = sqlite3.connect(DB_PATH)
    try:
        execute_file(connection, "schema.sql")
        execute_file(connection, "seed.sql")
        execute_file(connection, "views.sql")

        output = {
            "site_overview": rows(
                connection,
                "SELECT * FROM vw_site_overview ORDER BY average_crawl_anomaly_score DESC",
            ),
            "freshness_gaps": rows(
                connection,
                "SELECT * FROM vw_freshness_gaps ORDER BY lag_hours DESC",
            ),
            "page_group_rollup": rows(
                connection,
                "SELECT * FROM vw_page_group_rollup ORDER BY impressions DESC",
            ),
            "mismatches": rows(
                connection,
                "SELECT * FROM vw_crawl_index_mismatches ORDER BY page_group_key, url_path",
            ),
            "anomaly_flags": rows(
                connection,
                """
                SELECT pg.page_group_key, af.anomaly_type, af.severity, af.summary
                FROM anomaly_flags af
                JOIN page_groups pg ON pg.page_group_id = af.page_group_id
                ORDER BY af.severity, pg.page_group_key
                """,
            ),
        }

        print(json.dumps(output, indent=2))
        return output
    finally:
        connection.close()


if __name__ == "__main__":
    build_demo()
