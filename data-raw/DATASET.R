# ## code to prepare `DATASET` dataset goes here
#
# usethis::use_data(DATASET, overwrite = TRUE)

# use example data set and code from STRINGdb
string_db <- STRINGdb$new(version = "11", species = 9606,
                          score_threshold = 200,
                          input_directory = "")

data("diff_exp_example1")

example1_mapped <- string_db$map(diff_exp_example1, "gene", removeUnmappedRows = TRUE)

hits <- example1_mapped$STRING_id[1:200]

xml <- get_svg(string_db, hits)
ori_xml <- xml2::xml_serialize(xml, NULL)

# pick the top 10 genes according to pvalues as features of int
hits_filt <- example1_mapped %>%
  dplyr::slice_min(pvalue, n = 10, with_ties = FALSE) %>%
  dplyr::filter(!is.na(STRING_id))

colors_vec <- rep("rgb(101,226,11)", nrow(hits_filt))
names(colors_vec) <- hits_filt$gene

modify_nodes(xml, colors_vec)

# for subset of network
all_clusters <- string_db$get_clusters(hits)

subnetwork_df <- get_cluster_of_int(all_clusters, hits_filt)

save(ori_xml, subnetwork_df, colors_vec, hits, string_db,
     all_clusters, hits_filt,
     version = 2,
     file = "./tests/testthat/test_data.Rda")
