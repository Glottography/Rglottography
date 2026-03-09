#' Download Glottography metadata from Zenodo and build a registry
#'
#' Retrieves all public records from the Glottography Zenodo community, extracts
#' key metadata fields, and builds a registry as a data frame suitable for
#' internal use.
#'
#' @return A data frame containing metadata for all datasets in the Glottography
#'   Zenodo community, including:
#'   - `created`, `modified`: timestamps (POSIXct)
#'   - `concept_id`, `concept_doi`
#'   - `github_repository`
#'   - `title`, `version`, `license`
#'   - `access_rights`, `description`, `status`
#'   - `name`: derived from the zip-file name in each record
#' @keywords internal
#' @noRd
#'
.build_registry <- function(){

  cols_zenodo <- c("created", "modified", "conceptrecid",
                   "conceptdoi", "metadata.related_identifiers",
                   "files", "metadata.title", "metadata.version",
                   "metadata.license.id", "metadata.access_right",
                   "metadata.description", "status")

  cols_registry <- c("created", "modified", "concept_id",
                     "concept_doi", "github_identifiers", "files",
                     "title", "version", "license",
                     "access_rights", "description", "status")

  records <- .fetch_community_records_zenodo(cols_zenodo)


  records <- stats::setNames(records[cols_zenodo], cols_registry)

  records$github_repository <- vapply(
    records$github_identifiers,
    .extract_github_identifiers_zenodo,
    FUN.VALUE = character(1)
  )
  records$github_identifiers <- NULL

  records$name <- vapply(
    records$files,
    .extract_record_name_zenodo,
    FUN.VALUE = character(1)
  )

  records$files <- NULL

  records$created <- as.POSIXct(sub("(\\..*)?(\\+00:00|Z)$", "",
                                    records$created),
                                format="%Y-%m-%dT%H:%M:%S", tz="UTC")


  records$modified <- as.POSIXct(sub("(\\..*)?(\\+00:00|Z)$", "",
                                     records$modified),
                                 format="%Y-%m-%dT%H:%M:%S", tz="UTC")

  records$version <- gsub("[^0-9.]", "", records$version)

  # The remaining columns show the local status of each dataset
  # They are initialised now and updated later
  records$installed <- FALSE
  records$version_local <- NA_character_
  records$modified_local <- as.POSIXct(NA)
  records$local_paths <- replicate(nrow(records),
                                   data.frame(segment = NA_character_,
                                              path = NA_character_),
                                   simplify = FALSE)

  return(records)

}






