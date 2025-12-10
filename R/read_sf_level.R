#' Load and preprocess a spatial data file for a specific aggregation level
#'
#' Reads an `sf` object from a GeoJSON file, adds dataset and segment information,
#' drops and renames columns, optionally merges metadata, and restores tibble functionality.
#'
#' @param file_path character. Path to the GeoJSON file to read.
#' @param segment character. Name of the segment (or NA if single segment).
#' @param dataset character. Name of the dataset.
#' @param keep_cols character vector of column names to retain from the object.
#' @param rename_cols named character vector specifying columns to rename.
#'   Names are the original column names, values are the new names.
#' @param metadata data frame, optional. Metadata to merge into the spatial object.
#' @param metadata_level character, optional. The level of metadata to merge
#'   (e.g., `"language"` or `"family"`). If `NULL`, no metadata is merged.
#'
#' @return An `sf` object with the following modifications:
#'   - Added `segment` and `dataset` columns.
#'   - Specified columns dropped.
#'   - Specified columns renamed.
#'   - Optional metadata merged and `Feature_IDs` renamed to `feature_ids`.
#'   - Converted to a tibble for improved printing and tidyverse compatibility.
#'
#' @keywords internal
#' @noRd
#'
.read_sf_level <- function(file_path, segment, dataset, keep_cols = NULL,
                           rename_cols = NULL, metadata = NULL, metadata_level = NULL) {
  obj <- sf::read_sf(file_path, quiet = TRUE)
  obj <- sf::st_zm(obj, drop = TRUE, what = "ZM")

  # Add basic columns
  obj$segment <- segment
  obj$dataset <- dataset

  # Drop unused columns
  if (!is.null(keep_cols)) {

    obj <- obj[, intersect(keep_cols, names(obj))]
  }

  # Rename columns
  if (!is.null(rename_cols)) {
    for (old in names(rename_cols)) {
      names(obj)[names(obj) == old] <- rename_cols[[old]]
    }
  }

  # Merge metadata if provided
  if (!is.null(metadata) && !is.null(metadata_level)) {
    meta_subset <- metadata[metadata$Glottolog_Languoid_Level == metadata_level,
                            c("ID", "Feature_IDs")]
    obj <- merge(obj, meta_subset, by.x = "glottocode", by.y = "ID", all.x = TRUE)
    names(obj)[names(obj) == "Feature_IDs"] <- "feature_ids"
  }

  # Restore tibble functionality
  sf::st_as_sf(tibble::as_tibble(obj), sf_column_name = "geometry")
}
