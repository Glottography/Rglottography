#' Fetch a dataset from Zenodo
#'
#' This internal helper function downloads a Glottography dataset from Zenodo
#' using the provided concept DOI, caches it locally, and extracts its contents.
#' It handles downloading, unzipping, and cleaning up temporary files automatically.
#'
#' @param dataset Character. Name of the Glottography dataset to fetch.
#' @param concept_doi Character. Immutable concept DOI of the latest version of the dataset on Zenodo.
#'
#' @return A data frame listing the original segment names and the corresponding
#'   local folder paths where files were copied.
#'
#' @keywords internal
#' @noRd

.fetch_dataset <- function(dataset, concept_doi) {

  cache_dir <- tools::R_user_dir("Rglottography", "data")
  data_dir <- file.path(cache_dir, dataset)
  if (!dir.exists(data_dir)) dir.create(data_dir, recursive = FALSE)

  zenodo_link <- .get_zenodo_link(concept_doi)
  zip_path <- file.path(data_dir, paste0(dataset, ".zip"))

  .download_with_timeout(zenodo_link$url, zip_path)

  .unzip_and_cleanup(zip_path, data_dir)
  local_paths <- .extract_cldf_and_cleanup(data_dir)
  local_paths
}
