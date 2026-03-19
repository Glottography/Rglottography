## Rglottography 1.2.0

### Improvements
- Added `set_cache_dir()` to allow users to change the default cache location for downloads.
- Minor documentation improvements and bug fixes.

## Rglottography 1.1.1

### Bug Fixes
- Small corrections to Roxygen documentation.

## Rglottography 1.1.0

### Improvements
- Added a faster download pipeline for Glottography datasets.
- When a matching dataset version is available on GitHub, the package now downloads it from there instead of Zenodo, significantly improving download speed.

## Rglottography 1.0.0

### Initial release
- First public release of **Rglottography**.
- Provides programmatic access to Glottography, an online repository of geospatial speaker-area polygons for the world’s languages.
- Functions to:
  - list available datasets
  - download datasets from Zenodo
  - load them as standard spatial (`sf`) objects in R.
