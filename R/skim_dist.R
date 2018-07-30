#' Skim Distance UFM function
#'
#' This function allows you to skim distances (km) from UFS files into R. NOT TESTED
#' @param file The file to read.
#' @param MX Path to the MX exe folder
#' @param remove_txt when set to TRUE it will remove the interim txt files
#' @param clean_up when TRUE removes the VDU, KEY and LPX files
#' @keywords read, ufm
#' @export
#' @examples
#' skim_dist("file.UFS")

skim_dist <- function(file ,SKIMDIST = "C:\\SATWIN\\XEXES_11.3.12W_MC\\SKIMDIST.BAT", remove_ufm = TRUE, clean_up = TRUE){

  command <- paste(SKIMDIST,
                   paste0("'",file,"'"), # Added commas
                   "out") #output file

  system(command)

  x <- read_ufm("out.UFM")
  names(x) <- c("origin","destination","uc","distance")

  # Remove interim file
  if (remove_ufm) {
    file.remove("out.UFM")
  }

# Clean up garbage files
  if (clean_up) {
    file.remove(list.files(pattern = "*.VDU"))
    file.remove(paste0(dirname(file),"/",stringr::str_sub(basename(file),0,-4),"LPL"))
  }
  return(x)

}
