# load(system.file("tests", "test_data.Rda", package = "STRINGutils", mustWork = TRUE))
load("test_data.Rda")

test_that("get_cluster_of_int gets clusters of interest", {
  suppressMessages(
    expect_equal(get_cluster_of_int(all_clusters, hits_filt), subnetwork_df)
  )
})

test_that("modify_nodes ", {
  ori_xml_mod <- xml2::xml_unserialize(ori_xml)
  expect_equal(modify_nodes(ori_xml_mod, colors_vec), NULL)
})

