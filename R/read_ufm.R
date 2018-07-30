#' Read UFM function
#'
#' This function allows you to read UFM files into R.
#' @param file The file to read.
#' @param MX Path to the MX exe folder
#' @param remove_txt when set to TRUE it will remove the interim txt files
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#' @keywords read, ufm
#' @export
#' @examples
#' read_ufm("file.UFM")


read_ufm <- function(file ,MX = "C:\\SATWIN\\XEXES_11.3.12W_MC\\$MX.exe", remove_txt = TRUE, clean_up = TRUE){
# Read data frame into UFM (TUBA 2 ONLY)
#   x - data frame with 3 columns (O,D, Trips)
#   file -  name of the file with or without extension
#   MX - path to MX folder default value included
#   remove_txt - boolean, weather to remove the the interim txt file generated
#   clean_up - if true removes the VDU, LPX and KEY files
# Output
#   Writes a UFM file into the parent folder
# Bugs
#   It does not clean up in other folders if you set up a relative path in file
  #file <- paste0(dirname(file),"/",basename(file),".UFM")
  # require(data.table)
  # require(readr)
  # require(stringr)
  #name <- paste0(file,".txt") # Name of the interim file

  #fwrite(x,file = name, col.names = F) # Write the interim file


  keyfile <- "temp.key" #name of the key

# Text on the key
text <-"          13                                                                2000
          16                                                                2604
           9                                                                2604

           0                                                                2604
           0                                                                2000
y                                                                           9200"

# Write the keyfile
  readr::write_lines(text,keyfile)
# Execute the command

  command <- paste(MX,
                   paste0("'",file,"'"), # Added commas for paths with spaces
                   "KEY temp.key VDU vdu")

  system(command)

# Read the csv in R
  txtfile <- paste0(dirname(file),"/",stringr::str_sub(basename(file),0,-4),"TXT")
  matriz<-  data.table::fread(txtfile)
  names(matriz) <- c("origin", "destination", "user_class", "trips")

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
