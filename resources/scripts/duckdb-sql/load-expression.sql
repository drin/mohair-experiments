-- ------------------------------
-- Define temporary tables to facilitate faster loads

  CREATE TEMP TABLE IF NOT EXISTS expr_stage1 (
     gene_name VARCHAR
    ,cell_name VARCHAR
    ,expr      FLOAT
  );

  CREATE TEMP TABLE IF NOT EXISTS expr_stage2 (
     gene_name VARCHAR
    ,cell_id   BIGINT
    ,expr      FLOAT
  );


-- ------------------------------
-- Load expression values

  -- >> E-GEOD-100618
      TRUNCATE expr_stage1;
      TRUNCATE expr_stage2;

      SELECT get_current_time() AS load_starttime, 'Loading from TSV...' AS log_msg;
      COPY     expr_stage1
      FROM 'resources/data/source/expr/E-GEOD-100618.tsv'
      WITH (DELIMITER '\t', HEADER false);


      SELECT get_current_time() AS time_start, 'Normalizing cell IDs...' AS log_msg;
      INSERT INTO expr_stage2(gene_name, cell_id, expr)
      SELECT gene_name, cell_id, expr
        FROM expr_stage1 JOIN cells USING (cell_name);

      SELECT get_current_time() AS time_start, 'Normalizing gene IDs...' AS log_msg;
      INSERT INTO expression(   gene_id, cell_id, expr)
      SELECT   gene_id, cell_id, expr
        FROM expr_stage2 JOIN genes USING (gene_name);

      SELECT get_current_time() AS load_endtime, 'Load complete.' AS log_msg;
      TRUNCATE expr_stage1;
      TRUNCATE expr_stage2;

  -- >> E-GEOD-106540
      TRUNCATE expr_stage1;
      TRUNCATE expr_stage2;

      SELECT get_current_time() AS load_starttime, 'Loading from TSV...' AS log_msg;
      COPY     expr_stage1
      FROM 'resources/data/source/expr/E-GEOD-106540.tsv'
      WITH (DELIMITER '\t', HEADER false);

      SELECT get_current_time() AS time_start, 'Normalizing cell IDs...' AS log_msg;
      INSERT INTO expr_stage2(gene_name, cell_id, expr)
      SELECT gene_name, cell_id, expr
        FROM expr_stage1 JOIN cells USING (cell_name);

      SELECT get_current_time() AS time_start, 'Normalizing gene IDs...' AS log_msg;
      INSERT INTO expression(   gene_id, cell_id, expr)
      SELECT   gene_id, cell_id, expr
        FROM expr_stage2 JOIN genes USING (gene_name);

      SELECT get_current_time() AS load_endtime, 'Load complete.' AS log_msg;
      TRUNCATE expr_stage1;
      TRUNCATE expr_stage2;


  -- >> E-GEOD-76312
      TRUNCATE expr_stage1;
      TRUNCATE expr_stage2;

      SELECT get_current_time() AS load_starttime, 'Loading from TSV...' AS log_msg;
      COPY     expr_stage1
      FROM 'resources/data/source/expr/E-GEOD-76312.tsv'
      WITH (DELIMITER '\t', HEADER false);

      SELECT get_current_time() AS time_start, 'Normalizing cell IDs...' AS log_msg;
      INSERT INTO expr_stage2(gene_name, cell_id, expr)
      SELECT gene_name, cell_id, expr
        FROM expr_stage1 JOIN cells USING (cell_name);

      SELECT get_current_time() AS time_start, 'Normalizing gene IDs...' AS log_msg;
      INSERT INTO expression(   gene_id, cell_id, expr)
      SELECT   gene_id, cell_id, expr
        FROM expr_stage2 JOIN genes USING (gene_name);

      SELECT get_current_time() AS load_endtime, 'Load complete.' AS log_msg;
      TRUNCATE expr_stage1;
      TRUNCATE expr_stage2;

-- ------------------------------
-- Cleanup

DROP TABLE IF EXISTS expr_stage1;
DROP TABLE IF EXISTS expr_stage2;
