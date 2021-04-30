#' Change color and remove label of features of interest
#'
#' \code{modify_nodes} modifies nodes of features of interest by assigning
#' user specified colors to these nodes and "grey" to the others and removing
#' labels from all nodes but those of interest. The idea and logic of this came
#' from the \code{change_STRING_colors.py} from STRING \href{https://string-db.org/}{website}.
#'
#' @param nodes_set A \code{xml_nodeset} as defined in \code{xml2}.
#' @param colors_vec A named character vector of colors for feature of interest.
#'
#' @return
#' @import xml2
#'
#' @examples
#' feature_of_int <- c("ATAD1", "BCL2L14", "MFGE8", "IDO1", "ABCA1")
#' colors_vec <- rep("rgb(101,226,11)", length(feature_of_int))
#' names(colors_vec) <- feature_of_int
#'
#' todo
#' - example code for the function
#' - unit test
modify_nodes <- function(nodes_set, colors_vec) {
  text_color <- c("rgb(0,0,0)", "black")
  colors_list <- NULL
  nodes_of_int_index <- NULL
  for (i in seq_along(nodes_set)) {
    n <- nodes_set[i]
    for (inner_n in xml_children(n)) {
      if (xml_name(inner_n) == "text" &&
          stringr::str_trim(xml_attr(inner_n, "fill")) %in% text_color) {
        feature = xml_text(inner_n)
        if (feature %in% names(colors_vec)) {
          colors_list[feature] = colors_vec[feature] # <- molecules of int assign some colors
          nodes_of_int_index[i] <- i
        } else {
          colors_list[feature] = "rgb(100,100,100)" # <- other molecules all grey
        }
      }
    }
  }
  if (isFALSE(all(names(colors_vec) %in% names(colors_list)))) {
    warning(
      paste(
        paste(mol_of_int[!mol_of_int %in% names(colors_list)], collapse = ", "),
        "are not present in the STRING network. Please check for typo or misspelling of feature names."
      )
    )
  }
  # return(list(colors_list, nodes_of_int_index))
  # assign colors to nodes set
  for (i in seq_along(nodes_set)) {
    n <- nodes_set[i]
    color = colors_list[[i]]
    for (inner_n in xml_children(n)) {
      if (stringr::str_trim(xml_attr(inner_n, "class")) %in% "nwbubblecoloredcircle") {
        xml_set_attr(inner_n, "fill", color)
      }
      # to remove labels for all nodes other than molecules of interest
      if (is.na(nodes_of_int_index[i])) {
        if (xml_name(inner_n) == "text") {
            xml_remove(inner_n)
        }
      }
    }
  }
  return(nodes_set)
}

