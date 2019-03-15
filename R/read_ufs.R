#' Read UFS function
#'
#' This function allows you to read UFS assignment data into R.
#' @param file The file to read.
#' @param MX Path to the MX exe folder
#' @param load_geometry it uses satdb to load the geometry and converts the object into a sf
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#' @keywords read, ufm
#' @export
#' @examples
#' read_ufs("file.UFM")
#'
read_ufs <- function(file ,P1X = "C:\\SATWIN\\XEXES_11.3.12W_MC\\$P1X.exe",
                     clean_up = TRUE, load_geometry = FALSE){
  export <- list()
  names <- list()
  for (i in 1:13) {
    n = 9*(i-1)
    batch <- p1xcodes$code[seq(n+1,min(n+9,110))]
    command <- paste(P1X,
                     paste0("'",file,"'"),"/DUMP",
                     "export.csv",
                     paste(batch, collapse = " "),# Added commas for paths with spaces
                     "$L")
    system(command)
    names[[i]] <- p1xcodes$description[seq(n+1,min(n+9,nrow(p1xcodes)))]
    export[[i]] <- data.table::fread("export.csv")
    if ((length(names[[i]])+3) != ncol(export[[i]])){
      missed <- paste(names[[i]], collapse = ", ")
      warning("Missing one of the following: \n", missed,
              "\nUsing generic (X1..Xn) names")
      names[[i]] <- paste0("X",seq(n+1,(n+(ncol(export[[i]])-3))))
    }
  }
  names <- lapply(names, function(x) c("nodeA","nodeB","nodeC",x))
  export <- mapply(function(x,y){
    names(x) <- y
    x
    }, x = export, y = names)

  export[2:length(export)] <- lapply(export[2:length(export)], function(x) x[,4:ncol(x)])
  export <- do.call("cbind", export)

  if (load_geometry){
  ufs_geom <- ufs_as_sf(file)
  export <- merge(ufs_geom, export, by = c("nodeA", "nodeB"), all.y=TRUE)
  }

  if (clean_up) {
    file.remove(list.files(pattern = "*.VDU"))
    file.remove(paste0(dirname(file),"/",stringr::str_sub(basename(file),0,-4),"LPP"))
    file.remove("export.csv")
    file.remove("LAST_P1X0.DAT")
  }

  return(export)
}


