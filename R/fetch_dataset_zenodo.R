#' Fetch a dataset from Zenodo (internal helper)
#'
#' @param name name of the Glottography dataset
#' @param download_url URL pointing to the zip file on Zenodo
#'
#' @return todo
#' @keywords internal
#' @noRd

fetch_dataset_zenodo <- function(download_url,
                                 name) {
  # Move next two lines higher up?
  cache_dir <- tools::R_user_dir("Rglottography", "data")

  if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)
  zip_file <- paste0(name, ".zip")
  zip_path <- file.path(cache_dir, zip_file)

  # Download, unzip, delete
  utils::download.file(download_url, zip_path, mode = "wb", quiet = TRUE)
  utils::unzip(zip_path, exdir = cache_dir)
  unlink(zip_path)

}
