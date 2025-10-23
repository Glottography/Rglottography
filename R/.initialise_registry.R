#' Initialise a local registry from registry shipped with Rglottography
#'
#' The local registry contains metadata about all available datasets on Glottography
#' including their current status on the user's machine (is it downloaded?)
#'
#' @param registry_file file path of the local registry
#' @return todo
#' @keywords internal
#' @noRd
.initialise_registry <- function(registry_file){

  # Read the registry that was shipped with the Rglottography package
  registry_package_file <- system.file("extdata", "registry.json",
                                       package = "Rglottography")

  if (registry_package_file == "")
    stop("Registry file not found.
         Ensure 'inst/extdata/registry.json' exists in the package.")

  registry <- load_registry(registry_package_file)
  # put into write registry file
  .write_registry()
  # Write registry to file
  jsonlite::write_json(registry,
                       path = registry_file,
                       pretty = TRUE, append=FALSE)
  return(registry)

}
