#' Initialise a local registry from registry shipped with Rglottography
#'
#' Initialises the local registry, which contains metadata on all available
#' datasets on Glottography including their current local status.
#'
#' @return the local registry as data.frame
#' @keywords internal
#' @noRd
.initialise_registry <- function(){

  registry <- .read_registry(package = TRUE)

  # Write registry to a local file
  .write_registry(registry)

  return(registry)

}
