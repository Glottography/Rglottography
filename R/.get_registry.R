#' Get the synced registry file
#'
#' Ensures that the local registry file with metadata on all datasets exists
#' and is properly synced with Zenodo
#'
#' @return synced registry
#' @keywords internal
#' @noRd
.get_registry <- function(){

  cache_dir <- get_cache_dir()
  registry_file <- file.path(cache_dir, "registry.json")

  # initialise or load local registry
  if(!file.exists(registry_file)){
    registry_local <- .initialise_registry(registry_file)
  } else {
    registry_local <- .load_registry(registry_file)
  }

  return(.sync_registry(registry_local))
}
