context("test-example")

test_that("providing example file name returns full path", {
  expect_true(file.exists(saturnR_example("Epsom98oba.UFS")))
})


# test_that("multiplication works", {
#   expect_equal(2 * 2, 4)
# })
