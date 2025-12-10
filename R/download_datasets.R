#' Download datasets and update the registry
#'
#' The function downloads specified Glottography datasets from Zenodo,
#' updates the registry and writes the updated registry to disk.
#'
#' @param datasets Character. Names of the datasets to download.
#' @param registry A data.frame representing the registry.
#' @return Invisibly returns NULL.
#' @keywords internal
#' @noRd
.download_datasets <- function(datasets, registry) {

  idx <- match(datasets, registry$name)
  concept_dois <- registry$concept_doi[idx]

  # Download datasets
  local_paths <- mapply(.fetch_dataset, datasets,
                        concept_dois, SIMPLIFY = FALSE)

  # Update registry
  updated_registry <- .update_registry(registry, datasets,
                                       local_paths)
  .write_registry(updated_registry)
  invisible(NULL)
}
