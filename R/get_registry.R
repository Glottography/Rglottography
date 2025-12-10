#' Retrieves the (synced) local registry file
#'
#' @return (synced) local registry as data.frame
#' @param sync (logical) ensures that local registry is synced with Zenodo
#' @export
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
