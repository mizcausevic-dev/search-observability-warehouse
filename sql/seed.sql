INSERT INTO sites (site_id, site_code, domain, market) VALUES
  (1, 'kg-main', 'kineticgain.com', 'US'),
  (2, 'kg-uk', 'kineticgain.co.uk', 'UK');

INSERT INTO page_groups (page_group_id, site_id, page_group_key, template_name, business_owner) VALUES
  (101, 1, 'blog-guides', 'blog_article', 'Content + SEO'),
  (102, 1, 'services-core', 'service_page', 'Revenue + Marketing'),
  (103, 1, 'pricing', 'pricing_surface', 'Growth + RevOps'),
  (201, 2, 'uk-services', 'service_page', 'International Growth');

INSERT INTO source_freshness (freshness_id, site_id, source_name, last_loaded_at, freshness_sla_hours, row_count) VALUES
  (1, 1, 'search_console', '2026-05-11 08:00:00', 24, 2840),
  (2, 1, 'crawl_logs', '2026-05-11 06:00:00', 12, 18420),
  (3, 1, 'index_coverage', '2026-05-10 17:00:00', 24, 480),
  (4, 2, 'search_console', '2026-05-10 01:00:00', 24, 1620);

INSERT INTO crawl_daily (crawl_id, site_id, crawl_date, pages_crawled, pages_discovered, average_response_ms, error_rate, blocked_by_robots, anomaly_score) VALUES
  (1, 1, '2026-05-10', 8120, 8640, 412.0, 0.061, 118, 0.82),
  (2, 1, '2026-05-11', 8460, 8712, 366.0, 0.034, 94, 0.36),
  (3, 2, '2026-05-10', 4930, 5210, 455.0, 0.072, 61, 0.78);

INSERT INTO search_console_daily (search_fact_id, page_group_id, activity_date, impressions, clicks, avg_position, ctr) VALUES
  (1, 101, '2026-05-10', 142000, 6400, 18.3, 0.0451),
  (2, 102, '2026-05-10', 92000, 5580, 11.6, 0.0607),
  (3, 103, '2026-05-10', 44100, 2072, 9.4, 0.0470),
  (4, 201, '2026-05-10', 38500, 1655, 13.2, 0.0430),
  (5, 101, '2026-05-11', 145800, 6020, 17.8, 0.0413),
  (6, 102, '2026-05-11', 94800, 5772, 11.2, 0.0609),
  (7, 103, '2026-05-11', 46300, 1906, 9.1, 0.0412),
  (8, 201, '2026-05-11', 40200, 1478, 13.5, 0.0368);

INSERT INTO index_coverage_daily (coverage_fact_id, page_group_id, coverage_date, indexed_urls, excluded_urls, discovered_urls, canonical_conflicts, noindex_urls) VALUES
  (1, 101, '2026-05-11', 1260, 218, 1490, 26, 58),
  (2, 102, '2026-05-11', 340, 42, 388, 8, 6),
  (3, 103, '2026-05-11', 48, 12, 65, 2, 1),
  (4, 201, '2026-05-11', 276, 84, 383, 19, 24);

INSERT INTO url_signals (url_signal_id, page_group_id, url_path, crawl_status, index_status, canonical_target, response_code, last_crawled_at) VALUES
  (1, 101, '/blog/seo-governance-framework', 'ok', 'indexed', '/blog/seo-governance-framework', 200, '2026-05-11 04:15:00'),
  (2, 101, '/blog/search-observability-blueprint', 'soft_404', 'excluded', '/blog/search-observability-blueprint', 200, '2026-05-11 04:22:00'),
  (3, 103, '/pricing', 'ok', 'indexed', '/pricing', 200, '2026-05-11 05:01:00'),
  (4, 103, '/pricing-old', 'redirect_chain', 'excluded', '/pricing', 301, '2026-05-11 05:08:00'),
  (5, 201, '/uk/services/seo-governance', 'blocked', 'discovered_not_indexed', '/uk/services/seo-governance', 200, '2026-05-10 23:40:00'),
  (6, 201, '/uk/services/revenue-ops', 'ok', 'indexed', '/uk/services/revenue-ops', 200, '2026-05-10 23:47:00');

INSERT INTO anomaly_flags (anomaly_id, page_group_id, flag_date, anomaly_type, severity, summary, impact_metric, recommended_action) VALUES
  (1, 101, '2026-05-11', 'ctr_drop', 'high', 'Blog guides gained impressions while CTR fell more than expected.', -0.0038, 'Review title changes and snippet competition for blog-guides.'),
  (2, 103, '2026-05-11', 'conversion_surface_volatility', 'medium', 'Pricing surface impressions climbed but click efficiency softened.', -0.0058, 'Compare pricing experiments with SERP snippet changes.'),
  (3, 201, '2026-05-11', 'index_gap', 'critical', 'UK service pages show crawl access but poor index inclusion.', 107.0, 'Audit robots, canonicals, and local-market internal links.');
