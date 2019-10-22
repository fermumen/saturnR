#' get coordinates
#'
#' This function allows you to read UFS/N file's into a df.
#' @param file The file to read.
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#' @param remove_txt when TRUE removes the interim txt
#' @keywords read, ufs, coordinates
#' @export
#' @examples

# We will need:
# a satdb dump coordinates key file and reader function
# a coordinates to geometry function

get_coordinates <- function(file ,
                     remove_txt = TRUE, clean_up = TRUE){

  SATDB <- file.path(get_xexes(),"$SATDB.exe")
  keyfile <- "temp.key" #name of the key

  # Text on the key with a neater format
  text <-
    c(
      "           2                                                                7025",
      "           6                                                                7052",
      "          -1                                                                7070",
      "           4                                                                7070",
      "           0                                                                7070",
      "           0                                                                7095",
      "           6                                                                7025",
      "           6                                                                7100",
      "           0                                                                7100",
      "          13                                                                7025",
      "           1                                                                7530",
      "           0                                                                7530",
      "geometry.txt",
      "           0                                                                7025",
      "y                                                                           9200")

  # Write the keyfile
  readr::write_lines(text,keyfile)
  # Execute the command

  command <- paste(dQuote(SATDB),
                   paste0("'",file,"'"), # Added commas for paths with spaces
                   "KEY temp.key VDU vdu")

  system(command)

  # Read the csv in R
  txtfile <- "geometry.TXT"
  matrix<-  data.table::fread(txtfile)
  names(matrix) <- c("nodeA","nodeB","nodeC", "X1","Y1", "X2","Y2")
  matrix$nodeC <- NULL
  # Remove interim file
  if (remove_txt) {
    file.remove(txtfile)
  }

  #Clean up garbage files
  if (clean_up) {
    file.remove(list.files(pattern = "*.VDU"))
    file.remove(paste0(dirname(file),"/",stringr::str_sub(basename(file),0,-4),"LPD"))
    file.remove(list.files(pattern = "*.key"))
  }
  return(matrix)
}


#' ufs_to_sf
#'
#' This function allows you to read UFS/N file's into an R SF.
#' @param file The file to read.
#' @param ... Arguments to be passed to get-coordinates
#' @keywords read, ufs, coordinates, sf
#' @export


ufs_as_sf <- function(file, ...){
  x <- get_coordinates(file, ...)
  x.list <- as.list(as.data.frame(t(x[,c("X1","Y1","X2","Y2")])))
  geom <- lapply(x.list, matrix, ncol= 2, byrow = TRUE )
  geom <- lapply(geom, sf::st_linestring)
  geom <- sf::st_sfc(geom, crs = "+init=epsg:27700")
  sf::st_as_sf(x, geometry=geom)# return this

}
