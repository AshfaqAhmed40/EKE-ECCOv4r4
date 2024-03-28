clear all; close all; clc;
% This script calls the monthly mean EKE values of all 5 locatiosn and
% computes their power spectra using welch's method 

%% Load data
HOME = '/Users/aahmed78/Desktop/PhD/EKE/ECCOv4r4 LLC0090/';
cd(strcat(HOME,'data/'));
load EKE_Locations.mat

%% Asisgn variable
% EKE values for the five locations
EKE_FramStrait = Fram_values;
EKE_CanadianArchipalego = Canada_values;
EKE_BeaufortSea = Beaufort_values;
EKE_LaptevSea = Laptev_values;
EKE_BarentsSea = Barents_values;

%% Time axis (assuming monthly data)
time = 1:312; 

% Legend, colors, and linewidth
legend_labels = {'Fram Strait', 'Canadian Archipalego', 'Beaufort Sea', 'Laptev Sea', 'Barents Sea'};
colors = {'r', 'k', [0,204,255]/255, [70,148,73]/255, [255,204,153]/255};
line_widths = [2, 3.5, 3, 2.5, 2];

% Initialize figure
figure(1); 
close all;  clf;
tiledlayout(2,1, 'TileSpacing', 'tight', 'Padding', 'tight');
nexttile

% Loop through the five locations to plot the EKE values
for i = 1:5
    % Select the current EKE values, corresponding color, and line width
    current_EKE = eval(['EKE_', strrep(legend_labels{i}, ' ', ''), '(:)']);
    current_color = colors{i};
    current_line_width = line_widths(i);
    
    % Plot the EKE values for the current location with specified line width
    plot(time, current_EKE, 'Color', current_color, 'LineWidth', current_line_width);
    hold on;
end

% Set y-axis limits, grid, and labels
ylim([0 0.012]);
xlabel('Time (months)');  ylabel('EKE (m^2/s^2)');
title('Monthly mean EKE (1992-2017)')
% Add legend
legend(legend_labels,'fontsize',20);
PLOT();


%% Power Spectra
% Sampling frequency (1 cycle/month)
fs = 1;
% Segment length and overlap for Welch's method
nperseg = 64;
noverlap = 32;

% Legend labels for the five locations
legend_labels = {'Fram Strait', 'Canadian Archipalego', 'Beaufort Sea', 'Laptev Sea', 'Barents Sea'};

% Colors for the five locations
colors = {'r', 'k', [0,204,255]/255, [70,148,73]/255, [255,204,153]/255};

% Initialize figure
nexttile
% Loop through the five locations to compute and plot the power spectra
for i = 1:5
    % Compute the power spectral density using Welch's method
    [psd, frequencies] = pwelch(eval(['EKE_', strrep(legend_labels{i}, ' ', ''), '(:)']), nperseg, noverlap, [], fs);
    
    % Plot the power spectrum for the current location
    loglog(frequencies, psd, 'Color', colors{i}, 'LineWidth', 3.5, 'DisplayName', legend_labels{i});
    hold on;
end

% Set plot title, labels, and grid
title('Power Spectrum of Monthly Eddy Kinetic Energy');
xlabel('Frequency (month^{-1})');
ylabel('Power/Frequency (m^2s^{-2}/month)');
grid on;

% Add legend
legend('Location', 'northeast','fontsize',20);
PLOT()

%% Function to plot
function PLOT()
    set(gca, 'FontSize', 15);
    box on;
    set(gca, 'Layer', 'top');
    set(gcf, 'Position', [3205,318,808,1013]);
    set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
    set(gca, 'GridLineStyle', '-','LineWidth', 3);
end
