# CP3 Database Optimization Report

## 1. Overview

This checkpoint focused on improving the performance of the Amazon database workload through indexing and query optimization. The original 30-query workload was benchmarked before and after optimization using PostgreSQL EXPLAIN ANALYZE with buffer information.

## 2. Optimization Approach

The optimization work included:

- Added B-tree indexes for frequently filtered and joined columns.
- Added GIN trigram indexes using pg_trgm for substring searches on product titles and review bodies.
- Added partial indexes for filtered workloads such as shipped orders and verified-purchase reviews.
- Added covering indexes with INCLUDE columns to reduce additional table lookups.
- Rewrote R19 using CTEs and aggregation to avoid repeatedly scanning order_items for each mobile product.
- Refreshed table statistics using ANALYZE.

A total of 16 indexes were added.

## 3. Major Performance Improvements

The following are average execution times from the baseline and optimized benchmark summaries.

| Query | Before (ms) | After (ms) |
|---|---:|---:|
| R01 | 7.854 | 1.656 |
| R03 | 1.385 | 0.141 |
| R04 | 3.671 | 0.184 |
| R05 | 5.507 | 0.453 |
| R06 | 5.531 | 0.878 |
| R19 | 11141.031 | 9.999 |
| R21 | 5.437 | 1.029 |
| R22 | 24.765 | 7.229 |

R19 showed the largest improvement. Its execution time dropped from approximately 11.14 seconds to 10 milliseconds, making it roughly 1,114 times faster.

## 4. Regressions and Trade-offs

Not every query improved. Some queries became slower after optimization:

| Query | Before (ms) | After (ms) |
|---|---:|---:|
| R08 | 17.948 | 30.317 |
| R12 | 57.844 | 70.925 |
| R13 | 15.685 | 23.778 |
| R17 | 50.935 | 158.858 |

Additional indexes can increase write overhead and affect the query planner's choices. W04 increased from 45.182 ms to 49.457 ms, showing a small write-performance trade-off.

These results are reported transparently rather than treating every index as beneficial.

## 5. Benchmark Methodology

- Database: amazon_project
- PostgreSQL: version 16
- Workload: workload_30.sql, with R19 optimized in the copied workload file
- Benchmark runs: 3 per query
- Measurement: EXPLAIN (ANALYZE, BUFFERS)
- Baseline and optimized runs used the same local PostgreSQL 16 database setup.

The optimized results are saved in `benchmarks/results/optimized/summary.csv`, with individual query plans stored alongside the summary.

## 6. Deliverables

- `sql/05_indexes.sql` — index definitions
- `sql/06_optimized_queries.sql` — optimized workload
- `benchmarks/results/optimized/summary.csv` — optimized benchmark results
- `docs/04_optimization_report.md` — this report

## 7. Conclusion

The optimization significantly improved several important queries, especially R19, which was the largest baseline bottleneck. Some queries regressed, and additional index maintenance introduced a small write cost. The results demonstrate the importance of measuring both read and write workloads instead of assuming that adding indexes always improves performance.
