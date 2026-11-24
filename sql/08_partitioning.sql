-- Parent table
CREATE TABLE amazon.orders_partitioned (
    LIKE amazon.orders INCLUDING ALL
) PARTITION BY RANGE (ordered_at);

-- Partitions
CREATE TABLE amazon.orders_2024
PARTITION OF amazon.orders_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE amazon.orders_2025
PARTITION OF amazon.orders_partitioned
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE amazon.orders_2026
PARTITION OF amazon.orders_partitioned
FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

CREATE TABLE amazon.orders_default
PARTITION OF amazon.orders_partitioned
DEFAULT;

INSERT INTO amazon.orders_partitioned
SELECT * FROM amazon.orders;