library(testthat)
library(Rglottography)

# Test 1: Invalid levels

test_that("load_datasets rejects invalid levels", {
  expect_error(
    load_datasets(level = "invalid"),
    regexp = "one of",
    class = "error"
  )
})

# Test 2: Return class and structure

test_that("load_datasets returns a glottography_collection", {
  skip_on_cran()
  skip_if_not_installed("mockery")

  mockery::stub(load_datasets, ".get_load_instructions", function(...) "ds1")
  mockery::stub(load_datasets, ".get_registry", function(...) data.frame())
  mockery::stub(load_datasets, ".read_dataset", function(...) list())
  mockery::stub(load_datasets, ".combine_parts", function(...) list())
  mockery::stub(load_datasets, ".as_glottography", function(x) {
    structure(x, class = "glottography_collection")
  })

  res <- load_datasets()

  expect_s3_class(res, "glottography_collection")
})

# Test 3: Level Handling

test_that("load_datasets passes selected levels to readers", {
  skip_on_cran()
  skip_if_not_installed("mockery")

  called_levels <- NULL

  mockery::stub(load_datasets, ".get_load_instructions", function(...) "ds1")
  mockery::stub(load_datasets, ".get_registry", function(...) data.frame())
  mockery::stub(load_datasets, ".read_dataset", function(..., level) {
    called_levels <<- level
    list()
  })
  mockery::stub(load_datasets, ".combine_parts", function(...) list())
  mockery::stub(load_datasets, ".as_glottography", function(x) x)

  load_datasets(level = c("features", "languages"))

  expect_equal(called_levels, c("features", "languages"))
})

# Test 4: Dataset naming consistency

test_that("load_datasets names datasets correctly", {
  skip_on_cran()
  skip_if_not_installed("mockery")

  mockery::stub(load_datasets, ".get_load_instructions", function(...) c("a", "b"))
  mockery::stub(load_datasets, ".get_registry", function(...) data.frame())
  mockery::stub(load_datasets, ".read_dataset", function(...) list())
  mockery::stub(load_datasets, ".combine_parts", function(datasets, ...) datasets)
  mockery::stub(load_datasets, ".as_glottography", function(x) x)

  res <- load_datasets()

  expect_named(res, c("a", "b"))
})

# Test 4: Sync registry

test_that("load_datasets passes sync_registry to registry loader", {
  skip_on_cran()
  skip_if_not_installed("mockery")

  sync_used <- NULL

  mockery::stub(load_datasets, ".get_load_instructions", function(...) "ds")
  mockery::stub(load_datasets, ".get_registry", function(sync) {
    sync_used <<- sync
    data.frame()
  })
  mockery::stub(load_datasets, ".read_dataset", function(...) list())
  mockery::stub(load_datasets, ".combine_parts", function(...) list())
  mockery::stub(load_datasets, ".as_glottography", function(x) x)

  load_datasets(sync_registry = TRUE)

  expect_true(sync_used)
})

