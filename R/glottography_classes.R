#' Construct a Glottography polygon object
#'
#' Internal constructor for Glottography polygon datasets. Performs
#' shared validation for all polygon-based Glottography objects.
#'
#' @param x An `sf` object with polygon geometries.
#'
#' @return An object of class `glottography_polygons`.
#'
#' @keywords internal
#' @noRd
#'
.new_glottography_polygons <- function(x) {

  if (!inherits(x, "sf")) {
    cli::cli_abort("`x` must be an sf object", envir = parent.frame())
  }

  required <- c("name", "glottocode", "dataset")
  missing <- setdiff(required, names(x))
  if (length(missing)) {
    cli::cli_abort("Missing required columns: ",
         paste(missing, collapse = ", "), envir = parent.frame())
  }

  geom_types <- sf::st_geometry_type(x)
  if (!all(geom_types %in% c("POLYGON", "MULTIPOLYGON"))) {
    cli::cli_abort(
      "Geometry must be POLYGON or MULTIPOLYGON; found: ",
      paste(unique(geom_types), collapse = ", "), envir = parent.frame())
  }

  structure(
    x,
    class = c("glottography_polygons", class(x))
  )
}

#' Construct a Glottography features object
#'
#' Internal constructor for Glottography features datasets.
#'
#' @param x An `sf` object with polygon geometries.
#'
#' @return An object of class `glottography_polygons`.
#'
#' @keywords internal
#' @noRd
#'
#'
.new_glottography_features <- function(x) {
  x <- .new_glottography_polygons(x)

  required <- c("year", "map_name_full", "id")
  missing <- setdiff(required, names(x))
  if (length(missing)) {
    cli::cli_abort("Missing required columns: ",
                   paste(missing, collapse = ", "), envir = parent.frame())
  }

  structure(
    x,
    class = c("glottography_features", class(x))
  )
}

#' Construct a Glottography languages object
#'
#' Internal constructor for Glottography languages datasets.
#'
#' @param x An `sf` object with polygon geometries.
#'
#' @return An object of class `glottography_languages`.
#'
#' @keywords internal
#' @noRd
#'
#'
.new_glottography_languages <- function(x) {
  x <- .new_glottography_polygons(x)
  required <- c("feature_ids", "family")
  missing <- setdiff(required, names(x))
  if (length(missing)) {
    cli::cli_abort("Missing required columns: ",
                   paste(missing, collapse = ", "), envir = parent.frame())
  }

  structure(
    x,
    class = c("glottography_languages", class(x))
  )
}

#' Construct a Glottography families object
#'
#' Internal constructor for Glottography families datasets.
#'
#' @param x An `sf` object with polygon geometries.
#'
#' @return An object of class `glottography_families`.
#'
#' @keywords internal
#' @noRd
#'
#'
.new_glottography_families <- function(x) {
  x <- .new_glottography_polygons(x)
  required <- c("feature_ids")
  missing <- setdiff(required, names(x))
  if (length(missing)) {
    cli::cli_abort("Missing required columns: ",
                   paste(missing, collapse = ", "), envir = parent.frame())
  }

  structure(
    x,
    class = c("glottography_families", class(x))
  )
}

#' Construct a Glottography sources object
#'#'
#' @param x An `sf` object with polygon geometries.
#'
#' @return An object of class `glottography_sources`.
#'
#' @keywords internal
#' @noRd
#'
#'
#'
.new_glottography_sources <- function(x) {
  if (!is.list(x)) {
    cli::cli_abort("`x` must be a list.", envir = parent.frame())
  }

  structure(
    x,
    class = c("glottography_sources", "list")
  )
}

#' Construct a Glottography collection object
#'#'
#' @param features A Glottography features object or NULL
#' @param languages A Glottography languages object or NULL
#' @param families A Glottography languages object or NULL
#' @param sources A Glottography sources object or NULL
#'
#' @return An object of class `glottography_collection`.
#'
#' @keywords internal
#' @noRd
#'
#'
#
.new_glottography_collection <- function(features = NULL,
                                         languages = NULL,
                                         families = NULL,
                                         sources = NULL) {
  comps <- list(
    features  = list(obj = features, class = "glottography_features"),
    languages = list(obj = languages, class = "glottography_languages"),
    families  = list(obj = families, class = "glottography_families"),
    sources   = list(obj = sources, class = "glottography_sources")
  )

  for (name in names(comps)) {
    obj <- comps[[name]]$obj
    cls <- comps[[name]]$class
    if (!is.null(obj) && !inherits(obj, cls)) {
      cli::cli_abort("`{name}` must be a {cls} object", envir = parent.frame())
    }
  }

  out <- list(
    features  = features,
    languages = languages,
    families  = families,
    sources   = sources
  )

  out <- out[!vapply(out, is.null, logical(1))]
  structure(out, class = c("glottography_collection", "list"))
}


#' Convert a list into a Glottography collection
#'
#' Internal helper to coerce a list containing features, languages,
#' families, and sources into a validated `glottography_collection` object.
#'
#' @param collection A named list with optional elements: `features`,
#'   `languages`, `families`, and `sources`.
#'
#' @return A validated `glottography_collection` object containing
#'   appropriate subclassed elements.
#'
#' @keywords internal
#' @noRd
#'
.as_glottography <- function(collection) {
  if (!is.null(collection$features)){
    features <- .new_glottography_features(collection$features)
  } else features <- NULL
  if (!is.null(collection$languages)){
    languages <- .new_glottography_languages(collection$languages)
  } else languages <- NULL
  if (!is.null(collection$families)){
    families <- .new_glottography_families(collection$families)
  } else families <- NULL
  if (!is.null(collection$sources)){
    sources <- .new_glottography_sources(collection$sources)
  } else sources <- NULL
  return(.new_glottography_collection(features, languages,
                                      families, sources))
}

