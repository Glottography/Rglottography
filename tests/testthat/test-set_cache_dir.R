library(testthat)
library(Rglottography)

# Test 1: Invalid remove and copy

test_that("throws error when remove_old is TRUE and copy_existing is FALSE", {
  expect_error(
    set_cache_dir(tempdir(), copy_existing = FALSE, remove_old = TRUE),
    "Existing cache would be deleted without being copied"
  )
})

# Test 2: Identical cache directory path

test_that("throws error when new path is identical to current cache", {
  old <- normalizePath(tempdir(), winslash = "/", mustWork = FALSE)
  on.exit(options(Rglottography.cache_dir = NULL), add = TRUE)

  options(Rglottography.cache_dir = old)
  with_mocked_bindings(
    .get_cache_path = function() old,
    {
      expect_error(
        set_cache_dir(old),
        "current cache directory and the new path are identical"
      )
    }
  )
})

# Test 3: Creates new cache directory if it does not exist

test_that("sets option correctly and returns invisibly", {
  new_path <- normalizePath(file.path(tempdir(), "cache-option-test"),
                            winslash = "/", mustWork = FALSE)
  on.exit(unlink(new_path, recursive = TRUE), add = TRUE)

  with_mocked_bindings(
    .get_cache_path = function() tempdir(),
    {
      result <- set_cache_dir(new_path, copy_existing = FALSE)
      expect_equal(getOption("Rglottography.cache_dir"), new_path)
      expect_equal(normalizePath(result, winslash = "/", mustWork = FALSE), new_path)
    }
  )
})

# Test 4: Sets Rglottography.cache_dir option and returns path

test_that("sets option correctly and returns invisibly", {
  new_path <- normalizePath(file.path(tempdir(), "cache-option-test"),
                            winslash = "/", mustWork = FALSE)
  with_mocked_bindings(
    .get_cache_path = function() tempdir(),
    {
      result <- set_cache_dir(new_path, copy_existing = FALSE)
      expect_equal(getOption("Rglottography.cache_dir"), new_path)
      expect_equal(normalizePath(result, winslash = "/", mustWork = FALSE), new_path)
    }
  )
})

# Test 5: Copies existing cache files when enabled

test_that("copies existing cache files when copy_existing = TRUE", {
  current <- tempdir()
  new_path <- normalizePath(file.path(tempdir(), "copy-test"),
                            winslash = "/", mustWork = FALSE)
  on.exit(unlink(new_path, recursive = TRUE), add = TRUE)

  registry_file <- file.path(current, "registry.json")
  on.exit(unlink(registry_file), add = TRUE)

  writeLines("{}", registry_file)
  fake_registry <- data.frame(
    name = c("dataset1"),
    install = c(TRUE),
    stringsAsFactors = FALSE
  )
  dir.create(file.path(current, "dataset1"), showWarnings = FALSE)
  on.exit(unlink(file.path(current, "dataset1"), recursive = TRUE), add = TRUE)

  with_mocked_bindings(
    .get_cache_path = function() current,
    .get_registry = function(sync = FALSE) fake_registry,
    {
      set_cache_dir(new_path, copy_existing = TRUE, remove_old = FALSE)
      expect_true(file.exists(file.path(new_path, "registry.json")))
      expect_true(dir.exists(file.path(new_path, "dataset1")))
    }
  )
})

# Test 6: Does not copy existing cache files when disabled

test_that("does not copy files when copy_existing = FALSE", {
  current <- tempdir()
  new_path <- normalizePath(file.path(tempdir(), "no-copy-test"),
                            winslash = "/", mustWork = FALSE)
  on.exit(unlink(new_path, recursive = TRUE), add = TRUE)

  registry_file <- file.path(current, "registry.json")
  on.exit(unlink(registry_file), add = TRUE)

  writeLines("{}", registry_file)
  fake_registry <- data.frame(
    name = c("dataset1"),
    install = c(TRUE),
    stringsAsFactors = FALSE
  )
  dir.create(file.path(current, "dataset1"), showWarnings = FALSE)
  on.exit(unlink(file.path(current, "dataset1"), recursive = TRUE), add = TRUE)

  with_mocked_bindings(
    .get_cache_path = function() current,
    .get_registry = function(sync = FALSE) fake_registry,
    {
      set_cache_dir(new_path, copy_existing = FALSE, remove_old = FALSE)
      expect_false(file.exists(file.path(new_path, "registry.json")))
      expect_false(dir.exists(file.path(new_path, "dataset1")))
    }
  )
})

# Test 7: Removes old cache files when requested

test_that("removes old files when remove_old = TRUE", {
  current <- tempdir()
  new_path <- normalizePath(file.path(tempdir(), "remove-old-test"),
                            winslash = "/", mustWork = FALSE)

  registry_file <- file.path(current, "registry.json")
  writeLines("{}", registry_file)

  fake_registry <- data.frame(
    name = c("dataset1"),
    install = c(TRUE),
    stringsAsFactors = FALSE
  )

  dataset_path <- file.path(current, "dataset1")
  dir.create(dataset_path, showWarnings = FALSE)

  with_mocked_bindings(
    .get_cache_path = function() current,
    .get_registry = function(sync = FALSE) fake_registry,
    {
      set_cache_dir(new_path, copy_existing = TRUE, remove_old = TRUE)

      expect_false(file.exists(registry_file))
      expect_false(dir.exists(dataset_path))
    }
  )
})

# Test 8: Handles empty cache (no datasets, no registry.json)

test_that("works when cache is empty", {
  current <- file.path(tempdir(), "empty-cache")
  dir.create(current, showWarnings = FALSE)
  on.exit(unlink(current, recursive = TRUE), add = TRUE)

  new_path <- normalizePath(file.path(tempdir(), "empty-cache-new"),
                            winslash = "/", mustWork = FALSE)
  on.exit(unlink(new_path, recursive = TRUE), add = TRUE)

  with_mocked_bindings(
    .get_cache_path = function() current,
    {
      result <- set_cache_dir(new_path, copy_existing = TRUE)
      expect_equal(getOption("Rglottography.cache_dir"), new_path)
      expect_equal(normalizePath(result, winslash = "/", mustWork = FALSE), new_path)
    }
  )
})
