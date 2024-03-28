clear all; close all; clc;
tic
%% Get the data
HOME = '/Users/aahmed78/Desktop/PhD/EKE/ECCOv4r4 LLC0090/';
cd(strcat('2010/Jan/'));

nc_files = dir('OCEAN_VELOCITY_day_mean_2010-01-*.nc');
num_files = numel(nc_files);


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

save('Jan_2010.mat','U', 'V', 'W', 'Z')
toc