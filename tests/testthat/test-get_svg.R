test_that("get_svg() gets svg", {
  testthat::expect_match(
    class(get_svg(string_db, string_ids)), "xml_document", all = FALSE)
})
