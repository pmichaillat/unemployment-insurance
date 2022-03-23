# A Macroeconomic Approach to Optimal Unemployment Insurance: Applications - Code and Data

This repository contains the code and data accompanying the paper "A Macroeconomic Approach to Optimal Unemployment Insurance: Applications", written by [Camille Landais](https://www.lse.ac.uk/economics/people/faculty/camille-landais), [Pascal Michaillat](https://pascalmichaillat.org), and [Emmanuel Saez](https://eml.berkeley.edu/~saez/), and published in the [American Economic Journal: Economic Policy](https://doi.org/10.1257/pol.20160462) in May 2018. 

## Paper webpage

The paper and its online appendix are available at https://pascalmichaillat.org/5/.

## Data

The data are stored in three Excel workbooks.

+ `data_recruiter_producer_ratio.xlsx` contains the data used to construct the
alternative measures of recruiter-producer ratio. The data are used by `construct_recruiter_producer_ratio.m`. The workbook contains five worksheets:
	+ `CES` contains US data from the BLS Current Employment Statistics (CES) survey for 1990–2014.
	+ `JOLTS` contains US data from the BLS Job Openings and Labor Turnover Survey (JOLTS) for 2001–2014.
	+ `Barnichon (2010)` contains the help-wanted index constructed by Barnichon (2010) for the United States, 1990–2014.
	+ `CPS` contains US data from the BLS Current Population Survey (CPS) for 1990–2014.
 	+ `NBER` contains US recession dates constructed by the NBER business-cycle dating committee.
+ `data_replacement_rate.xlsx` contains the data used to construct the effective replacement rate of the UI program in the United States. The data are used by `construct_replacement_rate.do`. A `readme` sheet at the beginning of the workbook describes the different sheets and explains the sources of the data.
+ `statistics.xlsx` contains the effective UI replacement rate and the measures of recruiter-producer ratio constructed in the paper. It also contains intermediate statistics, constructed in the process. This workbook contains seven worksheets:
	+ `effective replacement rate` contains the effective UI replacement rate constructed by `construct_replacement_rate.do`.
	+ `vacancies` contains the number of vacancies obtained by rescaling the help-wanted index from Barnichon (2010) using vacancies measured in JOLTS data. This series is constructed by `construct_recruiter_producer_ratio.m`.
	+ `vacancy-unemployment ratio` is obtained by dividing the series in `vacancies` by the unemployment level in CPS data. This series is constructed by `construct_recruiter_producer_ratio.m`.
	+ `labor market flows` contains series for the monthly job-finding rate, monthly job-separation rate, and monthly vacancy-filling rate. Some of the series are constructed from CPS data and others from JOLTS data. These series are constructed by `construct_recruiter_producer_ratio.m`.
	+ `recruiter-producer ratio` contains the four series for the recruiter-producer ratio. These series are constructed by `construct_recruiter_producer_ratio.m`.
	+ `unemployment rate` reports the unemployment rate from CPS data.
	+ `tau-u ratio` is obtained by dividing the synthetic recruiter-producer ratio in `recruiter-producer ratio` by the series in `unemployment rate`. This series is constructed by `construct_recruiter_producer_ratio.m`.

## Code

The results are obtained using Stata and MATLAB.

+ The Stata script `construct_replacement_rate.do` constructs the effective replacement rate of the UI program in the United States for 1990–2014. The procedure to construct the effective replacement rate is described in Section II.B and Online Appendix C.
+ The MATLAB helper scripts `format_figure.m`, `format_simulation.m`, and `format_big.m` contain code to format the MATLAB figures.
+ The MATLAB function `quarter.m` transforms a monthly time series into a quarterly time series.
+ The MATLAB script `construct_recruiter_producer_ratio.m` constructs the three alternative measures of recruiter-producer ratio, the synthetic measure of recruiter-producer ratio, as well as intermediate statistics. The procedures to construct the various measures of recruiter-producer ratio and the intermediate statistics are described in Section II.A and Online Appendix B.
+ The MATLAB script `plot_statistics.m` uses the data in `statistics.xlsx` to produce several figures from the article and online appendix:
	+ Figures 1: panels A and B
	+ Figure 2
	+ Figure 3
	+ Figure 5
	+ Figure 6
	+ Figure A1: panels A, B, C, and D
+ The MATLAB script `solve_formula.m` uses the sufficient statistics in `statistics.xlsx` and the sufficient-statistic formula in the article to solve for the optimal UI replacement rate in the United States over the 1990–2014 period. The formula and procedure to solve it are described in Section IV.B. The results are displayed in Figure 7. The script also performs the sensitivity analysis described in Section IV.C and Online Appendix F. The results of the sensitivity analysis are reported in Figure 8.
+ The MATLAB script `simulation_ui.m` simulates the job-rationing model of [Michaillat (2012)](https://pascalmichaillat.org/1/) under various UI programs: when UI is given by the exact optimal formula (formula (11)); when UI is given by the approximate optimal formula (formula (21)); when UI is given by the Baily-Chetty formula; and when UI is constant at a replacement rate of 42%. The simulations allow us to assess the accuracy of the approximate formula (21) and to compute the welfare gains from optimal UI. The simulations are described in Sections IV.D and IV.E and in Online Appendix H. The calibration of the simulation model is described in Online Appendix G. The script produces several figures from the article and online appendix:
	+ Figure 9
	+ Figure 10 
	+ Figure A2

## Software

The results were obtained using MATLAB R2017a and Stata 14 on macOS Sierra.

## License

This repository is licensed under the [MIT License](LICENSE.md).