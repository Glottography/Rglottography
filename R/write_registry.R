#' Write the registry to a local file
#'
#' @param registry the registry as a data.frame
#' @keywords internal
#' @noRd

.write_registry <- function(registry) {

  registry_path <- .get_registry_path()

  # Write registry to file
  json_string <- jsonlite::toJSON(registry, na = "null",
                                  pretty = TRUE,
                                  auto_unbox = FALSE)

  writeLines(json_string, con = registry_path)
  invisible(NULL)
}

