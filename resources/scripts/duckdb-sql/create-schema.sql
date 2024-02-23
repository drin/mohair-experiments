-- ------------------------------
-- Drop schemas to recreate them

    DROP TABLE IF EXISTS cluster_membership;
    DROP TABLE IF EXISTS gset_membership;
    DROP TABLE IF EXISTS metaclusters;
    DROP TABLE IF EXISTS cluster_annotations;
    DROP TABLE IF EXISTS centroids;
    DROP TABLE IF EXISTS clusters;
    DROP TABLE IF EXISTS genesets;
    DROP TABLE IF EXISTS expression;
    DROP TABLE IF EXISTS cells;
    DROP TABLE IF EXISTS genes;


    DROP SEQUENCE IF EXISTS seq_geneid;
    DROP SEQUENCE IF EXISTS seq_cellid;
    DROP SEQUENCE IF EXISTS seq_gsetid;
    DROP SEQUENCE IF EXISTS seq_clusterid;
    DROP SEQUENCE IF EXISTS seq_centroidid;
    DROP SEQUENCE IF EXISTS seq_annotationid;
    DROP SEQUENCE IF EXISTS seq_mclusterid;


-- ------------------------------
-- Sequences for identity columns

    CREATE SEQUENCE IF NOT EXISTS seq_geneid       START 1;
    CREATE SEQUENCE IF NOT EXISTS seq_cellid       START 1;
    CREATE SEQUENCE IF NOT EXISTS seq_gsetid       START 1;
    CREATE SEQUENCE IF NOT EXISTS seq_clusterid    START 1;
    CREATE SEQUENCE IF NOT EXISTS seq_centroidid   START 1;
    CREATE SEQUENCE IF NOT EXISTS seq_annotationid START 1;
    CREATE SEQUENCE IF NOT EXISTS seq_mclusterid   START 1;


-- ------------------------------
-- Relation schemas


-- >> core entities

    CREATE TABLE IF NOT EXISTS genes (
       gene_id   BIGINT  DEFAULT nextval('seq_geneid')
      ,gene_name VARCHAR
      ,PRIMARY KEY (gene_id)
    );
    
    CREATE TABLE IF NOT EXISTS cells (
       cell_id   BIGINT  DEFAULT nextval('seq_cellid')
      ,cell_name VARCHAR
      ,PRIMARY KEY (cell_id)
    );
    
    CREATE TABLE IF NOT EXISTS expression (
       gene_id BIGINT
      ,cell_id BIGINT
      ,expr    FLOAT
    
      ,PRIMARY KEY (gene_id, cell_id)
    );


-- >> higher-order entities for grouping

    CREATE TABLE IF NOT EXISTS genesets (
       gset_id    BIGINT  DEFAULT nextval('seq_gsetid')
      ,gset_name  VARCHAR
      ,gset_group VARCHAR

      ,PRIMARY KEY (gset_id)
    );

    CREATE TABLE IF NOT EXISTS clusters (
       cluster_id   BIGINT DEFAULT nextval('seq_clusterid')
      ,cluster_name VARCHAR

      ,PRIMARY KEY (cluster_id, cluster_name)
    );

    CREATE TABLE IF NOT EXISTS centroids (
       centroid_id BIGINT DEFAULT nextval('seq_centroidid')
      ,cluster_id  BIGINT
      ,gene_id     BIGINT
      ,expr        FLOAT

      ,PRIMARY KEY (centroid_id, cluster_id, gene_id)
    );

    CREATE TABLE IF NOT EXISTS cluster_annotations (
       annotation_id  BIGINT DEFAULT nextval('seq_annotationid')
      ,cluster_id     BIGINT
      ,annotation_key VARCHAR
      ,annotation_val VARCHAR

      ,PRIMARY KEY (annotation_id)
    );

    CREATE TABLE IF NOT EXISTS metaclusters (
       mcluster_id BIGINT DEFAULT nextval('seq_mclusterid')
      ,cluster_id  BIGINT

      ,PRIMARY KEY (mcluster_id, cluster_id)
    );


-- >> bridge tables for many-to-many relationships

    CREATE TABLE IF NOT EXISTS gset_membership (
       gset_id BIGINT
      ,gene_id BIGINT

      ,PRIMARY KEY (gset_id, gene_id)
    );

    CREATE TABLE IF NOT EXISTS cluster_membership (
       cluster_id BIGINT
      ,cell_id    BIGINT

      ,PRIMARY KEY (cluster_id, cell_id)
    );


-- ------------------------------
-- Auxiliary structures

    CREATE UNIQUE INDEX IF NOT EXISTS idx_gname       ON genes(gene_name);
    CREATE UNIQUE INDEX IF NOT EXISTS idx_cname       ON cells(cell_name);
    CREATE INDEX        IF NOT EXISTS idx_expr        ON expression(expr);
    CREATE INDEX        IF NOT EXISTS idx_annotations ON cluster_annotations(cluster_id, annotation_val);

