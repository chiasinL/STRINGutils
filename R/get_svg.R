#' Get a network SVG file from STRING website
#'
#' \code{get_svg} is a modified version of \code{STRINGdb}'s \code{get_png}. It returns a SVG image of a STRING network with the given identifiers.
#'
#' @param string_db An instantiated STRINGdb reference class. See \code{\link[STRINGdb]{STRINGdb-class}}.
#' @param string_ids A vector of STRING IDs.
#' @param required_score An integer. The minimum STRING combined score of the interactions.
#' @param network_flavor One of "evidence", "confidence", "actions",
#'     specify the flavor of the network
#' @param file Optional. Specify the file for the image.
#' @param payload_id Optional. See Payload Mechanism in \code{STRINGdb}'s \href{https://www.bioconductor.org/packages/release/bioc/vignettes/STRINGdb/inst/doc/STRINGdb.pdf}{vignette}.
#'
#' @return Return a XML document and a SVG file if \code{file} is specified.
#' @importFrom magrittr "%>%"
#' @importClassesFrom STRINGdb "STRINGdb-class"
#' @export
#'
#' @examples
#' # save the XML document in a variable for downstream manipulation
#' xml <- get_svg(string_db, string_ids)
#'
#' # print a SVG file
#' get_svg(string_db, string_ids, file = "my_network.svg")
#'
get_svg <- function(string_db, string_ids, required_score = NULL,
                    network_flavor = c("evidence", "confidence", "actions"),
                    file = NULL, payload_id = NULL) {
  if (length(string_ids) > 2000) {
    cat("ERROR: We do not support lists with more than 2000 genes.\nPlease
        reduce the size of your input and rerun the analysis. \t")
    stop()
  }
  if (is.null(required_score)) required_score <- string_db$score_threshold
  string_ids <- unique(string_ids)
  string_ids <- string_ids[!is.na(string_ids)]
  urlStr <- paste(string_db$stable_url, "/api/svg/network", sep = "")
  identifiers <- ""
  for (id in string_ids) {
    identifiers <- paste(identifiers, id, sep = "%0d")
  }
  params <- list(
    required_score = required_score,
    network_flavor = network_flavor, identifiers = identifiers,
    species = string_db$species, caller_identity = "STRINGdb-package"
  )
  if (!is.null(payload_id)) params["internal_payload_id"] <- payload_id
  img <- STRINGdb:::postFormSmart(urlStr, .params = params) %>%
    xml2::read_xml()
  if (!is.null(file)) xml2::write_xml(img, file)
  return(img)
}
