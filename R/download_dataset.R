#' Download one or several Glottography dataset(s)
#'
#' Checks the status of a dataset in the registry and downloads if not up-to-date
#' @param dataset the name(s) of the dataset(s) to download
#' @param force_update download dataset regardless of its status
#' @export
download_dataset <- function(dataset){
  # 1. Verify that dataset name is valid
  if (is.null(dataset)) {
    stop("Please specify a valid dataset name or use name = 'all' to download all datasets")
  }

  # 2. Locate user cache
  cache_dir <- .get_cache_dir()

  # 3. Get synced and updated registry
  registry <- .get_registry()

  # 4. Download all datasets?
  dataset_to_download <- if (identical(dataset, "all")) registry$names else dataset

  # Loop over datasets to download
  for (ds in dataset_to_download) {

    # check if Glottography dataset exists
    if (.dataset_exists(ds, registry)) {
      warning(paste0("No Glottography dataset named '", ds, "' found. Skipping."))
      next
    }

    # Check if requested dataset has already been downloaded and is up-to-date
    # todo: include force_update
    if (.is_dataset_up_to_date(ds, registry)) {
      warning(paste0("Dataset '", ds, "' is already downloaded and
                     up-to-date. Skipping."))
      next
    }

      # Otherwise
      #    - download dataset from Zenodo
      #    - unpack and remove ZIP file
      #    - update user registry with new dataset info
      #    - name, version, local path, timestamp


  #  Save updated user registry back to cache_dir

  # Optionally return paths to downloaded datasets
}

  datasets <- list_datasets()

  # Check if the registry is up to date


  for (n in name){
    if (!n %in% datasets$name) {
      stop(paste0("There is no Glottography dataset named ", n, "."))
    } else {
      print(paste0("Downloading ", n, " from Zenodo."))


      fetch_dataset_zenodo(download_url, n)
      #update_registry()

    }
  }
  # Check if the dataset exists in the registry






}


