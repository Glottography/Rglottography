#' Update registry entries for newly installed datasets
#'
#' Marks the specified datasets as installed in the registry and updates their
#' local version and modification timestamps to match the remote metadata.
#'
#' @param registry A data.frame representing the registry.
#' @param installed_datasets Character vector of dataset names that were
#' successfully installed
#' @param local_paths List with local file paths per dataset
#' @return The updated registry data.frame.
#' @keywords internal
#' @noRd
#'
.update_registry <- function(registry, installed_datasets, local_paths){

  idx_datasets <- match(installed_datasets, registry$name)
  registry$installed[idx_datasets] <- TRUE
  registry$version_local[idx_datasets] <- registry$version[idx_datasets]
  registry$modified_local[idx_datasets] <- as.POSIXct(
    registry$modified[idx_datasets],
    origin = "1970-01-01",
    tz = "UTC"
  )

  idx_paths <- match(names(local_paths), registry$name)
  registry$local_paths[idx_paths] <- local_paths

  return (registry)
}
