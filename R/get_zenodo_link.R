#' Get the download URL, checksum and size for the latest version of a Zenodo dataset
#'
#' Queries the Zenodo API for the latest version of a dataset given its concept DOI,
#' and returns the download URL of the first (and only) file along with its MD5 checksum.
#'
#' @param concept_doi character. The concept DOI of the Zenodo dataset (e.g., "10.5281/zenodo.15287257").
#' @return A list with two elements:
#' - `url`: Character. The download URL of the file.
#' - `md5`: Character. The MD5 checksum of the file.
#' - `size`: Integer. The file size in byte.
#' @keywords internal
#' @noRd
#'
.get_zenodo_link <- function(concept_doi) {
  base_url <- "https://zenodo.org/api/records/"
  query_url <- paste0(base_url, "?q=conceptdoi:", concept_doi,
                      "&sort=mostrecent&size=1")
  request <- httr2::request(query_url)
  response <- httr2::req_perform(request)

  record_json <- httr2::resp_body_string(response)
  record <- jsonlite::fromJSON(record_json,
                               simplifyVector = FALSE)$hits$hits[[1]]

  file <- record$files[[1]]
  url <- file$links$self
  md5  <- file$checksum
  size <- file$size

  return(list(url = url, md5 = md5, size = size))
}
