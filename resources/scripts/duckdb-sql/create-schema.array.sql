-- ------------------------------
-- Drop schemas to recreate them

DROP TABLE IF EXISTS expr;
DROP TABLE IF EXISTS clusters;

-- ------------------------------
-- Define schemas

CREATE TABLE IF NOT EXISTS expr (
   gene_id VARCHAR
  ,cell_id VARCHAR
  ,expr    FLOAT
);

CREATE TABLE IF NOT EXISTS clusters (
   metacluster_id INT
  ,cluster_id     INT
  ,cell_id        VARCHAR
);

