-- ------------------------------
-- Load expression values

  -- COPY cells
  -- FROM '../../data/source/cells.tsv'
  -- WITH (DELIMITER '\t', HEADER false)
  -- ;

  -- expression for dataset E-GEOD-100618
  INSERT INTO expression(gene_id, cell_id, expr)
  SELECT gene_id, cell_id, expr
    FROM read_csv('resources/data/source/expr/E-GEOD-100618.tsv'
           ,delim='\t'
           ,header=false
           ,columns={ 'gene_name': 'VARCHAR'
                     ,'cell_name': 'VARCHAR'
                     ,'expr'     : 'FLOAT'}
         )

          JOIN genes
         USING (gene_name)

          JOIN cells
         USING (cell_name)
  ;


  -- expression for dataset E-GEOD-106540
  INSERT INTO expression(gene_id, cell_id, expr)
  SELECT gene_id, cell_id, expr
    FROM read_csv('resources/data/source/expr/E-GEOD-106540.tsv'
           ,delim='\t'
           ,header=false
           ,columns={ 'gene_name': 'VARCHAR'
                     ,'cell_name': 'VARCHAR'
                     ,'expr'     : 'FLOAT'}
         )

          JOIN genes
         USING (gene_name)

          JOIN cells
         USING (cell_name)
  ;


  -- expression for dataset E-GEOD-76312
  INSERT INTO expression(gene_id, cell_id, expr)
  SELECT gene_id, cell_id, expr
    FROM read_csv('resources/data/source/expr/E-GEOD-76312.tsv'
           ,delim='\t'
           ,header=false
           ,columns={ 'gene_name': 'VARCHAR'
                     ,'cell_name': 'VARCHAR'
                     ,'expr'     : 'FLOAT'}
         )

          JOIN genes
         USING (gene_name)

          JOIN cells
         USING (cell_name)
  ;
