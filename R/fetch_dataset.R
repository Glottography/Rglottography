#' Fetch a dataset from GitHub or Zenodo
#'
#' Download a Glottography dataset from GitHub (if available) or alternatively
#' from Zenodo using the provided repository URL or concept DOI. The dataset
#' is cached locally and its contents are extracted. If downloading from
#' Zenodo, the function handles unzipping and cleanup of temporary files
#' automatically.
#'
#' @param dataset Character. Name of the Glottography dataset.
#' @param github_repository Character. GitHub repository URL.
#' @param concept_doi Character. Concept DOI identifying the
#'   dataset on Zenodo.
#'
#' @return A data frame listing the original segment names and the
#'   corresponding local folder paths where files were copied.
#'
#' @keywords internal
#' @noRd

.fetch_dataset <- function(dataset, github_repository, concept_doi) {

  cache_dir <- .get_cache_path()
  data_dir <- file.path(cache_dir, dataset)
  if (!dir.exists(data_dir)) dir.create(data_dir, recursive = FALSE)

  local_paths <- NULL

  # Try downloading the data from GitHub first
  if (!is.na(github_repository)) {
    local_paths <- tryCatch(
      .download_github(github_repository, data_dir),
      error = function(e) NULL
    )
  }

  # If downloading from GitHub fails, use Zenodo instead
  if (is.null(local_paths)) {
    zip_path <- file.path(data_dir, paste0(dataset, ".zip"))
    zenodo_link <- .get_link_zenodo(concept_doi)
    .download_zenodo(zenodo_link$url, zip_path)
    .unzip_zenodo(zip_path, data_dir)
    local_paths <- .extract_cldf_zenodo(data_dir)
  }

  return(local_paths)
}
