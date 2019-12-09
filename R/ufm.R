#' Read UFM function
#'
#' This function allows you to read UFM files into R.
#' @param file The file to read.
#' @param remove_txt when set to TRUE it will remove the interim txt files
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#' @keywords read, ufm
#' @export
read_ufm <- function(file ,
                     remove_txt = TRUE,
                     clean_up = TRUE) {
  MX <- file.path(get_xexes(), "$MX.exe")
  keyfile <- "temp.key" #name of the key

  # Text on the key
  text <-
    c("          13                                                                2000",
      "          16                                                                2604",
      "           9                                                                2604",
      "", #Empty line to dump txt with the same name asumed TXT extension default
      "           0                                                                2604",
      "           0                                                                2000",
      "y                                                                           9200")

  # Write the keyfile
  readr::write_lines(text,keyfile)
  # Execute the command

  command <- paste(dQuote(MX),
                   dQuote(file),
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


#' Write UFM function
#'
#' This function allows you to write data frames into UFM files.
#'
#' @param x A data,table object with three columns O,D,Trips or 4 columns if stack = TRUE
#' @param file The file to write, extension mandatory
#' @param remove_txt when set to TRUE it will remove the interim txt files
#' @param stack wether or not to stack the function. Changes to true for 4 column inputs
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#'
#' @keywords write, ufm
#' @export

write_ufm <- function(x, file,
                      remove_txt = TRUE, clean_up = TRUE, stack = FALSE){

  MX <- file.path(get_xexes(),"$MX.exe")
  if (!tools::file_ext(file) %in% c("UFM","ufm")) {
    warning("File should have an appropiate extension like .UFM or .ufm")
  }

  if (ncol(x)>3 & stack == FALSE) {
    warning("More than 3 columns detected, switching stack to TRUE")
    stack = TRUE
  }


  txtName <- paste0(dirname(file),"/",
                    stringr::str_sub(basename(file),0,-5),
                    ".txt") # Name of the interim file
  x <- as.data.frame(x)
  x[,ncol(x)] <- format(x[,ncol(x)], digits = 20,scientific = FALSE)
  data.table::fwrite(x,file = txtName, col.names = F) # Write the interim file


  keyfile <- "temp.key" #name of the key

  if (stack) {
    text <-
      c(
        "           1                                                                2004",
        txtName,
        "           2                                                                2030",
        "           8                                                                2031",
        "           1                                                                2030",
        "          13                                                                2000",
        "           0                                                                2604",
        "          14                                                                2000",
        "           1                                                                2600",
        file,
        "TITLE UNSET                                                                 9260",
        "           0                                                                2640",
        "           0                                                                2000",
        "y                                                                           9200"
      )
  } else {
    # Text on the key
    text <-
      c(
        "           1                                                                2004",
        txtName,
        "           2                                                                2030",
        "           7                                                                2031",
        "           1                                                                2030",
        "          14                                                                2000",
        "           1                                                                2600",
        file,
        "TITLE UNSET                                                                 9260",
        "           0                                                                2640",
        "           0                                                                2000",
        "y                                                                           9200"
      )
  }

  # Write the keyfile
  readr::write_lines(text,keyfile)
  # Execute the command
  command <- paste(dQuote(MX), "I KEY temp.key VDU vdu")
  system(command)

  # Remove interim file
  if (remove_txt) {
    file.remove(txtName)
  }

  #Clean up garbage files
  if (clean_up) {
    file.remove(list.files(pattern = "*.VDU"))
    file.remove(list.files(pattern = "*.LPX"))
    file.remove(list.files(pattern = "*.key"))
  }

}
