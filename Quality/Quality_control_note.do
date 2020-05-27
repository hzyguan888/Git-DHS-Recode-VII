
***Look for variables in dta. file under specific folder
ssc install lookfor_all

lookfor_all mammogram, subdir de vlabs filter(ind)  dir("C:\Users\Guan\OneDrive\DHS\MEASURE UHC DATA\RAW DATA\Recode VII")



***Different definition from DHS report, which can explain some differences in quality control file.
c_ari: don’t include cough in DHS report
w_obese_1549: excludes pregnant women and women with a birth in the preceding 2 months in DHS report
c_sba: we include auxiliary midwife (matrone) for BJ7 ML7