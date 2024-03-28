clear all; close all; clc;
% This code creates folders from 1992 to 2017. And in each folder, it
% creates additional 12 sub-folders that are named as the months. 
% Then, it checks all the NetCDF files and move them to their right
% destination. 

%% Define the source directory
HOME = '/Volumes/Extreme SSD/EKE/ECCOv4r4 LLC0090/input/';

% Define the target directories
targetRoot = '/Volumes/Extreme SSD/EKE/ECCOv4r4 LLC0090/';

% Create folder structure for years and months 
for year = 1992:2017
    yearFolder = fullfile(targetRoot, num2str(year));
    if ~exist(yearFolder, 'dir')
        mkdir(yearFolder);
    end
    for month = 1:12
        monthFolder = fullfile(yearFolder, datestr(datenum(year, month, 1), 'mmm'));
        if ~exist(monthFolder, 'dir')
            mkdir(monthFolder);
        end
    end
end

% I am defining the pattern to match the file names
filePattern = 'OCEAN_VELOCITY_day_mean_\d{4}-\d{2}-\d{2}_ECCO_V4r4_native_llc0090\.nc';

% Get a list of all nc files in the source directory
fileList = dir(fullfile(HOME, '*.nc'));

% Loop through each file and move it to its respective folder
for i = 1:numel(fileList)
    fileName = fileList(i).name;
    if regexp(fileName, filePattern)
        % Extract year and month from the file name
        tokens = regexp(fileName, '(\d{4})-(\d{2})-\d{2}', 'tokens');
        year = str2double(tokens{1}{1});
        month = str2double(tokens{1}{2});
        
        % Define the target directory
        targetDir = fullfile(targetRoot, num2str(year), datestr(datenum(year, month, 1), 'mmm'));
        
        % Yayy, moving the file
        try
            movefile(fullfile(HOME, fileName), targetDir);
        catch ME
            disp(['Error moving file: ', ME.message]);
        end
    end
end

disp('Files moved successfully. You are the best!');
