-- ------------------------------
-- Populate tables



-- ------------------------------
-- Sanity check data

  SELECT  gene_id
         ,COUNT(*)        AS cell_count
         ,AVG(e.expr)     AS expr_avg
         ,VAR_POP(e.expr) AS expr_var
    FROM clusters c
         JOIN  expr e
         USING (cell_id)
   WHERE c.metacluster_id = 12
GROUP BY e.gene_id
;



