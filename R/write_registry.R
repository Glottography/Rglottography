#' Write the registry to a local JSON file
#'
#' Converts a registry data.frame to JSON and writes it to the
#' registry path returned by `.get_registry_path()`. Missing values
#' are encoded as `null`, the output is pretty-printed, and vectors
#' are not automatically unboxed.
#'
#' @param registry A data.frame representing the registry.
#'
#' @return Invisibly returns `NULL`. Called for its side effect of
#'   writing the registry to disk.
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

