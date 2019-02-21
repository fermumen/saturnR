#' Read geometry function
#'
#' This function allows you to read UFS/N file's into an R SF.
#' @param file The file to read.
#' @param SATDB Path to the SATDB exe folder
#' @param lat_long when set to TRUE it will convert coordinates to
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#' @keywords read, ufs, coordinates
#' @export
#' @examples
#' UFS_to_sf("file.UFS")

# We will need:
# a satdb dump coordinates key file and reader function
# a coordinates to geometry function

get_coordinates <- function(file ,SATDB = "C:\\SATWIN\\XEXES_11.3.12W_MC\\$SATDB.exe",
                     remove_txt = TRUE, clean_up = TRUE){

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
      "",
      "           0                                                                7025",
      "y                                                                           9200")

  # Write the keyfile
  readr::write_lines(text,keyfile)
  # Execute the command

  command <- paste(SATDB,
                   paste0("'",file,"'"), # Added commas for paths with spaces
                   "KEY temp.key VDU vdu")

  system(command)

  # Read the csv in R
  txtfile <- paste0(dirname(file),"/",stringr::str_sub(basename(file),0,-4),"TXT")
  matriz<-  data.table::fread(txtfile)
  names(matriz) <- c("nodeA","nodeB","nodeC", "X1","Y1", "X2","Y2")
  matriz$nodeC <- NULL
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
  return(matriz)
}

# a <- get_coordinates(file)

ufs_as_sf <- function(file, ...){
  x <- get_coordinates(file, ...)
  x.list <- as.list(as.data.frame(t(x[,c("X1","Y1","X2","Y2")])))
  geom <- lapply(x.list, matrix, ncol= 2, byrow = TRUE )
  geom <- lapply(geom, sf::st_linestring)
  geom <- sf::st_sfc(geom, crs = "+init=epsg:27700")
  sf::st_as_sf(x, geometry=geom)# return this

}
