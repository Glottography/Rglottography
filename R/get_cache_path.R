#' Get the file path to the local Rglottoraphy cache directory
#' create directory, if it doesn't exist
#'
#' @return the file.path to the local cache directory
#' @keywords internal
#' @noRd

.get_cache_path <- function(){
  cache_dir <- getOption("Rglottography.cache_dir",
                         tools::R_user_dir("Rglottography", "data"))
  return(cache_dir)
}
