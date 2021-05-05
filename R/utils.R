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
#' @import xml2
#'
#' @examples
#' feature_of_int <- c("ATAD1", "BCL2L14", "MFGE8", "IDO1", "ABCA1")
#' colors_vec <- rep("rgb(101,226,11)", length(feature_of_int))
#' names(colors_vec) <- feature_of_int
#'
# todo
# - example code for the function
# - unit test
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
        paste(names(colors_vec)[!names(colors_vec) %in% names(colors_list)], collapse = ", "),
        "are not present in the STRING network. Please check for typo or misspelling of feature names."
      )
    )
  }

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
}


# A function that extracts a df for features of interest,
# do in the main code?

# todo write documentation below
# find adjacent network, print them then return the sub-network
#' Get subnetwork of features of interest
#'
#'
#'
#' @param all_clusters
#' @param hits_filt
#'
#' @return
#' @export
#'
#' @examples
get_cluster_of_int <- function(all_clusters, hits_filt) {
  features_matched <- NULL
  subnetwork_df <- dplyr::as_tibble() %>%
    tibble::add_column(cluster_index = as.numeric(""),
                       features = "",
                       features_cluster = as.numeric(""))
  # find which clusters our genes of interest belong
  for (i in seq_along(all_clusters)) {
    h <- NULL
    clus <- all_clusters[[i]]
    h <- intersect(clus, hits_filt$STRING_id)
    if (length(h) >= 1) {
      message(paste("Cluster", i, "is a hit"), sep = "\n")
      message(paste(h, collapse = " | "), sep = "\n")
      subnetwork_df <- subnetwork_df %>%
        dplyr::add_row(
          cluster_index = i,
          features = paste(h, collapse = ", "),
          features_cluster = length(clus))
      features_matched <- append(features_matched, h)
    }
  }

  if (isFALSE(all(hits_filt$gene %in% hits_filt$gene[hits_filt$STRING_id %in% features_matched]))) {
    warning(
      paste(
        paste(hits_filt$gene[!hits_filt$gene %in% hits_filt$gene[hits_filt$STRING_id %in% features_matched]], collapse = ", "),
        "are not present in the STRING sub-network."
      )
    )
  }
  return(subnetwork_df)
}
