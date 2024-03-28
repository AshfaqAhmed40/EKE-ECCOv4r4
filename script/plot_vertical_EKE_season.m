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

% Define custom legend labels and colors
legend_labels = {'Fram Strait', 'Canadian Archipalego', 'Beaufort Sea', 'Laptev Sea', 'Barents Sea'};
Legend_color = {'r', 'k', [0,204,255]/255, [70,148,73]/255, [255,204,153]/255};
ColorMap = 'ember';
F = 15;

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

%% practice
% clf; clc;
% % only taking January, from all depth, all years
% Fram = log10(cell2mat(squeeze(FramStrait_vert(:,:,3))));
% Canada = log10(cell2mat(squeeze(Canada_vert(:,:,3))));
% Beaufort = log10(cell2mat(squeeze(Beaufort_vert(:,:,3))));
% Laptev = log10(cell2mat(squeeze(Laptev_vert(:,:,3))));
% Barents = log10(cell2mat(squeeze(Barents_vert(:,:,3))));

%% Compute mean and standard deviation along rows
clf; clc; close all;
tiledlayout(4, 3, 'TileSpacing', 'tight', 'Padding', 'tight');

for Month = 1:12
    figure(1),
    nexttile;
% only taking January, from all depth, all years
regions = {'Fram', 'Canada', 'Beaufort', 'Laptev', 'Barents'};
data = {log10(cell2mat(squeeze(FramStrait_vert(:,:,Month)))), ...
        log10(cell2mat(squeeze(Canada_vert(:,:,Month)))), ...
        log10(cell2mat(squeeze(Beaufort_vert(:,:,Month)))), ...
        log10(cell2mat(squeeze(Laptev_vert(:,:,Month)))), ...
        log10(cell2mat(squeeze(Barents_vert(:,:,Month))))};
Legend_color = {'r', 'k', [0,204,255]/255, [70,148,73]/255, [255,204,153]/255};

% Compute mean and standard deviation along rows for each region
Layer = 20;
x = Z(1:Layer); x = x';
hold on;

    for i = 1:length(regions)

        if Month == 7
           data{i}(:,26) = 0; 
        mean_values = mean(data{i}(1:Layer,1:25), 2); mean_values = mean_values';
        sd = std(data{i}(1:Layer,1:25), 0, 2); sd = sd';
        else

        mean_values = mean(data{i}(1:Layer,:), 2); mean_values = mean_values';
        sd = std(data{i}(1:Layer,:), 0, 2); sd = sd';
        end
        % Plot mean values with specified color
        plot(mean_values, x, 'Color', Legend_color{i}, 'linewidth', 3); hold on;

        % Create shaded patch for standard deviation
        patch([mean_values + sd, fliplr(mean_values - sd)], [x, fliplr(x)], Legend_color{i}, 'edgecolor','none','FaceAlpha', 0.25);

    end

hold off;
% Set plot properties
xlabel('log_{10}EKE (m^2s^{-2})');
if ismember(Month, [1,4,7,10])
    ylabel('Depth (m)');
else
    set(gca, 'YTickLabel', []);
end

if ismember(Month, [1,2,3,4,5,6,7,8,9])
    set(gca, 'XTickLabel', []);
    xlabel(''); % Set xlabel to an empty string
end
grid on

%title('Vertical Profiles of Averaged EKE');
PLOT();

end
%% Function to plot
function PLOT()
    xlim([-6 -2.25]);
    ylim([-300 -5]);
    set(gca,'fontsize',15)
    hold on;
    set(gca, 'Layer', 'top');
    box on;
    set(gcf, 'Position', [3205,318,808,1013]);
    set(gca, 'GridLineStyle', '-',  'LineWidth', 3,'MinorGridLineStyle', ':', 'LineWidth', 1);
    box on;
    set(gca, 'GridLineStyle', '-','LineWidth', 3);
end