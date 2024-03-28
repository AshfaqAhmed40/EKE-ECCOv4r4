clear all; close all; clc;

% Define the parent folder containing all the year folders
HOME = '/Volumes/Extreme SSD/EKE/ECCOv4r4 LLC0090/';

% List all the years
years = 1992:2017;

% List all the months
months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

% Loop through each month
for monthIdx = 1:numel(months)
    currentMonth = months{monthIdx};
    fprintf('\n'); % Add a new line
    % Display message for the current month
    disp(['Now, processing month: ', currentMonth]);
    fprintf('\n'); % Add a new line
    
    % Initialize a flag to check if any .mat file is found for the current month
    foundMatFile = false;
    
    % Determine the number of days in the current month for each year
    switch currentMonth
        case {'Jan', 'Mar', 'May', 'Jul', 'Aug', 'Oct', 'Dec'}
            numDays = 31;
        case {'Apr', 'Jun', 'Sep', 'Nov'}
            numDays = 30;
        case 'Feb'
            % Check for leap year
            % leapYear = mod(years, 4) == 0 & (mod(years, 100) ~= 0 | mod(years, 400) == 0);
            % numDays = 28 + leapYear;
            numDays = 28;
    end
    
    % Initialize stacked cells based on the number of days in the current month and number of years
    U_stacked = cell(numDays, numel(years));
    V_stacked = cell(numDays, numel(years));
    W_stacked = cell(numDays, numel(years));

                
    % Loop through each year
    for yearIdx = 1:numel(years)
        currentYear = years(yearIdx);
        
        % Find the index of the current year in the years array
        yearIndex = find(years == currentYear);
        
        % Display message for the current year
        disp(['Looking at year: ', num2str(currentYear)]);
        
        % Define the folder path for the current year and month
        folderPath = fullfile(HOME, num2str(currentYear), currentMonth);
        
        % Check if the folder exists
        if exist(folderPath, 'dir')
            % Check if there's a .mat file in the current month folder
            matFiles = dir(fullfile(folderPath, '*.mat'));
            if ~isempty(matFiles)
                % Load the .mat file
                load(fullfile(folderPath, matFiles(1).name));
                
                % Stack the variables
                U_stacked(:, yearIndex) = U;
                V_stacked(:, yearIndex) = V;
                W_stacked(:, yearIndex) = W;
                
                % Set the flag to true
                foundMatFile = true;
            end
        end
    end

    % Check if any .mat file was found for the current month
    if ~foundMatFile
        % Display error message
        fprintf('No .mat file found for %s.\n', currentMonth);
    else
        % Define the output folder path
        outputFolder = fullfile(HOME, 'Stacked',[currentMonth '.mat']);

        % Save the stacked variables
        save(outputFolder, 'U_stacked', 'V_stacked', 'W_stacked');
    end
    clear U_stacked V_stacked W_stacked U V W
end
