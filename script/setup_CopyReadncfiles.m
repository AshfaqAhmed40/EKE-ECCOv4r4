clear all; close all; clc;

% Define the parent folder containing all the year folders
HOME = '/Users/aahmed78/Desktop/PhD/EKE/ECCOv4r4 LLC0090/';

% List all the years
years = 1992:2017;

% List all the subfolders
subfolders = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

% Path to the script file to be copied
scriptFile = fullfile(HOME, 'readncfile.m'); 
% Assuming the script is located in the parent folder

% Loop through each year
for year = years
    % Define the main folder for the current year
    mainFolder = fullfile(HOME, num2str(year));
    
    % Loop through each subfolder
    for i = 1:numel(subfolders)
        % Create the full path to the destination folder
        destFolder = fullfile(mainFolder, subfolders{i});

        % Create the destination folder if it doesn't exist
        if ~exist(destFolder, 'dir')
            mkdir(destFolder);
        end

        % Define the new filename for the copied script
        destScript = fullfile(destFolder, 'readncfile.m');

        % Copy the script file to the destination folder
        copyfile(scriptFile, destScript);
    end
end
