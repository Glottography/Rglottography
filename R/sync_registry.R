#' Sync the local registry with information retrieved from Zenodo
#'
#' Retrieves the local registry file, ensuring that it is
#' properly synced with Zenodo
#' @param local_registry the local registry data.frame
#' @param zenodo_registry the registry built from Zenodo metadata as data.frame
#' @return local registry synced with Zenodo metadata as data.frame
#' @keywords internal
#' @noRd

.sync_registry <- function(local_registry, zenodo_registry){

  missing_datasets <- setdiff(zenodo_registry$concept_id,
                              local_registry$concept_id)

  # check if there are new datasets on Zenodo and add to the local registry
  if (length(missing_datasets) > 0){

    local_registry <- rbind(local_registry,
                            subset(zenodo_registry,
                                   concept_id %in% missing_datasets))
  }

  # When syncing omit columns on the local status and the concept id
  columns_omitted <- c("installed", "version_local",
                       "modified_local", "local_paths",
                       "concept_id")

  # Sync local registry with Zenodo,
  columns_synced <- setdiff(colnames(zenodo_registry), columns_omitted)

  local_registry[, columns_synced] <- zenodo_registry[
    match(local_registry$concept_id, zenodo_registry$concept_id),
    columns_synced]

  return(local_registry)

}
