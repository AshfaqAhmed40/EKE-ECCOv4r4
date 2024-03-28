clear all; close all; clc;
% This script plots the vertically integrated EKE
%% Load data
HOME = '/Users/aahmed78/Desktop/PhD/EKE/ECCOv4r4 LLC0090/';
cd(strcat(HOME,'data/'));
load EKE.mat
load Z.mat

%% Select locations
Loc = zeros(5, 2);    % Set up for  the locations  
Loc(1, :) = [18, 41]; % Fram Strait
Loc(2, :) = [57, 26]; % Canadian Archipelago
Loc(3, :) = [81, 42]; % Beaufort Gyre
Loc(4, :) = [61, 71]; % Laptev Sea
Loc(5, :) = [7, 60]; % Barents Sea
Position = 90-Loc;

% datetime, depth
M = 1; Y = 1992; D = 1;

% Define custom legend labels and colors
legend_labels = {'Fram Strait', 'Canadian Archipalego', 'Beaufort Sea', 'Laptev Sea', 'Barents Sea'};
Legend_color = {'r', 'k', [0,204,255]/255, [70,148,73]/255, [255,204,153]/255};
ColorMap = 'ember';
F = 15;


% Show map
figure(1); clf;
ekeData = rot90(rot90(log10(EKE{1,M}{D,Y-1992+1})));
landMask = isnan(ekeData);
contourf(gca, landMask, 5, 'edgecolor', 'none', 'FaceColor', ...
    [0.75 0.75 0.75]); hold on;
C = contourc(double(landMask), [0.5 0.5]);
while ~isempty(C)
    len = C(2, 1);
    plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 3);
    C(:, 1:len+1) = []; hold on;
end

% Plot the EKE at depth = D
contourf(ekeData, 50, 'edgecolor', 'none');
shading interp;
colormap(gca, flip(slanCM(ColorMap)));
title(sprintf('Year = %d, Month = %d, Z = %d', Y, M, D), 'FontSize', F);

% Show locations in the figure
for idx = 1:size(Position, 1)
    newRow = size(ekeData, 1) - Position(idx, 1) + 1;
    newCol = size(ekeData, 2) - Position(idx, 2) + 1;
    xCoords = [newCol-1.5, newCol+1.5, newCol+1.5, newCol-1.5];
    yCoords = [newRow-1.5, newRow-1.5, newRow+1.5, newRow+1.5];
    
    colorIdx = mod(idx - 1, 5) + 1; % Cycle through 1 to 5
    color = Legend_color{colorIdx};
    
    % Create patch with single color
    patch(xCoords, yCoords, color, 'EdgeColor', 'k', 'linewidth', 1);
end
c = colorbar;
c.FontSize = F;
c.FontWeight = 'bold';
ylabel(c, 'log_{10}EKE (m^2s^{-2})', 'Interpreter', 'tex', 'FontSize', 15);
PLOT();
hold on;

%% Vertical EKE profile
FramStrait_vert = cell(37, 26, 12);  % depth, years, monhts
Canada_vert = cell(37, 26, 12);
Beaufort_vert = cell(37, 26, 12);
Laptev_vert = cell(37, 26, 12);
Barents_vert = cell(37, 26, 12);

% For all 5 locations: all depth level, 1992-2017, all months
for D = 1:37
    for Y = 1992:2017
        for M = 1:12 
            FramStrait_vert{D, Y-1992+1, M} = EKE{M}{D, Y-1992+1}(Position(1,1), Position(1,2));
            Canada_vert{D, Y-1992+1, M} = EKE{M}{D, Y-1992+1}(Position(2,1), Position(2,2));
            Beaufort_vert{D, Y-1992+1, M} = EKE{M}{D, Y-1992+1}(Position(3,1), Position(3,2));
            Laptev_vert{D, Y-1992+1, M} = EKE{M}{D, Y-1992+1}(Position(4,1), Position(4,2));
            Barents_vert{D, Y-1992+1, M} = EKE{M}{D, Y-1992+1}(Position(5,1), Position(5,2));
        end
    end
end

%% Vertical Profile for all five locations
Vertical_Profile = cell(5,12); % 5 locations, 12 months
Mean_Profile = cell(5,12); % 26 years mean in all 5 locations
Std_Profile = cell(5, 12); % 26 years std in all 5 locations

clc;
% store the vertical profiles for all 12 months
for M = 1:12
    Vertical_Profile{1,M} = log10(cell2mat(FramStrait_vert(:,:,M))); % Fram Starit
    Vertical_Profile{2,M} = log10(cell2mat(Canada_vert(:,:,M))); % Canada
    Vertical_Profile{3,M} = log10(cell2mat(Beaufort_vert(:,:,M))); % Beaufort
    Vertical_Profile{4,M} = log10(cell2mat(Laptev_vert(:,:,M))); % Laptev
    Vertical_Profile{5,M} = log10(cell2mat(Barents_vert(:,:,M))); % Barents
end

% store the means and std for individual months (mean over 26 years)
for j = 1:5
    for M = 1:12
    Mean_Profile{j,M} = mean(Vertical_Profile{j,M}, 2);
    Std_Profile{j,M} = std(Vertical_Profile{j, M}, 0, 2);
    end
end

%% Reaarange before plotting
% Initialize a new cell array to store rearranged profiles
Mean = cell(5, 12);
sd = cell(5,12);

% Rearrange each profile in Mean_Profile
for j = 1:5
    for M = 1:12
        % Extract current profile
        profile = Mean_Profile{j, M};
        % Rearrange the profile
        Mean{j, M} = profile';
        
        profile = Std_Profile{j, M};
        sd{j, M} = profile';
    end
end


%% Plot
clf; clc; close all;
x = 1:37;
cmap1 = slanCM('heat'); 
stepSize = floor(size(cmap1, 1) / 12);

% Define location names
locations = {'Fram Strait', 'Canadian Archipelago', 'Beaufort Sea', 'Laptev Sea', 'Barents Sea'};

% Create tiled layout
tiledlayout(1, 5, 'TileSpacing', 'tight', 'Padding', 'tight');

for Loc = 1:5
    % Select next tile in the layout
    nexttile;
    
    for M = 1:12
        colorIndex = (M - 1) * stepSize + 1;
        plot(Mean{Loc,M}, x, 'LineWidth', 3, 'Color', cmap1(colorIndex, :)); 
        hold on;
        set(gca, 'YDir', 'reverse');
        yticks(x); 
        yticklabels(num2str(round(Z)));
    end
    
    % Add labels and title
    xlabel('log_{10}EKE (m^2s^{-2})', 'Interpreter', 'tex','fontsize',18);
    ylabel('Depth (m)','fontsize',18);
    set(gca,'fontsize',12);
    title(locations{Loc},'fontsize',26);
    %xlim([-6 -1]); 
    ylim([1 37]);
    
    set(gca, 'Layer', 'top');
    box on;
    set(gca, 'GridLineStyle', '-','LineWidth', 3);
end

% Create common legend outside the tiled layout
legend('January', 'February', 'March', 'April', 'May', 'June', 'July', ...
    'August', 'September', 'October', 'November', 'December', ...
    'Location', 'southeast','fontsize', 12)

    box on;
    set(gcf, 'Position', [623,703,1964,500]);
    set(gca, 'GridLineStyle', '-','LineWidth', 3);

%% Variable descriptions

% Vertical_Profile is a 5x12 cell (R = 5, C = 12)
% Each row represents a location (i.e., Fram Strait, Barents Sea)
% Each coloum cell contains 37x26 double size. 
% Here, 37 = depth level, and 26 = year
% Therefore, 'Vertical_Profile' cell contains the monthly mean EKE of each 
% depth-level for all 26 years, for all 12 months, in all 5 locations

% Mean_Profile is a 5x12 cell (R = 5, C = 12)
% Each row represents a location (i.e., Fram Strait, Barents Sea)
% Each coloum cell contains 37x1 double size. 
% Here, 37 = depth level, and 1 = mean EKE value for all 26 years
% Therefore, 'Mean_Profile' cell contains the yearly averaged EKE of each 
% depth-level for all 12 months, in all 5 locations






%% Function to plot
function PLOT()
    caxis([-4 -2]);
    %set(gca,'color',[0.75 0.75 0.75]);
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    hold on;
    set(gca, 'Layer', 'top');
    box on;
    set(gcf, 'Position', [597,596,701,607]);
    set(gca, 'GridLineStyle', '-','LineWidth', 3);
end