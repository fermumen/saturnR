#' Skim Distance UFM function
#'
#' This function allows you to skim distances (km) from UFS files into R. Note it needs UFC/O
#' @param file The file to read.
#' @param SKIMDIST Path to the SKIMDIST.bat folder
#' @param remove_ufm when set to TRUE it will remove the interim ufm files
#' @param clean_up when TRUE removes the VDU, KEY and LPL files
#' @keywords read, ufs, distance
#' @export
#' @examples
#' skim_dist("file.UFS")

skim_dist <- function(file ,SATLOOK = "C:\\SATWIN\\XEXES_11.3.12W_MC\\$SATLOOK.exe", remove_ufm = TRUE, clean_up = TRUE){

  command <- paste(SATLOOK,
                   paste0("'",file,"'"), # Added commas
                   "M 28",
                   "out",
                   "/DISTSKIM") #output file

  system(command)

  x <- read_ufm("out.UFM")
  names(x) <- c("origin","destination","uc","distance")

  # Remove interim file
  if (remove_ufm) {
    file.remove("out.UFM")
  }

# Clean up garbage files
  if (clean_up) {
    #file.remove(list.files(pattern = "*.VDU"))
    file.remove(paste0(dirname(file),"/",stringr::str_sub(basename(file),0,-4),"LPL"))
  }
  return(x)

}
