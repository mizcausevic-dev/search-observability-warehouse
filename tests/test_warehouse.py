from __future__ import annotations

import sqlite3
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "sql"


def execute_file(connection: sqlite3.Connection, filename: str) -> None:
    connection.executescript((SQL_DIR / filename).read_text(encoding="utf-8"))


class WarehouseTests(unittest.TestCase):
    def setUp(self) -> None:
        self.connection = sqlite3.connect(":memory:")
        execute_file(self.connection, "schema.sql")
        execute_file(self.connection, "seed.sql")
        execute_file(self.connection, "views.sql")

    def tearDown(self) -> None:
        self.connection.close()

    def scalar(self, query: str):
        return self.connection.execute(query).fetchone()[0]

    def test_site_overview_contains_two_sites(self) -> None:
        self.assertEqual(self.scalar("SELECT COUNT(*) FROM vw_site_overview"), 2)

    def test_freshness_breach_exists(self) -> None:
        self.assertEqual(
            self.scalar("SELECT COUNT(*) FROM vw_freshness_gaps WHERE freshness_status = 'breach'"),
            1,
        )

    def test_page_group_rollup_tracks_pricing(self) -> None:
        clicks = self.scalar(
            "SELECT clicks FROM vw_page_group_rollup WHERE page_group_key = 'pricing'"
        )
        self.assertEqual(clicks, 3978)

    def test_mismatch_view_surfaces_problem_urls(self) -> None:
        self.assertGreaterEqual(self.scalar("SELECT COUNT(*) FROM vw_crawl_index_mismatches"), 3)


if __name__ == "__main__":
    unittest.main()
