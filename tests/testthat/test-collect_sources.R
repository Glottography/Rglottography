library(testthat)
library(Rglottography)

# Test 1: Sources for Glottography collection

test_that("collect_sources returns unique sources from a glottography_collection", {
  x <- structure(
    list(
      sources = list(
        c("ref1", "ref2"),
        c("ref2", "ref3")
      )
    ),
    class = "glottography_collection"
  )

  res <- collect_sources(x)

  expect_type(res, "character")
  expect_setequal(res, c("ref1", "ref2", "ref3"))
})

# Test 2: Function extracts datasets

test_that("collect_sources extracts datasets and reads them", {
  skip_on_cran()
  skip_if_not_installed("mockery")

  mockery::stub(
    collect_sources,
    ".extract_datasets",
    function(x) c("ds1", "ds2")
  )

  mockery::stub(
    collect_sources,
    ".get_registry",
    function(...) data.frame()
  )

  mockery::stub(
    collect_sources,
    ".read_dataset",
    function(...) list(sources = c("a", "b"))
  )

  mockery::stub(
    collect_sources,
    ".extract_sources",
    function(x) list(c("a", "b"), c("b", "c"))
  )

  res <- collect_sources(data.frame(dataset = "ds1"))

  expect_setequal(res, c("a", "b", "c"))
})

# Test 3: No sources exist

test_that("collect_sources returns empty character vector when no sources exist", {
  skip_if_not_installed("mockery")

  mockery::stub(
    collect_sources,
    ".extract_datasets",
    function(x) "ds"
  )
  mockery::stub(
    collect_sources,
    ".get_registry",
    function(...) data.frame()
  )
  mockery::stub(
    collect_sources,
    ".read_dataset",
    function(...) list()
  )
  mockery::stub(
    collect_sources,
    ".extract_sources",
    function(x) list()
  )

  res <- collect_sources(data.frame(dataset = "ds"))

  expect_type(res, "character")
  expect_length(res, 0)
})

# Test 4: Unique sources

test_that("collect_sources always returns unique values", {
  x <- structure(
    list(
      sources = list(c("x", "x", "y"))
    ),
    class = "glottography_collection"
  )

  res <- collect_sources(x)

  expect_identical(sort(res), c("x", "y"))
})
