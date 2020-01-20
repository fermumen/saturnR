context("test-xexes")

test_that("Bad or empy xexes folders produce errors", {
  expect_error(set_xexes())
  expect_error(set_xexes("nonsese"))
})

test_that("Get Xexes gives an error without setting it up first", {
  expect_error(get_xexes())
})
