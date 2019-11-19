#' Read UFS function
#'
#' This function allows you to read UFS assignment data into R.
#'
#' @param file The file to read.
#' @param load_geometry it uses satdb to load the geometry and converts the object into a sf
#' @param selection_mode Define how to query the ufs with the options 'all_links'(default), 'simulation_links'
#'  'simulation_turns' or 'centroid_connectors'.
#' @param step how many records to read by iteration, max is 9, use 1 for stability.
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#'
#' @keywords read, ufm
#' @export
#'
read_ufs <- function(file ,
                     clean_up = TRUE, load_geometry = FALSE,
                     selection_mode = "all_links",
                     step = 9){

  P1X <- file.path(get_xexes(),"$P1X.exe")
  export <- list()
  names <- list()
  # Dictionary for p1xdump link selection
  selection_dic <- c(simulation_links = "$SL",
                     all_links = "$L",
                     simulation_turns = "$ST",
                     centroid_connectors = "$CC")
  selection_mode <- selection_dic[selection_mode]
  iterations <- ceiling(nrow(p1xcodes)/step)
  empty <- NULL # to remove empty variables
  for (i in 1:iterations) {
    n = step*(i-1)
    batch <- p1xcodes$code[seq(n+1,min(n+step,110))] # the codes to read (max  = 9)
    command <- paste(dQuote(P1X),
                     paste0("'",file,"'"),"/DUMP",
                     "export.csv",
                     paste(batch, collapse = " "),# Added commas for paths with spaces
                     selection_mode)
    system(command) # Execute command
    # save in a list and add appropiate names
    # if any of the codes is missing we revert to xi names.
    # If export does not exist skip to next

    if (file.exists("export.csv")) {
      names[[i]] <-
        p1xcodes$description[seq(n + 1, min(n + step, nrow(p1xcodes)))]
      export[[i]] <- data.table::fread("export.csv")
      file.remove("export.csv")
    } else {
      empty <- append(empty, i)
      next
    }
    #cat(".")
    if ((length(names[[i]])+3) != ncol(export[[i]])){
      missed <- paste(names[[i]], collapse = ", ")
      warning("Missing one of the following: \n", missed,
              "\nUsing generic (x1..xn) names")
      names[[i]] <- paste0("x",seq(n+1,(n+(ncol(export[[i]])-3))))
    }
  }
  # We remove the empty from the list NOT working
  # export <- export[-empty]
  # names <- names[-empty]
  empty <- sapply(export, function(x) ncol(x) == 0)
  export <- export[!empty]
  names <- names[!empty]

  # We add the 3 first to the names and the ones we already have
  names <- lapply(names, function(x) c("nodeA","nodeB","nodeC",x))

  # We go thourgh the list of data and add the names
  # change to map2 because errors with mapply
  export <- purrr::map2(export, names, function(x, y) {
    names(x) <- y
    x
  })
  # Remove short columns (sometimes p1x dump gives only 5 or 6 elements)
  nrows_export <- sapply(export, nrow)
  nrows_export <- nrows_export == max(nrows_export) # index only the complete columns
  removed_cols <- p1xcodes$description[!nrows_export] # get the names we are removing
  if (length(removed_cols)>0){
    missed <- paste(removed_cols, collapse = ", ")
    warning("Removed incomplete: \n", missed)
  }
  export <- export[nrows_export] # remove list object with incomplete nrows
  # We remove the node a ,b, c from all but the first element of the list
  export[2:length(export)] <- lapply(export[2:length(export)], function(x) x[,4:ncol(x), drop = FALSE])
  # We convert the list to a dataframe as the output
  export <- do.call("cbind", export)

  if (load_geometry){
  ufs_geom <- ufs_as_sf(file)
  export <- merge(ufs_geom, export, by = c("nodeA", "nodeB"), all.y=TRUE)
  }

  if (clean_up) {
    file.remove(list.files(pattern = "*.VDU"))
    file.remove(paste0(dirname(file),"/",stringr::str_sub(basename(file),0,-4),"LPP"))
    #file.remove("export.csv")
    file.remove("LAST_P1X0.DAT")
  }

  return(export)
}


