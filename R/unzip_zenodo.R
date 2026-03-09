#' Unzip a file retrieved from Zenodo and clean up the directory
#'
#' Extracts the contents of a zip file retrieved from Zenodo to a specified
#' directory. Before extraction, any existing files or folders in `data_dir`
#' (except for the zip file itself) are removed.
#' After extraction, the original zip file is deleted.
#'
#' @param zip_path Character. Path to the zip file to be extracted.
#' @param data_dir Character. Directory where the zip contents should be extracted.
#' @return Invisibly returns `NULL`.
#' @keywords internal
#' @noRd

.unzip_zenodo <- function(zip_path, data_dir) {

  all_files <- list.files(data_dir, full.names = TRUE)
  outdated_dataset <- setdiff(all_files, zip_path)

  if (length(outdated_dataset) > 0) {
    unlink(outdated_dataset, recursive = TRUE)
  }

  utils::unzip(zip_path, exdir = data_dir)
  unlink(zip_path)

  invisible(NULL)
}
