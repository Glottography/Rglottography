#' Set cache directory for Rglottography
#'
#' Sets the cache directory used by Rglottography for storing datasets and
#' the registry. Optionally, existing cache files from the current cache
#' directory can be copied to the new location and removed from the old.
#'
#' @param path Character string specifying the path to the new cache directory.
#' @param copy_existing Logical; if \code{TRUE}, copies existing cache files
#'   from the current to the new cache directory. Defaults to \code{TRUE}.
#' @param remove_old Logical; if \code{TRUE}, deletes cache files from old cache.
#'   Defaults to \code{FALSE}.
#'
#' @return Invisibly returns the path to the new cache directory. Sets the
#'   option \code{"Rglottography.cache_dir"} for the current session.
#'
#' @export
set_cache_dir <- function(path, copy_existing = TRUE, remove_old = FALSE) {
  current <- .get_cache_path()

  registry_file <- "registry.json"
  has_content <- file.exists(file.path(current, registry_file))

  # Normalise input for reliable comparison
  path <- normalizePath(path, winslash = "/", mustWork = FALSE)

  if (remove_old && !copy_existing) {
    cli::cli_abort(c(
      "!" = "Existing cache would be deleted without being copied.",
      "i" = "Set {.code copy_existing = TRUE} or {.code remove_old = FALSE}."
    ))
  }

  if (identical(path, current)) {
    cli::cli_abort(c(
      "x" = "The current cache directory and the new path are identical.",
      "i" = "No changes were made. Please provide a different path if you want to relocate the cache."
    ))
  }

  # Ensure target directory exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  if (has_content) {
    registry <- .get_registry(sync = FALSE)

    current_datasets <- registry$name[registry$install]
    current_files <- file.path(current, c(current_datasets, registry_file))

    if (copy_existing) {
      file.copy(from = current_files, to = path, recursive = TRUE)
      cli::cli_inform("Existing cache copied from {.path {current}} to {.path {path}}.")
    } else {
      cli::cli_warn(c(
        "A cache directory already exists at: {.path {current}}",
        "i" = "Existing files were not copied.",
        "!" = "You may need to re-download datasets."
      ))
    }
    if (remove_old) {
      unlink(current_files, recursive = TRUE)
      cli::cli_inform("Old cache files removed from {.path {current}}.")
    } else {
      cli::cli_inform("Old cache remains at {.path {current}}.")
    }
  }

  options(Rglottography.cache_dir = path)

  cli::cli_bullets(c(
    "Cache directory set for this session only.",
    "i" = "To make this permanent, add the following to your {.file .Rprofile}:",
    "*" = "options(Rglottography.cache_dir = \"{path}\")",
    "i" = "You can open your {.file .Rprofile} with usethis::edit_r_profile()"
  ))

  invisible(path)
}
