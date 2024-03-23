-- ------------------------------
-- Load substrait extension

INSTALL substrait;
LOAD    substrait;


-- ------------------------------
-- Set options

.mode line


-- ------------------------------
-- Define Query

CALL get_substrait('
  EXPLAIN(
    SELECT  gene_id
           ,COUNT(*)        AS cell_count
           ,AVG(e.expr)     AS expr_avg
           ,VAR_POP(e.expr) AS expr_var
      FROM metaclusters mc
  
            JOIN clusters c
           USING (cluster_id)
  
            JOIN cluster_membership cm
           USING (cluster_id)
  
            JOIN  expression e
           USING (cell_id)
  
     WHERE mc.mcluster_id = 12
  
  GROUP BY e.gene_id
  )
');
