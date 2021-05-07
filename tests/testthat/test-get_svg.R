context("Get SVG")

test_that("get_svg() gets svg", {
  xml <- get_svg(string_db, string_ids)
  testthat::expect_match(class(xml), "xml_document", all = FALSE)
  testthat::expect_match(xml2::xml_name(xml), "svg", all = FALSE)
})
