library(testthat)
library(Rglottography)

# Test 1: Offline functionality

test_that("install_datasets aborts when offline", {
  skip_on_cran()
  skip_if(httr2::is_online(), "Internet available")

  expect_error(
    install_datasets("all"),
    class = "rlang_error",
    regexp = "No internet connection detected"
  )
})

# Test 2: Validation of update

test_that("install_datasets validates update argument", {
  skip_on_cran()

  expect_error(
    install_datasets("all", update = "sometimes"),
    regexp = "arg.*one of",
    class = "error"
  )
})

# Test 3: Nothing to install

test_that("install_datasets returns NULL when nothing to install", {
  skip_on_cran()
  skip_if_not_installed("mockery")

  mockery::stub(
    install_datasets,
    ".get_installation_instructions",
    function(...) character(0)
  )

  mockery::stub(
    install_datasets,
    ".get_registry",
    function(...) data.frame()
  )

  mockery::stub(
    install_datasets,
    ".download_datasets",
    function(...) stop("Should not be called")
  )

  res <- install_datasets("missing")

  expect_null(res)
})

# Test 4: Successful installation

test_that("install_datasets returns installed datasets invisibly", {
  skip_on_cran()
  skip_if_not_installed("mockery")

  fake_datasets <- c("dataset1", "dataset2")

  mockery::stub(
    install_datasets,
    ".get_registry",
    function(...) data.frame(name = fake_datasets)
  )

  mockery::stub(
    install_datasets,
    ".get_installation_instructions",
    function(...) fake_datasets
  )

  called <- FALSE
  mockery::stub(
    install_datasets,
    ".download_datasets",
    function(datasets, registry) {
      called <<- TRUE
    }
  )

  res <- install_datasets("missing")

  expect_true(called)
  expect_equal(res, fake_datasets)
})



