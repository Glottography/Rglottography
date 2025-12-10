#' Fetch metadata for public Zenodo records from the Glottography community
#'
#' Retrieves metadata for all public datasets from the Glottography Zenodo community,
#' handling pagination automatically. Returns a flattened data frame with one row
#' per record. Only columns specified in `cols_zenodo` are retained; missing
#' columns are filled with `NA`.
#'
#' @param cols_zenodo Character vector specifying which metadata columns to retain
#'   from the Zenodo API response.
#' @param community Character string specifying the Zenodo community ID
#'   (default: `"glottography"`).
#' @param page_size Integer specifying the number of records to request per page
#'   (default: 25; maximum allowed for unauthenticated requests).
#'
#' @return A data frame containing the requested metadata columns for all public
#'   datasets in the specified community. Missing columns are filled with `NA`.
#'
#' @details
#' - Only public datasets are returned. Private or embargoed datasets require
#'   authentication.
#' - This function uses unauthenticated requests; page size is limited to 25 and
#'   rate limits may apply.
#' - Pagination is handled automatically until all records are retrieved.
#' - Column names are taken exactly from `cols_zenodo`; if some are missing in
#'   the API response, they are added as `NA`.
#'
#' @keywords internal
#' @noRd
.fetch_zenodo_community_records <- function(cols_zenodo,
                                            community = "glottography",
                                            page_size = 25){
  records <- list()
  page <- 1

  repeat {
    url <- paste0(
      "https://zenodo.org/api/records?",
      "communities=", community,
      "&all_versions=false&size=", page_size,
      "&page=", page
    )
    request <- httr2::request(url)
    results <- httr2::req_perform(request)
    results_json <- httr2::resp_body_string(results)
    hits <- jsonlite::fromJSON(results_json, flatten = TRUE)$hits$hits

    if ((is.data.frame(hits) && nrow(hits) == 0) ||
        (is.list(hits) && length(hits) == 0)) break

    missing_cols <- setdiff(cols_zenodo, names(hits))

    if(length(missing_cols) > 0) hits[missing_cols] <- NA

    records[[page]] <- hits[cols_zenodo]
    page <- page + 1
  }

  records_df <-  do.call(rbind, lapply(records, as.data.frame))
  return (records_df)

}
