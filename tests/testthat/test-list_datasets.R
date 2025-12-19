library(testthat)
library(Rglottography)

# Test 1: Offline functionality

test_that("list_datasets returns a data.frame with correct columns (offline)", {

  res <- list_datasets(online = FALSE)

  expect_s3_class(res, "data.frame")
  expected_cols <- c("name", "installed", "created",
                     "version", "version_local", "modified", "modified_local")
  expect_true(all(expected_cols %in% colnames(res)))

  # Check that 'installed' column is logical
  expect_type(res$installed, "logical")
})

# Test 2: Column types (offline)

test_that("list_datasets columns have correct types", {
  res <- list_datasets(online = FALSE)
  expect_type(res$name, "character")
  expect_type(res$installed, "logical")
  expect_type(res$version, "character")
  expect_type(res$version_local, "character")
  expect_s3_class(res$created, "POSIXct")
  expect_s3_class(res$modified, "POSIXct")
  expect_s3_class(res$modified_local, "POSIXct")
})

# Test 3: Fallback if no internet

test_that("list_datasets warns and falls back to offline if no internet", {
  skip_on_cran()
  skip_if(httr2::is_online(), "Internet available")

  expect_warning(
    res <- list_datasets(online = TRUE),
    "No internet connection detected. Running in offline mode."
  )

  expect_s3_class(res, "data.frame")
})
