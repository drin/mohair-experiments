-- ------------------------------
-- Load all cells from ebi datasets

  INSERT INTO cells(cell_name)
  SELECT *
    FROM read_csv('resources/data/source/cells.tsv'
           ,delim='\t'
           ,header=false
           ,columns={ 'cell_name': 'VARCHAR' }
         )
  ;


-- ------------------------------
-- Load all genes from ebi datasets

  INSERT INTO genes(gene_name)
  SELECT *
    FROM read_csv('resources/data/source/genes.tsv'
           ,delim='\t'
           ,header=false
           ,columns={ 'gene_name': 'VARCHAR' }
         )
  ;
