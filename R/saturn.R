#' saturn function
#'
#' This runs saturn assignements using the SATURN.bat file stored in the XEXES folder.
#' @param DAT The network file.
#' @param UFM The Matrix file.
#' @param PASSQ The PASSQ network file (optional).
#' @param PATH The path to the XEXES version of preference (Default: "C:/SATWIN/XEXES_11.3.12W_MC").
#' @param remove_bat when set to TRUE it will remove the .bat file generated.
#' @keywords saturn, assign
#' @export
#' @examples
#' saturn('./Data/AM-reassignment/2014_Base_AM.dat','./Data/AM-reassignment/2014_BaseCosts_AM.ufm','./Data/AM-reassignment/2014_Base_AM_PassQ.dat')

saturn <- function(DAT='',UFM='',PASSQ=NULL, PATH = "C:/SATWIN/XEXES_11.3.12W_MC",remove_bat = TRUE){
#   Assings a matrix.ufm to a network.dat
#   DAT - The network file
#   UFM -  The Matrix file
#   PASSQ - The PASSQ network file (optional)
#   PATH - The path to the XEXES version of preference (Default: "C:/SATWIN/XEXES_11.3.12W_MC").
#   remove_bat - boolean, weather to remove the the interim .bat file generated.
# Output
#   network.UFN  - Output SATURN UF file from SATNET
#   network.UFS  - Output SATURN UF file from SATALL
#   network.LPN  - Output line printer files from SATNET ...
#     network.LPT  - .. and SATALL
# Bugs

  # require(stringr)

# Adequates the inputs
  DAT<- stringr::str_replace_all(DAT,'(/)',"\\\\")
  UFM<- stringr::str_replace_all(UFM,'(/)',"\\\\")
  DAT<- stringr::str_replace_all(DAT,c('.dat','.DAT'),"")
  UFM<- stringr::str_replace_all(UFM[],c('.ufm','.UFM'),"")

# Creates the .bat file
  if(is.null(PASSQ)){
    fileConn<-file("saturn_assing.bat")
    writeLines(c(paste0('SET PATH=',PATH),paste('CALL SATURN', DAT[1], UFM[1])), fileConn)
    close(fileConn)
  }
  else{
    PASSQ<- stringr::str_replace_all(PASSQ,'(/)',"\\\\")
    PASSQ<- stringr::str_replace_all(PASSQ,c('.dat','.DAT'),"")
    fileConn<-file("saturn_assing.bat")
    writeLines(c(paste0('SET PATH=',PATH),paste('CALL SATURN', PASSQ[1], UFM[1]),paste('CALL SATURN', DAT[1], UFM[1], 'PASSQ', PASSQ[1])), fileConn)
    close(fileConn)
  }

# Runs the .bat file
  system("saturn_assing.bat")

# Cleaning
  PASSQ=NULL
  if (remove_bat) {
  file.remove("saturn_assing.bat")
  }
}
