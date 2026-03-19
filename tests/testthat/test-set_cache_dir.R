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

test_that("creates cache directory if it does not exist", {
  new_path <- file.path(tempdir(), "new-cache-dir")
  on.exit(unlink(new_path, recursive = TRUE), add = TRUE)

  with_mocked_bindings(
    .get_cache_path = function() normalizePath(tempdir(), winslash = "/", mustWork = FALSE),
    {
      unlink(new_path, recursive = TRUE)
      expect_false(dir.exists(new_path))
      set_cache_dir(new_path, copy_existing = FALSE)
      expect_true(dir.exists(new_path))
    }
  )
})

# Test 4: Sets Rglottography.cache_dir option and returns path

test_that("sets option correctly and returns invisibly", {
  new_path <- file.path(tempdir(), "cache-option-test")
  dir.create(new_path, recursive = TRUE, showWarnings = FALSE)
  new_path <- normalizePath(new_path, winslash = "/", mustWork = FALSE)
  on.exit(unlink(new_path, recursive = TRUE), add = TRUE)

  with_mocked_bindings(
    .get_cache_path = function() normalizePath(tempdir(), winslash = "/", mustWork = FALSE),
    {
      result <- set_cache_dir(new_path, copy_existing = FALSE)
      expect_equal(getOption("Rglottography.cache_dir"), new_path)
      expect_equal(normalizePath(result, winslash = "/", mustWork = FALSE), new_path)
    }
  )
})

# Test 5: Copies existing cache files when enabled

test_that("copies existing cache files when copy_existing = TRUE", {
  current <- normalizePath(tempdir(), winslash = "/", mustWork = FALSE)

  new_path <- file.path(current, "copy-test")
  dir.create(new_path, recursive = TRUE, showWarnings = FALSE)
  new_path <- normalizePath(new_path, winslash = "/", mustWork = FALSE)
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
  current <- normalizePath(tempdir(), winslash = "/", mustWork = FALSE)

  new_path <- file.path(current, "no-copy-test")
  dir.create(new_path, recursive = TRUE, showWarnings = FALSE)
  new_path <- normalizePath(new_path, winslash = "/", mustWork = FALSE)
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
  current <- normalizePath(tempdir(), winslash = "/", mustWork = FALSE)

  new_path <- file.path(current, "remove-old-test")
  dir.create(new_path, recursive = TRUE, showWarnings = FALSE)
  new_path <- normalizePath(new_path, winslash = "/", mustWork = FALSE)
  on.exit(unlink(new_path, recursive = TRUE), add = TRUE)

  registry_file <- file.path(current, "registry.json")
  on.exit(unlink(registry_file), add = TRUE)
  writeLines("{}", registry_file)

  fake_registry <- data.frame(
    name = c("dataset1"),
    install = c(TRUE),
    stringsAsFactors = FALSE
  )
  dataset_path <- file.path(current, "dataset1")
  dir.create(dataset_path, showWarnings = FALSE)
  on.exit(unlink(dataset_path, recursive = TRUE), add = TRUE)

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
  current <- normalizePath(current, winslash = "/", mustWork = FALSE)
  on.exit(unlink(current, recursive = TRUE), add = TRUE)

  new_path <- file.path(tempdir(), "empty-cache-new")
  dir.create(new_path, recursive = TRUE, showWarnings = FALSE)
  new_path <- normalizePath(new_path, winslash = "/", mustWork = FALSE)
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
