context("test-read-ufs")

test_that("read_ufs get's the correct data from epsom", {
  set_xexes("C:/Program Files (x86)/Atkins/SATURN/XEXES 11.4.07H MC X7/")
  epsom_ufs <- saturnR_example("Epsom98oba.UFS")
  ufs <- read_ufs(epsom_ufs, load_geometry = TRUE, selection_mode = "all_links", step = 1)
  expect_equal(ncol(ufs), 70)
  expect_equal(nrow(ufs), 48)
  expect_true(mean(ufs$actual_flow) - 567.5415 < 0.01)
  expect_true(mean(ufs$net_speed) - 19.46687 < 0.01)
})
