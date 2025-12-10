#' Build the initial version of the registry shipped with Rglottography
#'
#' This helper function is used **only during package creation** to generate
#' the initial `registry.json` file included in `inst/extdata`.
#' It downloads the registry, resets some fields, and writes it to the package.
#'
#' @return Invisibly returns `NULL`.
#' @keywords internal
#' @noRd
build_package_registry <- function() {
  cache_dir <- .get_cache_path()
  registry_file <- file.path(cache_dir, "registry.json")

  registry <- .build_registry()
  registry$installed <- FALSE
  registry[c("version_local", "modified_local")] <- list(NA_character_,
                                                         as.POSIXct(NA))

  extdata_path <- file.path("inst", "extdata")
  if (!file.exists(extdata_path)) {
    dir.create(extdata_path, recursive = TRUE)
  }

  .write_registry(registry)

  invisible(NULL)
}

