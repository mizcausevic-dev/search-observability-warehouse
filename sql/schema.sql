PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS vw_freshness_gaps;
DROP VIEW IF EXISTS vw_crawl_index_mismatches;
DROP VIEW IF EXISTS vw_page_group_rollup;
DROP VIEW IF EXISTS vw_site_overview;

DROP TABLE IF EXISTS anomaly_flags;
DROP TABLE IF EXISTS url_signals;
DROP TABLE IF EXISTS index_coverage_daily;
DROP TABLE IF EXISTS search_console_daily;
DROP TABLE IF EXISTS crawl_daily;
DROP TABLE IF EXISTS source_freshness;
DROP TABLE IF EXISTS page_groups;
DROP TABLE IF EXISTS sites;

CREATE TABLE sites (
  site_id INTEGER PRIMARY KEY,
  site_code TEXT NOT NULL UNIQUE,
  domain TEXT NOT NULL,
  market TEXT NOT NULL
);

CREATE TABLE page_groups (
  page_group_id INTEGER PRIMARY KEY,
  site_id INTEGER NOT NULL REFERENCES sites(site_id),
  page_group_key TEXT NOT NULL UNIQUE,
  template_name TEXT NOT NULL,
  business_owner TEXT NOT NULL
);

CREATE TABLE source_freshness (
  freshness_id INTEGER PRIMARY KEY,
  site_id INTEGER NOT NULL REFERENCES sites(site_id),
  source_name TEXT NOT NULL,
  last_loaded_at TEXT NOT NULL,
  freshness_sla_hours INTEGER NOT NULL,
  row_count INTEGER NOT NULL
);

CREATE TABLE crawl_daily (
  crawl_id INTEGER PRIMARY KEY,
  site_id INTEGER NOT NULL REFERENCES sites(site_id),
  crawl_date TEXT NOT NULL,
  pages_crawled INTEGER NOT NULL,
  pages_discovered INTEGER NOT NULL,
  average_response_ms REAL NOT NULL,
  error_rate REAL NOT NULL,
  blocked_by_robots INTEGER NOT NULL,
  anomaly_score REAL NOT NULL
);

CREATE TABLE search_console_daily (
  search_fact_id INTEGER PRIMARY KEY,
  page_group_id INTEGER NOT NULL REFERENCES page_groups(page_group_id),
  activity_date TEXT NOT NULL,
  impressions INTEGER NOT NULL,
  clicks INTEGER NOT NULL,
  avg_position REAL NOT NULL,
  ctr REAL NOT NULL
);

CREATE TABLE index_coverage_daily (
  coverage_fact_id INTEGER PRIMARY KEY,
  page_group_id INTEGER NOT NULL REFERENCES page_groups(page_group_id),
  coverage_date TEXT NOT NULL,
  indexed_urls INTEGER NOT NULL,
  excluded_urls INTEGER NOT NULL,
  discovered_urls INTEGER NOT NULL,
  canonical_conflicts INTEGER NOT NULL,
  noindex_urls INTEGER NOT NULL
);

CREATE TABLE url_signals (
  url_signal_id INTEGER PRIMARY KEY,
  page_group_id INTEGER NOT NULL REFERENCES page_groups(page_group_id),
  url_path TEXT NOT NULL,
  crawl_status TEXT NOT NULL,
  index_status TEXT NOT NULL,
  canonical_target TEXT,
  response_code INTEGER NOT NULL,
  last_crawled_at TEXT NOT NULL
);

CREATE TABLE anomaly_flags (
  anomaly_id INTEGER PRIMARY KEY,
  page_group_id INTEGER NOT NULL REFERENCES page_groups(page_group_id),
  flag_date TEXT NOT NULL,
  anomaly_type TEXT NOT NULL,
  severity TEXT NOT NULL,
  summary TEXT NOT NULL,
  impact_metric REAL NOT NULL,
  recommended_action TEXT NOT NULL
);
