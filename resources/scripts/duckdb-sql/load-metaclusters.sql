-- ------------------------------
-- Load metaclusters

    -- NOTE: we are able to insert from cluster_annotations because clusters from
    --       these datasets happen to all be in the same metacluster

    -- metacluster 12
    INSERT INTO metaclusters(mcluster_id, cluster_id)
         SELECT  12         AS mcluster_id
                ,cluster_id
           FROM cluster_annotations
          WHERE     annotation_key = 'dataset-name'
                AND (   annotation_val = 'E-GEOD-100618'
                     OR annotation_val = 'E-GEOD-76312'
                    )
       ORDER BY cluster_id
    ;


    -- metacluster 13
    INSERT INTO metaclusters(mcluster_id, cluster_id)
         SELECT  13         AS mcluster_id
                ,cluster_id
           FROM cluster_annotations
          WHERE     annotation_key = 'dataset-name'
                AND annotation_val = 'E-GEOD-106540'
       ORDER BY cluster_id
    ;

