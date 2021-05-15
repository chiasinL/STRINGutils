
<!-- README.md is generated from README.Rmd. Please edit that file -->

# STRINGutils

<!-- badges: start -->
<!-- badges: end -->

STRINGutils provides additional utilities for
[STRINGdb](https://www.bioconductor.org/packages/release/bioc/html/STRINGdb.html)
such as getting SVG file of STRING network and highlighting features of
interest.

## Installation

You can install STRINGutils with:

``` r
devtools::install_github("chiasinL/STRINGutils")
```

## Quick demo

For more thorough walkthrough of the package, please see the
[vignette](./vignettes/STRINGutils_Vignette.html).

Getting SVG file of STRING network:

``` r
library(STRINGutils)
svg <- get_svg(string_db, hits, file = "my_network.svg")
```

<img src="man/figures/README-view_svg1-1.png" width="80%" />

If we have a list of proteins of interest, the **full** or **sub-**
STRING network of the proteins can be obtained. These proteins will be
highlighted by the colors of choice.

For full network:

``` r
plot_features(example1_mapped, colors_vec, string_db, entire = TRUE)
```

<img src="man/figures/README-view_svg2-1.png" width="80%" />

For subnetwork:

``` r
plot_features(example1_mapped, colors_vec, string_db)
```

<img src="man/figures/README-view_svg3-1.png" width="80%" />
