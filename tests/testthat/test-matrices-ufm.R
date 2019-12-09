context("test-matrices-ufm")

test_that("read_ufs obtaines the correct data from Epsom UFS", {
  set_xexes("C:/Program Files (x86)/Atkins/SATURN/XEXES 11.4.07H MC X7/")
  ufm <- read_ufm(saturnR_example("Epsom98mat.UFM"))
  expect_equal(ncol(ufm), 4)
  expect_equal(nrow(ufm), 144)
  expect_true(abs(sum(ufm$trips) - 4301.799) < 0.01) # with some precision.
})

test_that("Read and write matrix are consistent", {
  set_xexes("C:/Program Files (x86)/Atkins/SATURN/XEXES 11.4.07H MC X7/")
  temp_ufm <- tempfile(fileext = ".UFM")
  ufm <- read_ufm(saturnR_example("Epsom98mat.UFM"))
  write_ufm(ufm, temp_ufm, stack = TRUE)
  ufm2 <- read_ufm(temp_ufm)
  expect_equal(sum(ufm$trips),sum(ufm2$trips)) # with some precision.
})
