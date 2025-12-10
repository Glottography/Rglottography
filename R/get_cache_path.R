#' Get the file path to the local Rglottoraphy cache directory
#' create directory, if it doesn't exist
#'
#' @return the file.path to the local cache directory
#' @keywords internal
#' @noRd

.get_cache_path <- function(){
  cache_dir <- tools::R_user_dir("Rglottography", "data")
  if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)
  return(cache_dir)
}
