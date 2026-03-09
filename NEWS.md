# Rglottography 1.1.1

## Bug fixes

* Minor bug fixes.

# Rglottography 1.1.0

## Improvements

* Added a faster download pipeline for Glottography datasets.
* When a matching dataset version is available on GitHub, the package now downloads it from there instead of Zenodo, significantly improving download speed.

# Rglottography 1.0.0

## Initial release

* First public release of **Rglottography**.
* Provides programmatic access to *Glottography*, an online repository of geospatial speaker-area polygons for the world’s languages.
* Functions to:

  * list available datasets
  * download datasets from Zenodo
  * load them as standard spatial (`sf`) objects in R.
