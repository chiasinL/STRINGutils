#' Change color of features of interest and remove labels
#'
#' \code{modify_nodes} modifies nodes of features of interest by assigning
#' user specified colors to these nodes and "grey" to the others and removing
#' labels from all nodes but those of interest. The idea and logic of this came
#' from the \code{change_STRING_colors.py} from STRING \href{https://string-db.org/}{website}.
#'
#' @param xml A \code{xml_document} as defined in \code{xml2}.
#' @param colors_vec A named character vector of colors for feature of interest.
#'
#' @import xml2
#'
#' @examples
#' feature_of_int <- c("VSTM2L","TBC1D2","LENG9","TMEM27","TSPAN1",
#' "TNNC1","MGAM","TRIM22","KLK11","TYROBP")
#' colors_vec <- rep("rgb(101,226,11)", length(feature_of_int))
#' names(colors_vec) <- feature_of_int
#'
# todo
# - example code for the function
# - unit test
modify_nodes <- function(xml, colors_vec) {
  # get relevant nodes, then change color and label
  b <- xml_children(xml)[5]
  nodes_set <- xml_children(b)[5:length(xml_children(b))]

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

#' Get subnetwork of features of interest
#'
#' \code{get_cluster_of_int} finds the clusters that the features of interest belong.
#'
#' @param all_clusters A list of clusters. Generated by \code{STRINGdb}'s method \code{get_clusters}.
#' @param hits_filt A data frame. A filtered data frame of features of interest of the mapped data frame generated by \code{STRINGdb}'s method \code{map}.
#'
#' @return Return a data frame with the information of which cluster the features are found and the number of features in those clusters.
#'
#' @examples
#' \dontrun{
#' # get all clusters from STRING network using get_clusters method of STRINGdb
#' all_clusters <- string_db$get_clusters(hits)
#'
#' get_cluster_of_int(all_clusters, hits_filt)
#' }
get_cluster_of_int <- function(all_clusters, hits_filt) {
  features_matched <- NULL
  subnetwork_df <- dplyr::tibble() %>%
    tibble::add_column(cluster_index = as.numeric(""),
                       features = "",
                       features_cluster = as.numeric(""))

  # find which clusters our features of interest belong
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

  # if features not present in clusters
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
