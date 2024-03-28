clear all; close all; clc;
% In this code, I am trying to calculate the monthly average EKE for the
% month of July 2017. 

%% Load data
HOME = '/Users/aahmed78/Desktop/PhD/EKE/ECCOv4r4 LLC0090/';
cd(strcat(HOME,'data/'));
load Z.mat
load Jun.mat

D = 11;
Y = 1992;
U_all_depth = U_stacked(:,Y-1992+1);
V_all_depth = V_stacked(:,Y-1992+1);
W_all_depth = W_stacked(:,Y-1992+1);
clear U_stacked V_stacked W_stacked 


%% Extract layer
% Define a function to extract the first layer
extract_layer = @(x) squeeze(x(:,:,D));

% Apply the function to each cell in U using cellfun
U = cellfun(extract_layer, U_all_depth, 'UniformOutput', false);
V = cellfun(extract_layer, V_all_depth, 'UniformOutput', false);
% The resultant U and V are the daily mean surface level velocity on the
% depth that we defined

%% Mean velocity
U_m = mean(cat(3, U{:}),3);
V_m = mean(cat(3, V{:}),3);

%% Velocity anomaly
U_anom = cell(size(U,1),1); V_anom = cell(size(U,1),1); 
for i = 1:size(U,1)
    % Subtract the mean velocity field from the daily velocity field
    U_anom{i,1} = U{i} - U_m;
    V_anom{i,1} = V{i} - V_m;
end
% Here, U_anom and V_anom are the U and V anomalies of 31x1 cell size
% Each cell contain the daily anomaly of that month

%% EKE = TKE - MKE
N = numel(U);
EKE_month = cell(N, 1);
TKE = cell(N, 1);

% Loop through each day to calculate EKE
for day = 1:N
    % Calculate Total Kinetic Energy (TKE) for the current day
    TKE{day} = 0.5.*(U{day}.^2 + V{day}.^2);
    
    % Calculate Mean Kinetic Energy (MKE) for the current day
    MKE = 0.5 * (U_m.^2 + V_m.^2);
    
    % Calculate Eddy Kinetic Energy (EKE) for the current day
    EKE_month{day} = TKE{day} - MKE;
end

EKE = mean(cat(3, EKE_month{:}),3);


%% Make movie of EKE
cd(strcat(HOME,'figures/'));
filename = 'movie_MonthlyEKE.gif';
ColorMap = 'ember';
% Create a new figure
figure(1); clf; clc;

for i = 1:N
    %Get the daily EKE
    ekeData = rot90(rot90((EKE_month{i})));
    
    % Landmask
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
    contourf(real(log10(ekeData)), 50, 'edgecolor', 'none');
    shading interp; colorbar;
    colormap(gca, flip(slanCM(ColorMap)));
    title(sprintf('Day %d : EKE at depth %d (m), Year = %d ',i,D,Y), 'FontSize', 20);
     
    box on; 
    set(gca, 'GridLineStyle', '-','LineWidth', 3);
    set(gca, 'Layer', 'top');
    
    % Customize colorbar
    c = colorbar;
    c.FontSize = 20;
    c.FontWeight = 'bold';
    ylabel(c, 'log_{10}EKE (m^2s^{-2})', 'Interpreter', 'tex', 'FontSize', 20);
    PLOT();
    hold on;


    % Save as movie if you want
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    if i == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.5);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.5);
    end
    
    drawnow;  
    pause(0.0005)
end

cd(strcat(HOME,'data/'));

%% Plot monthly mean EKE
figure(2),clf;
t = tiledlayout(1,1); t.TileSpacing = 'tight'; t.Padding = 'compact';

nexttile
% Landmask
landMask = isnan(rot90(rot90(EKE)));
contourf(gca, landMask, 5, 'edgecolor', 'none', 'FaceColor', ...
    [0.75 0.75 0.75]); hold on;
C = contourc(double(landMask), [0.5 0.5]);
while ~isempty(C)
    len = C(2, 1);
    plot(C(1, 2:1+len), C(2, 2:1+len), 'k', 'LineWidth', 3);
    C(:, 1:len+1) = []; hold on;
end
    
% mean EKE
contourf(rot90(rot90(log10(EKE))),150,'edgecolor','none');
set(gca,'color',[0 0 0]);
shading interp;
colormap(gca, flip(slanCM('ember'))); hold on;
title(sprintf('Mean $\\mathbf{\\log_{10}}$(EKE) at depth = %0.2f m', Z(D)),...
    'FontSize', 20, 'Interpreter', 'latex'); hold on;
PLOT();

c = colorbar;
c.FontSize = 20;
c.FontWeight = 'bold';
c.Label.String = 'm$^2$s$^{-2}$'; 
c.Layout.Tile = 'south';
c.Label.Interpreter = 'latex';


%% Function to plot
function PLOT()
    caxis([-5 -2]);
    set(gca,'color',[0 0 0]);
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    hold on;
    set(gca, 'Layer', 'top');
    box on;
    set(gcf, 'Position', [613,412,1030,925]);
    set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
    box on;
    set(gca, 'GridLineStyle', '-','LineWidth', 3);
end
