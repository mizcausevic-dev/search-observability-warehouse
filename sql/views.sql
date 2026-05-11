CREATE VIEW vw_site_overview AS
SELECT
  s.site_code,
  s.domain,
  ROUND(AVG(c.average_response_ms), 1) AS avg_response_ms,
  ROUND(AVG(c.error_rate), 4) AS avg_error_rate,
  SUM(c.pages_crawled) AS total_pages_crawled,
  SUM(c.blocked_by_robots) AS total_blocked_by_robots,
  ROUND(AVG(c.anomaly_score), 2) AS average_crawl_anomaly_score
FROM sites s
JOIN crawl_daily c ON c.site_id = s.site_id
GROUP BY s.site_code, s.domain;

CREATE VIEW vw_page_group_rollup AS
SELECT
  pg.page_group_key,
  pg.template_name,
  pg.business_owner,
  SUM(sc.impressions) AS impressions,
  SUM(sc.clicks) AS clicks,
  ROUND(AVG(sc.ctr), 4) AS avg_ctr,
  ROUND(AVG(sc.avg_position), 2) AS avg_position,
  MAX(ic.indexed_urls) AS indexed_urls,
  MAX(ic.excluded_urls) AS excluded_urls,
  MAX(ic.canonical_conflicts) AS canonical_conflicts
FROM page_groups pg
JOIN search_console_daily sc ON sc.page_group_id = pg.page_group_id
JOIN index_coverage_daily ic ON ic.page_group_id = pg.page_group_id
GROUP BY pg.page_group_key, pg.template_name, pg.business_owner;

CREATE VIEW vw_crawl_index_mismatches AS
SELECT
  pg.page_group_key,
  us.url_path,
  us.crawl_status,
  us.index_status,
  us.response_code,
  us.canonical_target
FROM url_signals us
JOIN page_groups pg ON pg.page_group_id = us.page_group_id
WHERE us.crawl_status IN ('soft_404', 'redirect_chain', 'blocked')
   OR us.index_status IN ('excluded', 'discovered_not_indexed');

CREATE VIEW vw_freshness_gaps AS
SELECT
  s.site_code,
  sf.source_name,
  sf.last_loaded_at,
  sf.freshness_sla_hours,
  CAST((julianday('2026-05-11 12:00:00') - julianday(sf.last_loaded_at)) * 24 AS INTEGER) AS lag_hours,
  CASE
    WHEN CAST((julianday('2026-05-11 12:00:00') - julianday(sf.last_loaded_at)) * 24 AS INTEGER) > sf.freshness_sla_hours
      THEN 'breach'
    ELSE 'within_sla'
  END AS freshness_status
FROM source_freshness sf
JOIN sites s ON s.site_id = sf.site_id;
