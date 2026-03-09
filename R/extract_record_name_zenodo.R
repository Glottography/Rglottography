#' Extract the repository name from a Zenodo record
#'
#' Given a data frame representing metadata on files in a
#' Zenodo record (typically stored inside a list-column), search the
#' character column `key` for entries containing the string
#' "Glottography" (case-insensitive). The first matching entry is used
#' and the repository name is extracted by removing the fixed prefix
#' "Glottography/" and the versioned ".zip" suffix.
#'
#' @param files_df A data frame containing a character column named `key`.
#' @return A length-1 character vector containing the record name.
#' @keywords internal
#' @noRd
.extract_record_name_zenodo <- function(files_df) {

  keys <- files_df$key
  hits <- keys[grepl("Glottography", keys, ignore.case = TRUE)]

  # Take only the first hit
  name_plus_ext <- hits[1]

  # Remove prefix and versioned suffix
  name <- sub("^Glottography/", "", name_plus_ext)
  sub("-v[0-9.]+\\.zip$", "", name)
}


