# EKE-ECCOv4r4
Script description:
The scripts should maintain the serial as it is mentioned here. 

%% Folder creation
setup_CreateFolders.m creates 26 folders from 1992 to 2017. And in each of these folders, it creates 12 more sub-folders: ‘Jan’, ‘Feb’, ‘Mar’, …, ‘Nov’, and ‘Dec’. The other half of the code moves all the downloaded NetCDF files to their respective folders. For example, the .nc file named as 

“OCEAN_VELOCITY_day_mean_2010-01-06_ECCO_V4r4_native_llc0090” 

will be moved to 
HOME = ‘/Users/aahmed78/…/Jan’ folder

Similarly, the .nc file named as 

“OCEAN_VELOCITY_day_mean_2017-07-29_ECCO_V4r4_native_llc0090” 

will be moved to 
HOME = ‘/Users/aahmed78/…/Jul’ folder

setup_CopyReadncfiles.m makes a copy of the MATLAB function ‘readncfile.m’ in all the folders and subfolders. This function is very important when reading a NetCDF file and extracting variables from it. 

%% Variable extraction
setup_ExtractVarsSingleMonth.m is a sample example code to help me understand how I am going to extract variables from each NetCDF file. Note that each NetCDF file contains many variables. However, to calculate the EKE, I really need U, V, W, and depth. Therefore, I am extracting the important variables from the NetCDF file to a) save a lot of memory, b) keep my workspace clean, and c) make the computation faster. 

setup_ExtractVarsAllMonths.m is a powerful script. I spent a lot of time writing it. Using this code, we actually iterate through each year, and within that year, each month, and then extract the essential variables from the .nc files from that month. Finally, this code saves the important variables (i.e., U, V, W, Z) in this format ‘mmm_yyyy.mat’. For example, ‘Jul_2017.mat’, or ‘Sep_2011.mat’, etc. It also shows a flag if there is no NetCDF file existing in the folder. I do not have to save any variable from the workspace manually. Rather, this code automatically saves the important variables from each .nc file and stores them in their respective directories. 

%% Putting things together 
setup_StackMonths.m is a tricky one. It will iterate year by year, and each year, it will go month by month. The purpose of this code is to make a collection of monthly U, V, and W with the depth level. To illustrate, at the end of running this code, I will end up with only 12 mat files. The files will be named Jan.mat, Feb.mat, Mar.mat,..., Dec.mat, etc.  Each of these mat files will contain all U, V, and W’s for all 26 years. They are typically heavy in size (e.g., ~1.62 GB)

For example, when I call Jan.mat file, it will give me three variables, ‘U_Stacked’, ‘V_Stacked’, and ‘W_Stacked’. If I open the U_Stacked, I will see something like this -

Jan.mat file contains January U for all 26 years.

Year
1992
1993
1994
…
2016
2017
Day
1
90x90x37
90x90x37
90x90x37
….
90x90x37
90x90x37
2
90x90x37
90x90x37
90x90x37
….
90x90x37
90x90x37
…
…
…
…
…
…
…
30
90x90x37
90x90x37
90x90x37
….
90x90x37
90x90x37
31
90x90x37
90x90x37
90x90x37
….
90x90x37
90x90x37



U_stacked is a 31x26 cell. 
U_stacked{1,1} contains all U velocity of all depth layers for January 1, 1992
U_stacked{2,1} contains all U velocity of all depth layers for January 2, 1992
U_stacked{2,2} contains all U velocity of all depth layers for January 2, 1993
U_stacked{9,8} contains all U velocity of all depth layers for January 9, 1999

The same goes for V_stacked and W_stacked for the rest of the .mat files. 

%% Visualizing

movie_MonthlyEKE.m picks a month (e.g., June mat) and calculates the daily EKE from the daily U and V velocity field. Then, it plays a movie that shows how EKE varies throughout the month. Before playing the movie, you will have the option to select the depth layer (D) and the year (Y). 


Fig: Monthly mean EKE for June 1992 at a depth of 105 m

%% Climatology calculation
setup_EKE_Climatology.m picks a month (e.g., Jun.mat) and then computes for the EKE climatology. At the end of the code, it stores the selected month’s mean EKE field. There are three important variables for this code:
EKE_month contains cell with R = 37 rows and C = number of days columns. Each row refers individual Z depth,  and each column refers to the days of the month
 
mean_EKE contains 37x1 cell, each cell has the mean EKE of that month and each row has the mean EKE of that month in each depth level.
 
EKE_climatology is this month's climatology for the entire duration  of the model run; it has 37 rows and 26 column. Each colum represents each year (1992-2017) and each row represents the depth of water.

Please note that, everytime we run the code, we need to save the variable ‘EKE_climatology’ for that month. And we need to save the variable as ‘<month name>_Climatology.mat’ in the ‘HOME/data’ directory. 

For example, if I call Jun.mat before running this code, I need to save the EKE_climatology variable from the workspace as ‘June_Climatology.mat’ in the ‘HOME/data’ directory. But we do not need to do it now, as the ‘HOME/data’ directory already contains all twelve month’s climatology .mat files. In other words, I ran this code 12 times for all 12 months and saved the variables separately. (Could be smarter, but *phew*!)

plot_EKE_Climatology.m calls ALL months climatology variables (the twelve climatology variables that we saved in setup_EKE_Climatology.m) and make a compilation which is called ‘EKE’. At the end of teh run, you need to save this variable ‘EKE’ for the next scripts. 

‘EKE.mat’  is one of the most important variable for this study and it requires it own attentions. It is a 1x12 size cell and it stores all twelve months mean EKE field at each Z level. The file structure of the EKE.mat is as follows - 

EKE.mat file contains monthly mean EKE field for all 12 months
When you open it, it looks like -

Dec
Jan
Feb
Mar
Apr
May
Jun
Jul
Aug
Sep
Oct
Nov
37x26
37x26
37x26
37x26
37x26
37x26
37x26
37x26
37x26
37x26
37x26
37x26


Note that, each month’s cell contains another cell within it. The inside cell is of 37x26 size. Where 37 represents the Z levels and 26 indicates all years from 1992 to 2017.

If you go inside the cell of December (which is EKE{1,1}), you will see it contains -

Year (Dec)
1992
1993
1994
…
2016
2017
Depth
1
90x90
90x90
90x90
….
90x90
90x90
2
90x90
90x90
90x90
….
90x90
90x90
…
…
…
…
…
…
…
36
90x90
90x90
90x90
….
90x90
90x90
37
90x90
90x90
90x90
….
90x90
90x90


The 1st row of colum of 2 represents the January of 1992 mean field of EKE at Z = 1.
The 2nd row of colum of 2 represents the January of 1992 mean field of EKE at Z = 2.
The 5th row of colum of 4 represents the January of 1996 mean field of EKE at Z = 1.

Similarly,  if you go inside the cell of January (which is EKE{1,2}), you will see it contains

Year (Jan)
1992
1993
1994
…
2016
2017
Depth
1
90x90
90x90
90x90
….
90x90
90x90
2
90x90
90x90
90x90
….
90x90
90x90
…
…
…
…
…
…
…
36
90x90
90x90
90x90
….
90x90
90x90
37
90x90
90x90
90x90
….
90x90
90x90


The description remains the same.


The plot from this code looks like this -

This 4x3-size plot demonstrates the mean EKE for every month. For example, the January mean was calculated by averaging ALL years (1992-2017) January EKE. The same is true for the rest of the months. We can see some regional seasonality, especially in the low SIC zones. 
 


plot_EKE_Climatology.m is an interesting script. It first selects five regions in the ECCOv4r4 Arctic tile. The regions are a) Fram Strait, b) Canadian Archipelago, c) Beaufort Sea, d) Laptev Sea, and e) Barents Sea. Then, it plots (both spatial and temporal) trends in the monthly mean EKE from year 1992 to the year 2017. 


Fig: The animation of the evolution of the monthly mean EKE in five important Arctic regions.

Important takeaway from this script is, by the end of the code, you need to save these five variables as ‘EKE_Locations.mat’ for the next script -

‘Fram_values’, ‘Canada_values’, ‘Beaufort_values’, ‘Laptev_values’, ‘Barents_values’. These variables are important for the next script where I will plot the power spectra from the monthly EKE signal. 

Each od these variables are of 312x1 size and they store the monthly mean EKE maps of all 312 months (1992-2017). 


plot_power_spectra.m calls the five variables that we saved in the previous script and it generates this figure -


Fig: Trends in the EKE and their corresponding power spectra.


