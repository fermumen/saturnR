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
#' UFS_to("file.UFS")

# We will need:
# a transform coordinates function st_transform
# a satdb dump coordinates key file and reader function
# a coordinates to geometry function
# a reporpused clean up function

get_coordinates <- function(file ,SATDB = "C:\\SATWIN\\XEXES_11.3.12W_MC\\$SATDB.exe",
                     remove_txt = TRUE, clean_up = TRUE){

  keyfile <- "temp.key" #name of the key

  # Text on the key
  text <-
    c(
      "          18                                                                7025",
      "           6                                                                7025",
      "           3                                                                7100",
      "           0                                                                7100",
      "          13                                                                7025",
      "           1                                                                7530",
      "           1                                                                7530",
      "           0                                                                7530",
      "",
      "y",
      "           0                                                                7025",
      "y ")

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
  names(matriz) <- c("node", "X", "Y")

  # Remove interim file
  if (remove_txt) {
    file.remove(txtfile)
  }

  #Clean up garbage files
  if (clean_up) {
    file.remove(list.files(pattern = "*.VDU"))
    file.remove(paste0(dirname(file),"/",stringr::str_sub(basename(file),0,-4),"LPX"))
    file.remove(list.files(pattern = "*.key"))
  }
  return(matriz)
}

