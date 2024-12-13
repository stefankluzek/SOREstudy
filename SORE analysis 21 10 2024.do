// Name: SORE analysis
// Authors Pearson , O'Sullivan, Kluzek.

* SORE Study Analysis
* Stata .do file



*Set up the environment
clear all
set more off
*ssc install table1_mc

* Description: This .do file contains the processes for the SORE Study including
* data cleaning, analysis, and merging of datasets as part of the study's results
* consolidation.

* Define global paths for data and output (replace with actual paths)
global datapath "...Results raw - do not change"
global outputpath "...SORE ANALYSES - General/RGP Graphs"


// Import (modify pathway after dowloading )

import excel "....SORE lab data", sheet("Results") firstrow

// Data cleaning and labelling

* Describe the data
describe


*Arm1 ==Arm2 in position 47
replace studyid = "17A2" in 47
*12 injury A2 == 13 in position 36
replace studyid = "13A2" in 36

* Summarize the data to get an overview
summarize

* Create a new variable 'id' extracting the first two characters of studyid
gen id = substr(studyid, 1, 2)

* Create a new variable 'code' where the last two characters of studyid are:
* A1 -> 1
* A2 -> 2
* K1 -> 3
gen code = .
replace code = 1 if substr(studyid, -2, 2) == "A1"
replace code = 2 if substr(studyid, -2, 2) == "A2"
replace code = 3 if substr(studyid, -2, 2) == "K1"

* Check the created variables
list id code studyid
destring id,replace
drop if id==.


* Define label names for the code values
label define code_lbl 1 "arm 1" 2 "arm 2" 3 "knee"

* Assign label to the code variable
label values code code_lbl
replace CTXIIugL="0.09" if CTXIIugL=="<0.10"
destring CTXIIugL,replace
replace IL1BngL="0.018" if IL1BngL=="<0.019"
destring IL1BngL,replace

* Define the label names for the group values
label define group_lbl 6 "injury" 4 "control" 5 "OA"

* Assign the label to the group variable
label values Group group_lbl

* To verify, you can list the values of the variable with their new labels
list Group in 1/10

drop Position studyid Dateofsample Datacheck Date Dataentry Labnumber 

** reshape wide
reshape wide Group IL1BngL IL6ngL CTXIIugL LeptugL COMPugL PIIANPugL, i(id) j(code)

// label variables
label variable IL1BngL1 "before Exercise"
label variable IL1BngL2 "after Exercise"
label variable IL1BngL3 "knee before Exercise"
* To verify the labels, you can use the describe command
describe IL1BngL1 IL1BngL2 IL1BngL3
* Labeling the IL6 variables
label variable IL6ngL1 "IL6 Arm before Exercise"
label variable IL6ngL2 "IL6 Arm after Exercise"
label variable IL6ngL3 "IL6 knee before Exercise"
* To verify the labels, you can use the describe command
describe IL6ngL1 IL6ngL2 IL6ngL3
label variable LeptugL1 "Leptin Arm before Exercise"
label variable LeptugL2 "Leptin  Arm after Exercise"
label variable LeptugL3 "Leptin knee before Exercise"
* To verify the labels, you can use the describe command
describe LeptugL1 LeptugL2 LeptugL3

label variable CTXIIugL1 "CTXII Arm before Exercise"
label variable CTXIIugL2 "CTXII  Arm after Exercise"
label variable CTXIIugL3 "CTXII knee before Exercise"
* To verify the labels, you can use the describe command
describe CTXIIugL1 CTXIIugL2 CTXIIugL3

label variable COMPugL1 "COMP Arm before Exercise"
label variable COMPugL2 "COMP  Arm after Exercise"
label variable COMPugL3 "COMP knee before Exercise"
* To verify the labels, you can use the describe command
describe COMPugL1 COMPugL2 COMPugL3 

label variable PIIANPugL1 "PIIANP Arm before Exercise"
label variable PIIANPugL2 "PIIANP  Arm after Exercise"
label variable PIIANPugL3 "PIIANP knee before Exercise"
* To verify the labels, you can use the describe command
describe PIIANPugL1 PIIANPugL2 PIIANPugL3


*Arm vs knee 
 drop Group2 IL1BngL2 IL6ngL2 CTXIIugL2 LeptugL2 COMPugL2 PIIANPugL2 Group3 O

* remove if blood from knee not taken  
drop if IL1BngL3==.


reshape long IL1BngL IL6ngL CTXIIugL LeptugL COMPugL PIIANPugL, i(id) j(Location)

gen location = ""
replace location = "ARM" if Location == 1
replace location = "KNEE" if Location == 3
gen LabelValue = string(IL1BngL, "%0.2f")


scatter IL1BngL Location, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-1B Levels (ng/L) - Outliers") ylabel(0(1)8, angle(0) nogrid) xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("IL 1B (ng/L)") xtitle(" ") aspectratio(1.5)

* an outlier shrinks values 
gen group = cond(IL1BngL > 0.6, "Outlier", "Main")

scatter IL1BngL Location if group == "Main", connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-1B Levels (ng/L)") ylabel(0 0.2 0.6, angle(0) nogrid) xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("IL 1B (ng/L)") xtitle(" ") aspectratio(1.5)


scatter IL1BngL Location if group == "Main", connect(L) msymbol(|) msize(small) lwidth(thin) mcolor(black) lcolor(black) title("IL-1B Levels (ng/L) Arm vs Knee") ylabel(0 0.6, angle(0)) xlabel(1 "ARM" 2 "KNEE")  aspectratio(1.5) ylabel(,nogrid) ytitle("IL 1B (ng/l)") xtitle(" ") xlabel(,nogrid) xlabel(0.8 " "  1 "Arm" 2 "Knee" 4 " ", notick labsize(small) angle(0))

scatter IL1BngL Location if group == "Main", connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-1B Levels (ng/L)") ylabel(0 0.4 0.6, angle(0) nogrid) xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("IL 1B (ng/L)") xtitle(" ") aspectratio(1.5)
graph save mainIL1_graph.gph, replace

scatter IL1BngL Location if group == "Outlier",  connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL 1B (ng/l)") ylabel(0 4 8, angle(0) nogrid) xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("IL 1B (ng/l)") xtitle(" ") aspectratio(1.5)
graph save outlierIL1n_graph.gph, replace
*
* Add a Visual Break to achieve the visual "break" between the two y-axis scale

graph combine outlierIL1n_graph.gph mainIL1_graph.gph, title("Combined IL-1B Levels")


***IL6ngL
scatter IL6ngL Location, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-6 (ng/L)") xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("IL-6 (ng/L)") xtitle(" ") aspectratio(1.5)


gen group2 = cond(IL6ngL > 12, "Outlier", "Main")


scatter IL6ngL Location if group == "Main", connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-6 (ng/L))") ylabel(0 5 10, angle(0) nogrid) xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("IL-6 (ng/L)") xtitle(" ") aspectratio(1.5)
graph save mainIL6_graph.gph, replace


scatter IL6ngL Location if group2 == "Main", connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-6 (ng/L)") ylabel(0 1 5 7, angle(0) nogrid) xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("IL-6 (ng/L)") xtitle(" ") aspectratio(1.5)
graph save mainIL6_graph.gph, replace

scatter IL6ngL Location if group2 == "Outlier", connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-6 (ng/L)") ylabel(0 170, angle(0) nogrid) xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("IL-6 (ng/L)") xtitle(" ") aspectratio(1.5)
graph save outlierIL6_graph.gph, replace
*
* Add a Visual Break to achieve the visual "break" between the two y-axis scale

graph combine outlierIL6_graph.gph mainIL6_graph.gph, title("Combined IL-6 Levels")

**** CTXII

scatter CTXIIugL Location, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("CTXII (ug/L)") xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("CTXII (ug/L)") xtitle(" ") aspectratio(1.5)
graph save CTXII_graph.gph, replace

graph combine graph1 graph2 graph3 graph4 graph5 graph6
graph export AK.tif, width(1500) height(900)
***Leptin


scatter LeptugL Location, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("Leptin (ug/L)") xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("Leptin (ug/L)") xtitle(" ") aspectratio(1.5)
graph save Leptin_graph.gph, replace

*** COMP


graph save COMP_graph.gph, replace
scatter COMPugL Location, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("COMP (ug/L)") xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("COMP (ug/L)") xtitle(" ") aspectratio(1.5)

graph save Comp_graph.gph, replace


**** PIIANPugL
scatter PIIANPugL Location, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("PIIANP (ug/L)") xlabel(1 "ARM" 3 "KNEE", notick labsize(small) angle(0)) ytitle("PIIANP (ug/L)") xtitle(" ") aspectratio(1.5)
graph save PIIANP_graph.gph, replace


*** Combined without outliers

graph combine mainIL1_graph.gph mainIL6_graph.gph CTXII_graph.gph Leptin_graph.gph Comp_graph.gph PIIANP_graph.gph

graph combine outlierIL1n_graph.gph outlierIL6_graph.gph CTXII_graph.gph Leptin_graph.gph Comp_graph.gph PIIANP_graph.gph



clear all
set more off
*ssc install table1_mc

* Description: This .do file contains the processes for the SORE Study including
* data cleaning, analysis, and merging of datasets as part of the study's results
* consolidation.

* Define global paths for data and output (replace with actual paths)
global datapath "C:/Users/mszrgp/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/SORE ANALYSES - General/Results raw - do not change"
global outputpath "C:/Users/mszrgp/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/SORE ANALYSES - General/RGP Graphs"


// Import

import excel "C:\Users\X395\Downloads\419 SORE-1 study RESULTS BLIND - RGP mk2.xlsx", sheet("Results") firstrow

// Data cleaning and labelling

* Describe the data
describe


*Arm1 ==Arm2 in position 47
replace studyid = "17A2" in 47
*12 injury A2 == 13 in position 36
replace studyid = "13A2" in 36

* Summarize the data to get an overview
summarize

* Create a new variable 'id' extracting the first two characters of studyid
gen id = substr(studyid, 1, 2)

* Create a new variable 'code' where the last two characters of studyid are:
* A1 -> 1
* A2 -> 2
* K1 -> 3
gen code = .
replace code = 1 if substr(studyid, -2, 2) == "A1"
replace code = 2 if substr(studyid, -2, 2) == "A2"
replace code = 3 if substr(studyid, -2, 2) == "K1"

* Check the created variables
list id code studyid
destring id,replace
drop if id==.


* Define label names for the code values
label define code_lbl 1 "arm 1" 2 "arm 2" 3 "knee"

* Assign label to the code variable
label values code code_lbl
replace CTXIIugL="0.09" if CTXIIugL=="<0.10"
destring CTXIIugL,replace
replace IL1BngL="0.018" if IL1BngL=="<0.019"
destring IL1BngL,replace

* Define the label names for the group values
label define group_lbl 6 "injury" 4 "control" 5 "OA"

* Assign the label to the group variable
label values Group group_lbl

* To verify, you can list the values of the variable with their new labels
list Group in 1/10

drop Position studyid Dateofsample Datacheck Date Dataentry Labnumber 

** reshape wide
reshape wide Group IL1BngL IL6ngL CTXIIugL LeptugL COMPugL PIIANPugL, i(id) j(code)

// label variables
label variable IL1BngL1 "before Exercise"
label variable IL1BngL2 "after Exercise"
label variable IL1BngL3 "knee before Exercise"
* To verify the labels, you can use the describe command
describe IL1BngL1 IL1BngL2 IL1BngL3
* Labeling the IL6 variables
label variable IL6ngL1 "IL6 Arm before Exercise"
label variable IL6ngL2 "IL6 Arm after Exercise"
label variable IL6ngL3 "IL6 knee before Exercise"
* To verify the labels, you can use the describe command
describe IL6ngL1 IL6ngL2 IL6ngL3
label variable LeptugL1 "Leptin Arm before Exercise"
label variable LeptugL2 "Leptin  Arm after Exercise"
label variable LeptugL3 "Leptin knee before Exercise"
* To verify the labels, you can use the describe command
describe LeptugL1 LeptugL2 LeptugL3

label variable CTXIIugL1 "CTXII Arm before Exercise"
label variable CTXIIugL2 "CTXII  Arm after Exercise"
label variable CTXIIugL3 "CTXII knee before Exercise"
* To verify the labels, you can use the describe command
describe CTXIIugL1 CTXIIugL2 CTXIIugL3

label variable COMPugL1 "COMP Arm before Exercise"
label variable COMPugL2 "COMP  Arm after Exercise"
label variable COMPugL3 "COMP knee before Exercise"
* To verify the labels, you can use the describe command
describe COMPugL1 COMPugL2 COMPugL3 

label variable PIIANPugL1 "PIIANP Arm before Exercise"
label variable PIIANPugL2 "PIIANP  Arm after Exercise"
label variable PIIANPugL3 "PIIANP knee before Exercise"
* To verify the labels, you can use the describe command
describe PIIANPugL1 PIIANPugL2 PIIANPugL3


*before and after exercise  
 drop Group3 IL1BngL3 IL6ngL3 CTXIIugL3 LeptugL3 COMPugL3 PIIANPugL3 Group3 O


reshape long IL1BngL IL6ngL CTXIIugL LeptugL COMPugL PIIANPugL, i(id) j(Exercise)

gen exercise = ""
replace exercise = "Pre" if Exercise == 1
replace exercise = "Post" if Exercise == 2



scatter IL1BngL Exercise, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-1B Levels (ng/L)") ylabel(0(1)8, angle(0) nogrid) xlabel(1 "Pre" 2 "Post", notick labsize(small) angle(0)) ytitle("IL 1B (ng/L)") xtitle(" ") aspectratio(1.5)

* Group outliers
gen group = cond(IL1BngL > 0.8, "Outlier", "Main")

* Main group graph
scatter IL1BngL Exercise if group == "Main", connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-1B Levels (ng/L)") ylabel(0 0.2 0.6, angle(0) nogrid) xlabel(1 "Pre" 2 "Post", notick labsize(small) angle(0)) ytitle("IL 1B (ng/L)") xtitle(" ") aspectratio(1.5)
graph save mainIL1_graph.gph, replace

* Outlier group graph
scatter IL1BngL Exercise if group == "Outlier", connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-1B Levels (ng/L)") ylabel(0 4 8, angle(0) nogrid) xlabel(1 "Pre" 2 "Post", notick labsize(small) angle(0)) ytitle("IL 1B (ng/L)") xtitle(" ") aspectratio(1.5)
graph save outlierIL1_graph.gph, replace

* Combine graphs
graph combine outlierIL1_graph.gph mainIL1_graph.gph, title("Combined IL-1B Levels")



***IL6ngL
scatter IL6ngL Exercise, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-6 (ng/L)") xlabel(1 "Pre" 3 "Post", notick labsize(small) angle(0)) ytitle("IL-6 (ng/L)") xtitle(" ") aspectratio(1.5)

* Group outliers
gen group2 = cond(IL6ngL > 12, "Outlier", "Main")

* Main group graph
scatter IL6ngL Exercise if group2 == "Main", connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-6 (ng/L)") ylabel(0 5 10, angle(0) nogrid) xlabel(1 "Pre" 2 "Post", notick labsize(small) angle(0)) ytitle("IL-6 (ng/L)") xtitle(" ") aspectratio(1.5)
graph save mainIL6_graph.gph, replace

* Outlier group graph
scatter IL6ngL Exercise if group2 == "Outlier", connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("IL-6 (ng/L)") ylabel(0 170, angle(0) nogrid) xlabel(1 "Pre" 2 "Post", notick labsize(small) angle(0)) ytitle("IL-6 (ng/L)") xtitle(" ") aspectratio(1.5)
graph save outlierIL6_graph.gph, replace

* Combine graphs
graph combine outlierIL6_graph.gph mainIL6_graph.gph, title("Combined IL-6 Levels")

* Add a Visual Break to achieve the visual "break" between the two y-axis scale

graph combine outlierIL6_graph.gph mainIL6_graph.gph, title("Combined IL-6 Levels")

**** CTXII

scatter CTXIIugL Exercise, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("CTXII (ug/L)") xlabel(1 "Pre" 2 "Post", notick labsize(small) angle(0)) ytitle("CTXII (ug/L)") xtitle(" ") aspectratio(1.5)
graph save CTXII_graph.gph, replace


***Leptin


scatter LeptugL Exercise, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("Leptin (ug/L)") xlabel(1 "Pre" 2 "Post", notick labsize(small) angle(0)) ytitle("Leptin (ug/L)") xtitle(" ") aspectratio(1.5)
graph save Leptin_graph.gph, replace


*** COMP


scatter COMPugL Exercise, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("COMP (ug/L)") xlabel(1 "Pre" 2 "Post", notick labsize(small) angle(0)) ytitle("COMP (ug/L)") xtitle(" ") aspectratio(1.5)
graph save COMP_graph.gph, replace



**** PIIANPugL
scatter PIIANPugL Exercise, connect(L) msymbol(|) msize(medium) lwidth(thin) mcolor(black) lcolor(black) title("PIIANP (ug/L)") xlabel(1 "Pre" 2 "Post", notick labsize(small) angle(0)) ytitle("PIIANP (ug/L)") xtitle(" ") aspectratio(1.5)
graph save PIIANP_graph.gph, replace



*** Combined without outliers

graph combine mainIL1_graph.gph mainIL6_graph.gph CTXII_graph.gph Leptin_graph.gph Comp_graph.gph PIIANP_graph.gph

graph combine outlierIL1n_graph.gph outlierIL6_graph.gph CTXII_graph.gph Leptin_graph.gph Comp_graph.gph PIIANP_graph.gph


