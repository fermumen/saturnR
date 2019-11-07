## usage:
## test_sheet("blanks.xls")
test_uf_file <- function(fname) testthat::test_path("UF_files", fname)

expect_error_free <- function(...) {
  expect_error(..., regexp = NA)
}
