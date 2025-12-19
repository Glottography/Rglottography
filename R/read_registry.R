#' Read the Rglottography registry file
#'
#' Reads the registry JSON file either from the local cache or from the Rglottography
#' package installation. The registry contains metadata about available resources.
#'
#' @param package logical. If `TRUE`, reads the registry shipped with the package;
#'   if `FALSE`, reads the registry from the local cache.
#' @return A data.frame (or list) containing the registry contents.
#' @keywords internal
#' @noRd
.read_registry <- function(package = FALSE) {

  if (package) {
    # Use the registry included with the installed Rglottography package
    registry_path <- system.file("extdata", "registry.json",
                                 package = "Rglottography")
  } else {
    # Use the registry stored in the local cache
    registry_path <- .get_registry_path()
  }

  registry <- jsonlite::fromJSON(registry_path, simplifyVector = TRUE,
                                 simplifyDataFrame = TRUE,
                                 simplifyMatrix = TRUE)

  # Convert timestamp columns from character to POSIXct
  registry$created <- as.POSIXct(registry$created, tz = "UTC")
  registry$modified <- as.POSIXct(registry$modified, tz = "UTC")
  registry$modified_local <- as.POSIXct(registry$modified_local, tz = "UTC")

  registry
}
