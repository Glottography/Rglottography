#' Extract GitHub identifier from related identifiers in a Zenodo record
#'
#' Given a data frame representing metadata on related identifiers in a
#' Zenodo record (typically stored inside a list-column), search the
#' character column `identifier` for entries containing the string
#' "github" (case-insensitive). The first matching identifier is returned.
#' If the input is NULL, empty, lacks an `identifier` column, or contains
#' no matching entries, NA_character_ is returned.
#'
#' @param identifiers_df A data frame containing a character column
#'   named `identifier`.
#' @return A length-1 character vector containing the first matching
#'   GitHub identifier, or NA_character_ if no match is found.
#' @keywords internal
#' @noRd
.extract_github_identifiers_zenodo <- function(identifiers_df) {

  if (is.null(identifiers_df) ||
      nrow(identifiers_df) == 0 ||
      !"identifier" %in% names(identifiers_df)) {
    return(NA_character_)
  }

  identifiers <- identifiers_df$identifier
  hits <- identifiers[grepl("github", identifiers, ignore.case = TRUE)]

  if (length(hits)) hits[1] else NA_character_
}
