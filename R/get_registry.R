#' Retrieve the (synced) local registry
#'
#' Reads the local registry file containing metadata about all available Glottography datasets.
#' If sync = TRUE, the registry is updated by syncing with the online Zenodo repository.
#'
#' @param sync Logical; if TRUE, ensures that the local registry is synced with Zenodo.
#'   Defaults to FALSE.
#' @return A data.frame containing the local registry with dataset metadata.
#' @keywords internal
#' @noRd
#'
.get_registry <- function(sync = TRUE) {

  # Get registry file path
  registry_path <- .get_registry_path()

  # Initialise or load local registry
  if (!file.exists(registry_path)) {
    local_registry <- .initialise_registry()
  } else {
    local_registry <- .read_registry()
  }

  # Download, sync, and write registry
  if (isTRUE(sync)) {

    # Download the latest version from Zenodo
    zenodo_registry <- .build_registry()

    # Sync local data with Zenodo data
    synced_registry <- .sync_registry(local_registry, zenodo_registry)

    # Write synced registry to file and return
    .write_registry(synced_registry)
    synced_registry

  } else {
    local_registry
  }
}
