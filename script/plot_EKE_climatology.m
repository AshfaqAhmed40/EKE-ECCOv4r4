clear all; close all; clc;

% This code calls the climatology files for any given month and plots the
% mean EKE at the level we define.

%% Load data
HOME = '/Users/aahmed78/Desktop/PhD/EKE/ECCOv4r4 LLC0090/';
cd(fullfile(HOME, 'data/'));
load Z.mat
EKE = cell(1, 12);
months = {'December', 'January', 'February', 'March', 'April', 'May', 'June', ...
          'July', 'August', 'September', 'October', 'November'};
for i = 1:12
    fileName = [months{i}, '_Climatology.mat'];
    load(fileName);
    EKE{i} = EKE_climatology;
end


%% Plot EKE at depth = D
D = 1; Y = 1;
close all
figure(1),clf;
t = tiledlayout(4,3);
t.TileSpacing = 'tight';
t.Padding = 'compact';
for i = 1:12
    
    % plot EKE field
    nexttile;
    ekeData = rot90(rot90(log10(EKE{i}{D,Y})));
    landMask = isnan(ekeData);
    contourf(ekeData, 50, 'edgecolor', 'none');
    shading interp;
    colormap(gca, flip(slanCM('ember'))); 
    hold on;
    
    % Landmask
    C = contourc(double(landMask), [0.5 0.5]); 
    while ~isempty(C)
        len = C(2, 1);
        plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 1);
        C(:, 1:len+1) = [];
    end
    hold off;
    PLOT();
end

c = colorbar;
c.FontSize = 25;
c.FontWeight = 'bold';
c.Label.String = 'log_{10}EKE (m^2s^{-2})'; 
c.Layout.Tile = 'south';


%% Function to plot
function PLOT()
    caxis([-3.75 -1.75]);
    set(gca,'color',[0.75 0.75 0.75]);
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    hold on;
    set(gca, 'Layer', 'top');
    box on;
    set(gcf, 'Position', [3205,318,808,1013]);
    set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
    box on;
    set(gca, 'GridLineStyle', '-','LineWidth', 3);
end