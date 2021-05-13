#' A \code{STRINGdb} reference class
#'
#' The reference class is instantiated using STRING version 11, the species Human
#' and an interactions combined score threshold of 200 (see \code{STRINGdb}
#' vignette for more information).
#'
#' @format A \code{STRINGdb} reference class with 14 fields.
#'
#' @source \url{https://www.bioconductor.org/packages/release/bioc/vignettes/STRINGdb/inst/doc/STRINGdb.pdf}
"string_db"

#' Differential gene expression results from \code{STRINGdb}
#'
#' \code{diff_exp_example1} example dataset from \code{STRINGdb}, after mapping
#' gene names to the STRING database identifiers using the \code{map} method.
#'
#' @format A data frame of 17708 rows and 4 columns.
#'
#' @source \url{https://www.bioconductor.org/packages/release/bioc/vignettes/STRINGdb/inst/doc/STRINGdb.pdf}
"example1_mapped"
