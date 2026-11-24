# Scalability Report

## Objective
Improve performance on large datasets using PostgreSQL table partitioning.

## Partitioning Strategy
The `orders` table was partitioned using RANGE partitioning on the `ordered_at` column.

## Why this table?
- Largest transactional table.
- Most workload queries filter by order date.
- Enables partition pruning.

## Expected Benefits
- Faster date-range queries.
- Reduced sequential scans.
- Better maintenance.
- Improved scalability as historical data grows.

## Benchmark
Large-dataset benchmarks were executed after partitioning and compared against the optimized baseline.

## Conclusion
Partitioning improves scalability for analytical and reporting workloads while preserving query correctness.