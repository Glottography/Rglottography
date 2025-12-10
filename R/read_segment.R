#' Load a segment of a Glottography dataset
#'
#' Reads spatial and tabular data for a single segment of a Glottography dataset,
#' returning only the requested levels of aggregation.
#'
#' @param segment character. Name of the segment, or NA if there is only a single segment.
#' @param path character. Path to the directory containing the segment's files.
#' @param dataset character. Name of the dataset.
#' @param level character vector specifying which levels of aggregation to load:
#'   - `"features"`: speaker areas according to the original source classification
#'   - `"languages"`: areas aggregated at the Glottolog language level
#'   - `"families"`: areas aggregated at the Glottolog family level
#'
#' @return A list containing:
#'   - `features`: an `sf` object or `NULL`
#'   - `languages`: an `sf` object or `NULL`
#'   - `families`: an `sf` object or `NULL`
#'   - `sources`: a `bibentry` object from `sources.bib`
#'
#' @keywords internal
#' @noRd
#'
.read_segment <- function(segment, path, dataset, level) {

  # Load metadata only if needed
  metadata <- NULL
  if ("languages" %in% level | "families" %in% level) {
    path_metadata <- file.path(path, "languages.csv")
    metadata <- utils::read.csv(path_metadata, stringsAsFactors = FALSE)
  }

  # Features
  features <- if ("features" %in% level) {
    .read_sf_level(
      file.path(path, "features.geojson"),
      segment, dataset,
      keep_cols = c("name", "year", "map_name_full", "id",
                    "number_legend", "cldf:languageReference"),
      rename_cols = c("cldf:languageReference" = "glottocode")
    )
  } else NULL

  # Languages
  languages <- if ("languages" %in% level) {
    .read_sf_level(
      file.path(path, "languages.geojson"),
      segment, dataset,
      keep_cols = c("familiy", "feature_ids", "cldf:languageReference", "title"),
      rename_cols = c("cldf:languageReference" = "glottocode",
                      "title" = "name"),
      metadata = metadata,
      metadata_level = "language"
    )
  } else NULL

  # Families
  families <- if ("families" %in% level) {
    .read_sf_level(
      file.path(path, "families.geojson"),
      segment, dataset,
      keep_cols = c("feature_ids", "cldf:languageReference", "title"),
      rename_cols = c("cldf:languageReference" = "glottocode",
                      "title" = "name"),
      metadata = metadata,
      metadata_level = "family"
    )
  } else NULL

  # Sources
  path_sources <- file.path(path, "sources.bib")
  sources <- bibtex::read.bib(path_sources)

  # Return list without metadata
  list(
    features  = features,
    languages = languages,
    families  = families,
    sources   = sources
  )
}
