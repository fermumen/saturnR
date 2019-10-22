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


read_ufm <- function(file ,
                     remove_txt = TRUE, clean_up = TRUE){

  MX <- file.path(get_xexes(),"$MX.exe")
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

  command <- paste(dQuote(MX),
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
