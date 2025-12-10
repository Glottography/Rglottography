#' List available Glottography datasets
#'
#' Lists all available Glottography datasets.
#' The function reads the package’s registry file, which contains metadata for all
#' datasets along information on local installation status.
#'
#' If \code{online = TRUE} and an internet connection is available, the function
#' attempts to sync the registry with the Glottography community on Zenodo by
#' updating the local registry. Otherwise, it runs in offline mode and uses
#' the local, unsynced registry.
#'
#' @param online Logical. Should the function attempt to sync the registry with
#'   the online version? Defaults to \code{TRUE}.
#'
#' @return A \code{data.frame} containing metadata and status information for all
#'   Glottography datasets with the following columns:
#'   \itemize{
#'     \item \code{name}: The dataset name. Serves as an identifier.
#'     \item \code{installed}: Logical; whether the dataset is installed locally.
#'     \item \code{created}: The creation date of the dataset on Zenodo.
#'     \item \code{version}: The latest available version online.
#'     \item \code{version_local}: The version currently installed locally.
#'     \item \code{modified}: Timestamp of the most recent online update.
#'     \item \code{modified_local}: Timestamp of the local version.
#'   }
#' @export
list_datasets <- function(online = TRUE) {
  if (online && !httr2::is_online()) {
    cli::cli_warn("No internet connection detected. Running in offline mode.")
    online <- FALSE
  }
  registry <- .get_registry(sync = online)
  cols <- c("name", "installed", "created",
            "version", "version_local", "modified", "modified_local")
  registry[, cols]
}
