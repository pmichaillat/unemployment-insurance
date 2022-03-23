* compute the effective replacement rate of the UI program in the US

********* 1. Get historical data on total number of claims by UI program

import excel "data_replacement_rate.xlsx", ///
sheet("Table1-#persons_by_UI_program") firstrow clear

*Create time variables: we aggregate all claims at the monthly level
gen ref=strltrim(ReflectWeek1)
gen year=substr(ref, -4, 4 )
drop if year=="otes"
gen mp=strpos(ref,"/") 
gen md=strrpos(ref,"/") 

gen month=substr(ref, 1, mp-1)
gen day=substr(ref, mp+1, md-mp-1)
gen pb=strpos(day,"/") 
replace day="5" if pb==1

destring month day year, replace

g date=mdy(month, day, year)
format date %td
drop ReflectWeek1 ref year mp md month day pb P Q
drop if _n>1596
destring State2, replace

g month=mofd(date)
format month %tm

/* Classification of claims by UI program*/
destring _all, replace
foreach var in UCFE3 UCX4 EUC19906 TEUC7 EUC08TierI8 ///
EUC08TierIII8 EUC08TierIV8 EUC08Total EB9 StateAB10 STC11 Total{
replace `var'=0 if `var'==.
} 

* Regular UI
g regularUI=State2+UCFE3 + UCX4

/* extended benefits: EB program + specific State programs*/
g EB=EB9+StateAB10

/* Federal extensions */
g fed_extensions=EUC19906 +TEUC7 + EUC08Total

/* we get rid of Short term compesnation STC */
g all_claims=regularUI+EB+fed_extensions

collapse all_claims regularUI EB fed_extensions Total, by(month)
so month
save merged_RRdata, replace


********* 2. Get historical data on employment and unemployment data from CPS
/* employment levels */

import excel "data_replacement_rate.xlsx", ///
 sheet("Table2-CPS-TotalEmploymentLevel") cellrange(A19:D338) firstrow clear
 
 destring Year, replace
 g m_origin=mofd(d(01jan1990))
 g month=m_origin+_n-1
 format month %tm
 g employment=ObservationValue*1000
 
 keep month employment
 so month
 merge month using merged_RRdata
 ta _merge
 keep if _merge==3
 so month
 drop _merge
 save merged_RRdata, replace
 
 
 /* unemployment levels */
import excel "data_replacement_rate.xlsx", ///
 sheet("Table3-CPS-TotalUnempLevel") cellrange(A19:D338) firstrow clear
 
 destring Year, replace
 g m_origin=mofd(d(01jan1990))
 g month=m_origin+_n-1
 format month %tm
 g unemployment=ObservationValue*1000
 
 keep month unemployment
 so month
 merge month using merged_RRdata
 ta _merge
 keep if _merge==3
 so month
 drop _merge
 save merged_RRdata, replace

 /* Import separation rate data from CPS - using Shimer 2012*/
import excel "data_replacement_rate.xlsx", ///
 sheet("Table4-CPS-SeparationRate") firstrow clear
keep if year>=1990
rename month month_old
 g m_origin=mofd(d(01jan1990))
 g month=m_origin+_n-1
 format month %tm
keep month monthlyseparationprobability
so month
 merge month using merged_RRdata
 ta _merge
 keep if _merge==3
 so month
 drop _merge
 save merged_RRdata, replace
 
********* 3. Import financial claim data from State UI Program
import excel "data_replacement_rate.xlsx", ///
sheet("Table5-UIStateClaimData") cellrange(B6:K547) firstrow clear

rename Ending week
rename Payments Number_1stpayments
rename D Number_finalpayments
rename Paid000 Totalbenefitspaid

*create time variable - aggregate data at the monthly level
gen ref=strltrim(week)
gen year=substr(ref, -4, 4 )
gen mp=strpos(ref,"/") 
gen md=strrpos(ref,"/") 

gen month2=substr(ref, 1, mp-1)
destring month  year, replace

g date=mdy(month, 1, year)
format date %td
g month=mofd(date)

keep month Number_1stpayments Number_finalpayments Totalbenefitspaid
so month
 merge month using merged_RRdata
 ta _merge
 keep if _merge==3
 so month
 drop _merge
 save merged_RRdata, replace

 ********* 4. Import job losers data from CPS
 import excel "data_replacement_rate.xlsx", ///
sheet("Table6-CPSJobLosers") cellrange(A21:D340) firstrow clear 

destring Year, replace
 g m_origin=mofd(d(01jan1990))
 g month=m_origin+_n-1
 format month %tm
 g joblosers=ObservationValue/100
 
 keep month joblosers
 so month
 merge month using merged_RRdata
 ta _merge
 keep if _merge==3
 so month
 drop _merge
 save merged_RRdata, replace
 
g claimants=(joblosers)*unemp

g date=dofm(month)
g month2=month(date)

********* 5. Compute replacement rate series. See appendix of the AEJ paper for details

g ratio=Total/claimants

*Control for seasonality: get rid of month fixed effects
char ratio [omit] 12
xi: reg ratio i.month2
predict m, res

g ratio_seas= m+_b[_cons]

preserve
* Determine the average replacement rate WBA/previous wage of individuals collecting benefits from admin data
/* Import replacement rate estimates for individuals collecting UI benefits: */
 import excel "data_replacement_rate.xlsx", ///
sheet("Table7-RRofUIclaimants") firstrow clear
so year quarter
g date=mdy(quarter*3-2, 1, year)
so date
su Replac, d
* Replacement rate WBA/previous wage is very stable among individuals collecting benefits:
* between .458 and 474 with average=.465 and median=.464
* we take .465 as replacement rate WBA/previous wage
restore
* we use the average replacement rate (WBA/previous wage from BLS data (cf. above)
g RRate=min(.5, .465*ratio_seas)

keep month RRate

********* 6. Export historical replacement rate series in .xls
export excel using "effective replacement rate.xlsx", replace
 
 erase merged_RRdata.dta

