load("test_data.Rda")

test_that("get_svg() gets svg", {
  xml <- get_svg(string_db, hits)
  testthat::expect_match(class(xml), "xml_document", all = FALSE)
  testthat::expect_match(xml2::xml_name(xml), "svg", all = FALSE)

  # ori_xml_mod <- xml2::xml_unserialize(ori_xml)
  # expect_equal(xml, ori_xml_mod)
})
