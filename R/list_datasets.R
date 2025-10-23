#' List available Glottography datasets
#'
#' Reads the local registry of available Glottography datasets and
#' returns a data.frame with metadata such as title, version, and DOI.
#'
#' @return A data.frame containing dataset metadata.
#' @export
list_datasets <- function() {
  registry_path <- system.file("extdata", "registry.json",
                               package = "Rglottography")
  # todo: include update registry
  if (registry_path == "")
    stop("Registry file not found.
         Ensure 'inst/extdata/registry.json' exists in the package.")

  registry <- jsonlite::read_json(registry_path, simplifyVector = TRUE)
  registry <- as.data.frame(registry, stringsAsFactors = FALSE)
  return(registry)
}
