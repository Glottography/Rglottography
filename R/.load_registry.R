#' Load the registry
#'
#' The registry contains metadata about all available datasets on Glottography
#' including their current status on the users machine (is it downloaded?)
#'
#' @param registry_file file path to the package or local registry
#' @return todo
#' @keywords internal
#' @noRd
#'
.load_registry <- function(registry_file){

  registry_json <- jsonlite::read_json(registry_file, simplifyVector = TRUE)
  registry <- as.data.frame(registry, stringsAsFactors = FALSE)

  return(registry)
}
