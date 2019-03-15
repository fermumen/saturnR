library(saturnR)
a <- read_ufs("./testdata/A428_Stage3_BY2015_AM_v3_6c_inc_SFC_T14.UFS")

# this should throw a warning
b <- read_ufs("./testdata/2031_HIFSc2_AM.UFS", load_geometry = TRUE)
