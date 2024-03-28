clear all; close all; clc;

% This code takes a month (i.e., January) and each month contains the
% velocity fields of all 26 years of that month.

%% Load data
HOME = '/Users/aahmed78/Desktop/PhD/EKE/ECCOv4r4 LLC0090/';
cd(strcat(HOME,'data/'));
load Z.mat
load Jun.mat

%% Calculate EKE for all year's Feb
EKE_climatology = cell(37,26);
EKE_month = cell(37,size(U_stacked,1));
mean_EKE = cell(37,1);


for year = 1992:2017
U_all_depth = U_stacked(:,year-1992+1);
V_all_depth = V_stacked(:,year-1992+1);
W_all_depth = W_stacked(:,year-1992+1);

    for D = 1:37
        %% Extract layer
        depth = D;
        extract_layer = @(x) squeeze(x(:,:,depth));
        U = cellfun(extract_layer, U_all_depth, 'UniformOutput', false);
        V = cellfun(extract_layer, V_all_depth, 'UniformOutput', false);

        %% Mean velocity
        U_m = mean(cat(3, U{:}),3);
        V_m = mean(cat(3, V{:}),3);

        %% EKE = TKE - MKE
        N = numel(U); TKE = cell(N, 1);

        %% calculate EKE for all Feb days of 1992 (i.e.) for layer = 1
            for day = 1:N
                TKE{day} = 0.5.*(U{day}.^2 + V{day}.^2);
                MKE = 0.5 * (U_m.^2 + V_m.^2);
                EKE = TKE{day} - MKE; 
                EKE_month{D,day} = EKE;
            end
            %% Store it!
                    mean_EKE = cell(37, 1);
                    for i = 1:37
                        mean_EKE{i} = mean(cat(3, EKE_month{i,:}),3);
                    end
    end
   [EKE_climatology{:, year-1991}] = deal(mean_EKE{:});
end


%% Note
% EKE_month contains cell with R = 37 rows and C = number of days columns
% Each row refers individual Z depth, 
% and each column refers to the days of the month

% mean_EKE contains 37x1 cell, each cell has the mean EKE of that month
% each row has the mean EKE of that month in each depth level

% EKE_climatology is this month's climatology for the entire duration 
% of the model run; it has 37 rows and 26 column
% Each colum represents each year (1992-2017)
% and each row represents the depth of water
% Each cell contains the monthly average EKE for any given Z