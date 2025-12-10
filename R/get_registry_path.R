#' Get the file path to the local Rglottography registry file
#'
#' Constructs the full path to "registry.json" inside the local cache directory.
#' The cache directory is created if it doesn't exist.
#'
#' @return the file.path to the local registry file
#' @keywords internal
#' @noRd
#'
.get_registry_path <- function() {
  cache_dir <- .get_cache_path()
  registry_path <- file.path(cache_dir, "registry.json")
}
