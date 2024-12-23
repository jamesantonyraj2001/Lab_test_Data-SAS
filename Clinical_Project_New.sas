proc import datafile="C:\Users\GEORGE JENIF\Downloads\Clinical_project\Clinical_Project - Lab_data.xlsx" out=lab_test 
dbms=xlsx replace;
sheet="Table 1 - Data Set WORK.LAB_";
run;
/*Variable types display*/
proc contents data=lab_test;
run;
/*conditions for lbstnlo & lbstnhi & lbstresn*/
data lab_test_c;
length lbnirnd $20.; /*declare lbnirind variable char datatype*/
set lab_test;
if not missing(lbstnrlo) and not missing(lbstnrhi) then do;
if lbstnrlo<=lbstresn<=lbstnrhi then lbnirnd="NORMAL";
else if lbstresn>lbstnrhi then lbnirnd="HIGH";
else if lbstresn<lbstnrlo then lbnirnd="LOW";
end;
run;

proc print data=lab_test_c;
run;

/*Discrepency Finding and Removing*/
proc sort data=lab_test_c nodupkey dupout=date_usubjid out=lab_test_ca;
by usubjid lbdtc;
run;

proc print data=lab_test_ca;
run;
/*Sorting variable by lbnrind*/
proc sort data=lab_test_ca out=lab_test_ca1;
by lbtest lbnirnd;
run;

proc print data=lab_test_ca1;
run;

/*Finding _TYPE_ FREQ STAT and MIN MAX */
proc means data=lab_test_ca1;
by lbtest lbnirnd;
/*class lbtest lbnrind*/
var lbstresn; output out=lab_test_c2;
run;

proc print data=lab_test_ca2;
run;

/*After Finding N then Sort by lbtest lbnirnd for entire display*/
proc sort data=lab_test_c2 out=lab_test_c1c;
by lbtest lbnirnd;
run;

proc print data=lab_test_c1c;
run;
/*Read Data from lab_test_c1c and swap data one variable to another*/
data lab_test_c3;
set lab_test_c1c;
page_brk=ceil(_n_/10);/*page_brk for 10 lines*/
col1=lbtest;
col2=lbnirnd;
col3=_stat_;
col4=lbstresn;
run;

proc print data=lab_test_c3;
run;

proc contents data=lab_test_c3;
run;
/*After Sorting the data by page_brk lbtest lbnirnd */
proc sort data=lab_test_c3 out=lab_test_c4;
by page_brk col1 col2;
run;

proc print data=lab_test_c4;
run;

proc report data=lab_test_c4;
column page_brk col1 col2 col3 col4;
define page_brk / Display "No_of_Test";
define col1 / Display "Lab_test";
define col2 / Display "Lab_range";
define col3 / Display"Statistics";
define col4 / Display"Resuls";
run;
/*13.8–17.2 g/dL for men and 12.1–15.1 g/dL for women*/
/*glucose level is 70–99 mg/dL (3.9–5.5 mmol/L), while higher levels can indicate prediabetes or diabetes.*/


/*Finding lbnirnd "HIGH" "LOW" */
data lab_ta;
set lab_test_c;
where lbnirnd in("HIGH","LOW");
run;


proc print data=lab_ta;
run;

proc report data=lab_ta;
column usubjid lbtest lbstresn lbstresu lbnirnd;
define usubjid / group ;
define lbtest / Display;
define lbstresn / Display;
define lbstresu / Display;
define lbnirnd / Display;
run;

/*Sorting Each USUBJID their LBTEST and LBNIRND*/
proc sort data=lab_ta nodupkey dupout=lb_lbnirnd out=lab_ta1;
by usubjid lbtest lbnirnd;
run;

proc print data=lab_ta1;
run;

proc report data=lab_ta1;
column usubjid lbtest lbstresn lbstresu lbnirnd;
define usubjid / group ;
define lbtest / Display;
define lbstresn / Display;
define lbstresu / Display;
define lbnirnd / Display;
run;
