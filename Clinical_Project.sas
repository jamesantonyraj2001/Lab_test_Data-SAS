proc import datafile="C:\Users\GEORGE JENIF\Downloads\Clinical_project\Clinical_Project - Lab_data.xlsx" out=lab_test 
dbms=xlsx replace;
sheet="Table 1 - Data Set WORK.LAB_";
run;
/*Variable types display*/
proc contents data=lab_test;
run;
/*conditions for lbstnlo & lbstnhi & lbstresn*/
data lab_test_c;
length lbnirnd $200.;
set lab_test;
if not missing(lbstnrlo) and not missing(lbstnrhi) then do;
if lbstnrlo<=lbstresn<=lbstnrhi then lbnirnd="NORMAL";
else if lbstresn>lbstnrhi then lbnirnd="HIGH";
else if lbstresn<lbstnrlo then lbnirnd="LOW";
end;
if missing(lbstnrlo) and not missing(lbstnrhi) then do;
if .<lbstresn<=lbstnrhi then lbnirnd="NORMAL";
else if lbstresn>lbstnrhi then lbnirnd="HIGH";
end;
if missing(lbstnrhi) and not missing(lbstnrlo) then do;
if lbstnrlo<=lbstresn then lbnirnd="NORMAL";
else if lbstresn<lbstnrlo then lbnirnd="LOw";
end;
run;

proc print data=lab_test_ca;
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

/*Finding _TYPE_ FREQ STAT N and MIN MAX */
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

data lab_test_c3;
set lab_test_c1c;
page_brk=ceil(_n_/10);
col1=lbtest;
col2=lbnirnd;
col3=_stat_;
col4=strip(put(round(lbstresn,0.0001),best.));
keep page_brk col:;
run;

proc print data=lab_test_c3;
run;

proc sort data=lab_test_c3 out=lab_test_c4;
by page_brk col1 col2;
run;


ods rtf file="C:\Users\GEORGE JENIF\Downloads\Clinical_project\lab_range.rtf";
ods escapechar="^";
proc report data=lab_test_c4 headline headskip missing split="~" spacing=0
style(header)={just=left asis=on} style(column)={just=left asis=on}
style(report)=[frame=hsides width=100%];
column page_brk col1 col2 col3 col4;
define page_brk / order order=data noprint;
define col1 / order order=internal;

define col1/"Lab_test" order style(header)={just=1 asis=on}
style(column)=[just=1 cellwidth=10 % asis=on];

define col2/"Lab_range" order style(header)={just=1 asis=on}
style(column)=[just=1 cellwidth=10 % asis=on];

define col1/"Statistics" order style(header)={just=1 asis=on}
style(column)=[just=1 cellwidth=10 % asis=on];

define col1/"Resuls" order style(header)={just=1 asis=on}
style(column)=[just=1 cellwidth=10 % asis=on];

compute before page_brk;
Line '';
endcomp;
compute after page_brk;
Line '';
endcomp;
break after page_brk/page;
run;
ods rtf close;
ods listing;




