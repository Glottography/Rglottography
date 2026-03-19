## Resubmission

This is a resubmission. I addressed all issues below.

* Issue 1: Please use only undirected quotation marks in the description text. e.g. sf --> 'sf'  
  Fix: I replaced backticks with single quotation marks in the description.

* Issue 2: Please provide a link to the used webservices to the description field of your DESCRIPTION file in the form <http:...> or <https:...> with angle brackets for auto-linking and no space after 'http:' and 'https:'.
  Fix: I added the following paragraph to the description: "Data are sourced
  from the Glottography organization on GitHub <https://github.com/Glottography>
  and the Glottography community on Zenodo <https://zenodo.org/communities/glottography>."

* Issue 3: Please ensure that your functions do not write by default or in your examples/vignettes/tests in the user's home filespace (including the package directory and getwd()). This is not allowed by CRAN policies. Please omit any default path in writing functions. In your examples/vignettes/tests you can write to tempdir(). 
  Fix: This issue was addressed in two ways: 
  1) The vignettes no longer use wrapper functions to download data from the `rnaturalearth` package. Instead, they now use the CRAN-approved `rnaturalearth::ne_download()` function directly. 
  2) The default cache uses `tools::R_user_dir("Rglottography", "data")`, which is CRAN compliant. A new
  function `set_cache_dir()` allows users to set a custom cache location.

## Test environments

- Local: Ubuntu, R 4.5.1  
- Win-builder: R-devel  
- GitHub Actions:  
  - windows-latest (release)  
  - macos-latest (release)  
  - ubuntu-latest (devel)  
  - ubuntu-latest (release)  
  - ubuntu-latest (oldrel-1)  
- R-hub: Linux (R-devel)


## R CMD CHECK results
0 errors | 0 warnings | 2 note

## Notes
- "Maintainer" note is expected for CRAN submissions.
- "unable to verify current time" is caused by the check environment 
  being unable to reach a time server. This is unrelated to the package.
  
