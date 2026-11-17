# Checkpoint 2 (CP2) — Baseline Performance Timings

## Environment & Benchmarking Setup
- **Database:** `amazon_db` (schema: `amazon`)
- **DBMS:** PostgreSQL 18.6 (macOS, Homebrew)
- **Workload:** `queries/workload_30.sql` (24 `READ` queries `R01`–`R24`, 6 `WRITE` queries `W01`–`W06`)
- **Command:** `./benchmarks/run_benchmark.sh amazon_db baseline`
- **Methodology:** Each query was executed **3 times** with `EXPLAIN (ANALYZE, BUFFERS)`. All `WRITE` queries (`W01`–`W06`) were executed inside `BEGIN; ... ROLLBACK;` transactions so the underlying dataset remained unmodified.
- **Raw Plans & Summary:** Saved in `benchmarks/results/baseline/` (`R01.txt`–`W06.txt` and `summary.csv`).

## Baseline Execution Timings (30 Workload Queries)

| Query ID | READ/WRITE | Run 1 (ms) | Run 2 (ms) | Run 3 (ms) | Average (ms) | Scan Type | Explanation of performance |
| :--- | :--- | ---: | ---: | ---: | ---: | :--- | :--- |
| R01 | READ | 29.634 | 24.863 | 24.454 | 26.317 | Seq Scan on products | Leading-wildcard `ILIKE '%wireless%'` and unindexed `status` force a full sequential scan of all 30,000 products. |
| R02 | READ | 6.208 | 6.632 | 5.868 | 6.236 | Seq Scan on categories \| Seq Scan on products | Small `categories` CTE (40 rows) is fast, but lack of an index on `products(category_id, status, price)` triggers a sequential scan of `products`. |
| R03 | READ | 2.992 | 2.621 | 2.784 | 2.799 | Seq Scan on product_reviews | No index on `product_reviews(product_id)`, forcing a sequential scan over 38,662 reviews to count ratings for one product. |
| R04 | READ | 7.957 | 7.080 | 6.847 | 7.295 | Seq Scan on orders \| Index Only Scan using order_items_pkey on order_items | `order_items` uses its composite primary key index, but missing index on `orders(customer_id)` forces a sequential scan of 120,000 orders. |
| R05 | READ | 9.598 | 9.592 | 10.796 | 9.995 | Seq Scan on orders | No index on `orders(status, shipped_at)`, requiring a full sequential scan and sort across 120,000 orders. |
| R06 | READ | 12.028 | 9.729 | 9.128 | 10.295 | Seq Scan on order_items \| Index Scan using orders_pkey on orders | Joins `orders` via `orders_pkey`, but unindexed `order_items(seller_id)` and non-sargable `date_trunc` force a full scan of 240,000 order items. |
| R07 | READ | 3.559 | 3.246 | 3.820 | 3.542 | Seq Scan on products | Missing index on `products(seller_id, status, stock_qty)` requires scanning all 30,000 product rows sequentially. |
| R08 | READ | 47.651 | 48.654 | 53.417 | 49.907 | Seq Scan on order_items \| Seq Scan on orders \| Seq Scan on products | Unindexed `orders(ordered_at)` and foreign keys force full sequential scans across `orders`, `order_items`, and `products` before window ranking. |
| R09 | READ | 47.844 | 47.432 | 48.244 | 47.840 | Seq Scan on orders \| Seq Scan on customers | Non-sargable `EXTRACT(YEAR FROM ordered_at)` and unindexed `orders(customer_id)` require full sequential scans of `orders` (120k) and `customers` (30k). |
| R10 | READ | 34.766 | 36.146 | 39.468 | 36.793 | Seq Scan on orders \| Seq Scan on cart_items \| Seq Scan on products | Missing indexes on `cart_items(added_at)` and `orders(customer_id, ordered_at)` force full sequential scans across all three tables. |
| R11 | READ | 14.956 | 9.490 | 9.833 | 11.426 | Seq Scan on order_items \| Index Scan using order_items_pkey on order_items | Self-join probes `order_items_pkey` for co-purchased items, but finding `a.product_id = 4321` requires a full scan of 240,000 rows due to no index on `product_id`. |
| R12 | READ | 258.367 | 145.139 | 124.108 | 175.871 | Seq Scan on order_items \| Seq Scan on products \| Seq Scan on categories \| Seq Scan on returns | Aggregates all 240,000 `order_items` joined across `products`, `categories`, and unindexed `returns(order_id, line_no)` via full sequential scans. |
| R13 | READ | 30.082 | 34.884 | 37.178 | 34.048 | Seq Scan on addresses \| Seq Scan on orders | `NOT IN` subquery over unindexed `orders(address_id)` forces sequential scans of all 120,000 orders and 45,000 addresses. |
| R14 | READ | 7.729 | 8.855 | 9.084 | 8.556 | Seq Scan on products | Computed predicate `price < mrp * 0.5` and unindexed `status` require a full sequential scan of 30,000 products. |
| R15 | READ | 43.205 | 42.486 | 42.329 | 42.673 | Seq Scan on order_items \| Seq Scan on orders \| Seq Scan on sellers | Unindexed `orders(ordered_at)` and `order_items(seller_id)` force full sequential scans across `orders`, `order_items`, and `sellers` before aggregation. |
| R16 | READ | 24.613 | 26.562 | 26.454 | 25.876 | Seq Scan on product_reviews \| Seq Scan on products \| Seq Scan on categories | Leading-wildcard `ILIKE '%battery%'` on `product_reviews(body)` and unindexed `products(category_id)` trigger full sequential scans of all three tables. |
| R17 | READ | 130.037 | 140.773 | 138.527 | 136.446 | Seq Scan on order_items \| Seq Scan on orders \| Seq Scan on product_reviews | Anti-join (`NOT EXISTS`) over unindexed `orders(customer_id)` and `order_items(product_id)` performs full scans and hash/sort anti-joins across large tables. |
| R18 | READ | 22.988 | 23.185 | 21.009 | 22.394 | Seq Scan on orders \| Seq Scan on customers | Unindexed `customers(city_id)` and `orders(customer_id, ordered_at)` force full sequential scans of `customers` and `orders` before `NTILE(4)` sorting. |
| R19 | READ | 20032.786 | 19412.017 | 19400.048 | 19614.950 | Seq Scan on categories \| Seq Scan on products \| Seq Scan on order_items \| Index Scan using orders_pkey on orders | Extreme bottleneck (~19.6 s): two correlated subqueries execute a full sequential scan of 240,000 `order_items` for every Mobile product due to no index on `order_items(product_id)`. |
| R20 | READ | 11.519 | 11.240 | 10.960 | 11.240 | Seq Scan on orders | Casting `ordered_at::date` prevents index usage and forces a full sequential scan of 120,000 orders to compute daily GMV. |
| R21 | READ | 9.548 | 12.165 | 10.892 | 10.868 | Seq Scan on orders | Unindexed `orders(ordered_at)` and interval expression `delivered_at > ordered_at + interval '5 days'` force a sequential scan of 120,000 orders. |
| R22 | READ | 50.371 | 63.610 | 52.838 | 55.606 | Seq Scan on orders | Deep pagination (`OFFSET 75000`) without an index on `orders(ordered_at DESC)` requires scanning and sorting 75,025+ rows in memory/disk. |
| R23 | READ | 0.145 | 0.166 | 0.410 | 0.240 | Index Scan using order_items_pkey on order_items \| Index Scan using orders_pkey on orders \| Index Scan using products_pkey on products \| Index Scan using sellers_pkey on sellers | Very fast sub-millisecond point lookup because every join and filter uses existing primary key indexes (`orders_pkey`, `order_items_pkey`, `products_pkey`, `sellers_pkey`). |
| R24 | READ | 0.053 | 0.056 | 0.048 | 0.052 | Index Scan using products_asin_key on products | Fastest query in the workload (0.052 ms): direct single-row lookup using the unique B-tree index `products_asin_key`. |
| W01 | WRITE | 1.844 | 0.923 | 0.879 | 1.215 | (no scan) | Single-row `INSERT` into `orders` only validates primary/foreign key B-tree indexes (`orders_pkey`, `customers_pkey`, `addresses_pkey`). |
| W02 | WRITE | 0.590 | 0.627 | 0.382 | 0.533 | Index Scan using products_pkey on products | Fast single-row `UPDATE` locating `product_id = 4322` directly via `products_pkey`. |
| W03 | WRITE | 2.206 | 2.533 | 2.629 | 2.456 | Seq Scan on categories \| Seq Scan on products | Missing index on `products(seller_id, category_id)` forces sequential scans of `categories` and `products` before updating matching rows. |
| W04 | WRITE | 121.645 | 73.661 | 67.333 | 87.546 | (no scan) | Bulk `INSERT` of 5,000 rows into `cart_items` incurs overhead from `ON CONFLICT` arbitration on `cart_items_pkey` and foreign key checks against `customers` and `products`. |
| W05 | WRITE | 16.904 | 15.869 | 16.938 | 16.570 | Index Scan using orders_pkey on orders | Locating `min(order_id) WHERE status = 'PACKED'` scans `orders_pkey` sequentially until finding the first matching status because `status` is unindexed. |
| W06 | WRITE | 14.323 | 12.433 | 13.237 | 13.331 | Seq Scan on cart_items | No index on `cart_items(added_at)`, forcing a full sequential scan of 44,998 rows to identify and delete expired cart entries. |

## Key Baseline Observations
1. **Primary/Unique Key Lookups Are Sub-Millisecond:** Queries `R23` (`0.240 ms`), `R24` (`0.052 ms`), and `W02` (`0.533 ms`) already perform near-instantaneously because PostgreSQL automatically creates B-tree indexes for `PRIMARY KEY` and `UNIQUE` constraints.
2. **Missing Foreign-Key Indexes Dominate Read Latency:** PostgreSQL does not automatically index foreign keys. Queries filtering or joining on `order_items(product_id)`, `order_items(seller_id)`, `orders(customer_id)`, and `products(category_id)` fall back to full sequential scans.
3. **Critical Bottleneck (`R19` at 19.6 seconds):** `R19` executes two correlated subqueries over `order_items` (240,000 rows) for each product in `'Mobiles'`, causing repeated full sequential scans that account for over 96% of total workload execution time.
