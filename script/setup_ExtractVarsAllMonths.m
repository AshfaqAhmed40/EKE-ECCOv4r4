clear all; close all; clc;
% Elapsed time is 9671.179371 seconds.
tic
%% Define the parent folder containing all the year folders
HOME = '/Volumes/Extreme SSD/EKE/ECCOv4r4 LLC0090/';

%% List all the years
years = 1992:2017;

%% List all the months
months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

%% Loop through each year
for yearIdx = 1:numel(years)
    currentYear = years(yearIdx);
    
    % Display message for the current year
    disp(['Now, in year: ', num2str(currentYear)]);
    
    % Loop through each month
    for monthIdx = 1:numel(months)
        currentMonth = months{monthIdx};
        
        % Define the folder path for the current year and month
        folderPath = fullfile(HOME, num2str(currentYear), currentMonth);
        
        % Check if the folder exists
        if exist(folderPath, 'dir')
            % Change directory to the current month folder
            cd(folderPath);

            % Find NetCDF files in the current month folder
            nc_files = dir('*.nc');
            num_files = numel(nc_files);

            % Check if there are any NetCDF files in the current month folder
            if num_files > 0
                % Initialize cell arrays to store variables
                U = cell(num_files, 1);
                V = cell(num_files, 1);
                W = cell(num_files, 1);

                % Loop through each NetCDF file
                for N = 1:num_files
                    fname = nc_files(N).name;
                    readncfile;

                    % Clear unnecessary variables
                    clear A fname i_g j j_g k k_l k_p1 k_u ll ...
                        XC_bnds YG YC_bnds Z_bnds Zl Zp1 Zu XG XC YC ...
                        time time_bnds

                    % select the required variables
                    Z = round(Z, 2);
                    depth = 37;
                    tile = 7; % arctic slice
                    UVEL = squeeze(UVEL(:,:,tile,1:depth)); UVEL = flip(UVEL);
                    VVEL = squeeze(VVEL(:,:,tile,1:depth)); VVEL = flip(VVEL);
                    WVEL = squeeze(WVEL(:,:,tile,1:depth)); WVEL = flip(WVEL);

                    % Store UVEL and VVEL slices in cell arrays for each time step
                    U{N} = UVEL;
                    V{N} = VVEL;
                    W{N} = WVEL;
                    clear UVEL VVEL WVEL title
                end

                % Save the extracted variables
                save(sprintf('%s_%d.mat', currentMonth, currentYear), 'U', 'V', 'W', 'Z');

                % Display message indicating successful extraction
                fprintf('Variables extracted and saved for %s %d.\n', currentMonth, currentYear);
            else
                % Display error message if there are no NetCDF files in the current month folder
                fprintf('No NetCDF files found in %s %d.\n', currentMonth, currentYear);
            end
        else
            % Display error message if the current month folder does not exist
            fprintf('Folder for %s %d does not exist.\n', currentMonth, currentYear);
        end
    end
end
toc