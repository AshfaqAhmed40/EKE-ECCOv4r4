clear all; close all; clc;

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
Loc(5, :) = [7, 60];  % Barents Sea
Position = 90-Loc;

% Initialize arrays to store the values
Fram_values = [];
Canada_values = [];
Beaufort_values = [];
Laptev_values = [];
Barents_values = [];

% Define custom legend labels and colors
legend_labels = {'Fram Strait', 'Canadian Archipalego', 'Beaufort Sea', 'Laptev Sea', 'Barents Sea'};
colors = {'r', 'k', [0,204,255]/255, [70,148,73]/255, [255,204,153]/255};
F = 15;
ColorMap = 'ember';

%% Spatial trend (EKE)
cd(strcat(HOME,'figures/'));
% Initialize GIF
filename = 'movie_EKE_trend.gif';


close all; clc;
figure(1),clf;

for Y = 1992:2017 % Loop through the years
    fprintf("Now, in year %d",Y);
    fprintf(newline);

    for M = 1:12 % Loop through the month
        fprintf("Now, in month %d",M);
        fprintf(newline);

        for D = 1 % Selecting depth level, Z
            
            % Spatial
            subplot(2,6,[1,2,7,8])
            % Apply landmask
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
            title(sprintf('log_{10}EKE (m^2s^{-2}): Year = %d, Month = %d, Z = %d', Y, M, D), 'FontSize', F);

            % Show locations in the figure
            for idx = 1:size(Position, 1)
                newRow = size(ekeData, 1) - Position(idx, 1) + 1;
                newCol = size(ekeData, 2) - Position(idx, 2) + 1;
                xCoords = [newCol-1.5, newCol+1.5, newCol+1.5, newCol-1.5];
                yCoords = [newRow-1.5, newRow-1.5, newRow+1.5, newRow+1.5];

                colorIdx = mod(idx - 1, 5) + 1; % Cycle through 1 to 5
                color = colors{colorIdx};

                % Create patch with single color
                patch(xCoords, yCoords, color, 'EdgeColor', 'k', 'linewidth', 1);
            end
            c = colorbar;
            c.FontSize = F;
            c.FontWeight = 'bold';
            %ylabel(c, 'log_{10}EKE (m^2s^{-2})', 'Interpreter', 'tex', 'FontSize', 15);
            PLOT();
            hold on;
            
            
            % Temporal
            subplot(2,6,[3,4,5,6,9,10,11,12])
            Fram_value = EKE{1,M}{D,Y-1992+1}(Position(1,1), Position(1,2));
            Canada_value = EKE{1,M}{D,Y-1992+1}(Position(2,1), Position(2,2));
            Beaufort_value = EKE{1,M}{D,Y-1992+1}(Position(3,1), Position(3,2));
            Laptev_value = EKE{1,M}{D,Y-1992+1}(Position(4,1), Position(4,2));
            Barents_value = EKE{1,M}{D,Y-1992+1}(Position(5,1), Position(5,2));

            % Store the values in the respective arrays
            Fram_values = [Fram_values; Fram_value];
            Canada_values = [Canada_values; Canada_value];
            Beaufort_values = [Beaufort_values; Beaufort_value];
            Laptev_values = [Laptev_values; Laptev_value];
            Barents_values = [Barents_values; Barents_value];
            
            % Dynamic plot
            hold on;  
            plot(1:length(Fram_values),(Fram_values), 'r','LineWidth',3); 
            plot(1:length(Canada_values),(Canada_values), 'k','LineWidth',3); 
            plot(1:length(Beaufort_values),(Beaufort_values), 'color',[0,204,255]/255,'LineWidth',3); 
            plot(1:length(Laptev_values),(Laptev_values), 'Color',[70,148,73]/255,'LineWidth',3);  
            plot(1:length(Barents_values),(Barents_values), 'Color', [255,204,153]/255,'LineWidth',3);  
            grid on
            %ylim([0 0.015])
            
            % Add custom legend
            legend(legend_labels, 'Location', 'northeast', 'FontSize', 25);
            
            
            title(sprintf('EKE (m^2s^{-2}): Year = %d, Month = %d, Z = %d', Y, M, D), ...
                'FontSize', F, 'Interpreter', 'tex');
            set(gca, 'Layer', 'top');
            box on;
            set(gcf, 'Position', [623,703,1964,500]);
            set(gca, 'GridLineStyle', '-','LineWidth', 3);    
            xlabel('Time (Months)'); 
            
            set(gca, 'FontSize', F);
            


            
            % Save current frame as GIF
            drawnow;
            frame = getframe(1);
            im = frame2im(frame);
            [imind, cm] = rgb2ind(im, 256);
            
            % Write to the GIF File
            if Y == 1992 && M == 1 && D == 1
                imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
            else
                imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
            end
            pause(0.005)
            
        end
    end
end


cd(strcat(HOME,'data/'));


%% Function to plot
function PLOT()
    caxis([-4 -2]);
    set(gca,'color',[0.75 0.75 0.75]);
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    hold on;
    set(gca, 'Layer', 'top');
    box on;
    set(gcf, 'Position', [623,703,1964,500]);
    set(gca, 'GridLineStyle', '-', 'MinorGridLineStyle', ':', 'LineWidth', 3);
    box on;
    set(gca, 'GridLineStyle', '-','LineWidth', 3);
end