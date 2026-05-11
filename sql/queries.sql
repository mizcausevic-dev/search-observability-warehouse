-- Query 1: Site overview
SELECT * FROM vw_site_overview ORDER BY average_crawl_anomaly_score DESC;

-- Query 2: Freshness gaps
SELECT * FROM vw_freshness_gaps ORDER BY lag_hours DESC;

-- Query 3: Page-group performance rollup
SELECT * FROM vw_page_group_rollup ORDER BY impressions DESC;

-- Query 4: Crawl and index mismatches
SELECT * FROM vw_crawl_index_mismatches ORDER BY page_group_key, url_path;

-- Query 5: Active anomalies with page-group context
SELECT
  pg.page_group_key,
  af.anomaly_type,
  af.severity,
  af.summary,
  af.recommended_action
FROM anomaly_flags af
JOIN page_groups pg ON pg.page_group_id = af.page_group_id
ORDER BY CASE af.severity
  WHEN 'critical' THEN 1
  WHEN 'high' THEN 2
  WHEN 'medium' THEN 3
  ELSE 4
END, pg.page_group_key;
