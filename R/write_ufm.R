write_ufm <- function(x, file ,MX = "C:\\SATWIN\\XEXES_11.3.12W_MC\\$MX.exe", remove_txt = TRUE, clean_up = TRUE){
# Writes data frame into UFM (TUBA 2 ONLY) 
#   x - data frame with 3 columns (O,D, Trips)
#   file -  name of the file with extension, paths accepted
#   MX - path to MX folder default value included
#   remove_txt - boolean, weather to remove the the interim txt file generated
#   clean_up - if true removes the VDU, LPX and KEY files
# Output
#   Writes a UFM file into the parent folder
# Bugs  
#   It does not clean up in other folders if you set up a relative path in file

  
  require(data.table)
  require(stringr)
  require(readr)
  
  txtName <- paste0(dirname(file),"/",
                 str_sub(basename(file),0,-5),
                 ".txt") # Name of the interim file
  
  fwrite(x,file = txtName, col.names = F) # Write the interim file
  
  
  keyfile <- "temp.key" #name of the key

# Text on the key  
text <-c(
"           1                                                                2004",
txtName,
"           2                                                                2030
           7                                                                2031
           1                                                                2030
          14                                                                2000
           1                                                                2600",
file,
"TITLE UNSET                                                                 9260
           0                                                                2640
           0                                                                2000
y                                                                           9200
")

# Write the keyfile
  write_lines(text,keyfile)
# Execute the command
  command <- paste(MX, "I KEY temp.key VDU vdu")
  system(command)

  # Remove interim file 
  if (remove_txt) {
    file.remove(txtName)
  }
  
  #Clean up garbage files
  if (clean_up) {
    file.remove(list.files(pattern = "*.VDU"))
    file.remove(list.files(pattern = "*.LPX", path = dirname(file)))
    file.remove(list.files(pattern = "*.key"))
  }

}
