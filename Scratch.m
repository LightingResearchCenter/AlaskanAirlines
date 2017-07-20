close all
clear
clc

addpath('C:\Users\jonesg5\Documents\GitHub\d12pack');

prjDir = 'C:\Users\jonesg5\Desktop\Alaskan Airlines';
dataPath = fullfile(prjDir, '2017-07-10_0914.mat');

load(dataPath);

Starts = [ 2017, 07, 06, 22, 39, 00;
           2017, 07, 06, 22, 53, 00;
           2017, 07, 06, 23, 02, 00;
           2017, 07, 06, 23, 10, 00;
           2017, 07, 06, 23, 16, 00;
           2017, 07, 06, 23, 22, 00;
           2017, 07, 06, 23, 55, 00;
           2017, 07, 07, 00, 01, 00;
           2017, 07, 07, 00, 08, 00;
           2017, 07, 07, 00, 16, 00;
           2017, 07, 07, 00, 25, 00;
           2017, 07, 07, 00, 32, 00;
           2017, 07, 07, 00, 42, 00;
           2017, 07, 07, 01, 07, 00;
           2017, 07, 07, 01, 38, 00 ];

Ends   = [ 2017, 07, 06, 22, 51, 00;
           2017, 07, 06, 23, 00, 00;
           2017, 07, 06, 23, 08, 00;
           2017, 07, 06, 23, 14, 00;
           2017, 07, 06, 23, 20, 00;
           2017, 07, 06, 23, 28, 00;
           2017, 07, 06, 23, 59, 00;
           2017, 07, 07, 00, 06, 00;
           2017, 07, 07, 00, 14, 00;
           2017, 07, 07, 00, 23, 00;
           2017, 07, 07, 00, 30, 00;
           2017, 07, 07, 00, 40, 00;
           2017, 07, 07, 01, 05, 00;
           2017, 07, 07, 01, 37, 00;
           2017, 07, 07, 02, 07, 00 ];

Interval = { 'Boarding';
           'Taxi Takeoff Landing';
           'AS Day Service';
           'AS Dark Service';
           'Red Eye';
           'Boarding Bin Closed';
           'Boarding Night Proposed';
           'Boarding Daytime Proposed';
           'Taxi Takeoff Landing Proposed';
           'Day Cruise';
           'Night Cruise';
           'Night Service';
           'Day Service';
           '16 + 16';
           'Night Service' };

Bounds = [datetime(Starts, 'TimeZone', 'America/Los_Angeles'), datetime(Ends, 'TimeZone', 'America/Los_Angeles')];

Averages = table(Interval, Bounds);
clear('Starts', 'Ends', 'Interval', 'Bounds');

Minute2Minute = table;

f = figure;
f.Units = 'pixels';
f.Position = [50, 50, 792, 612];
f.PaperOrientation = 'landscape';
ax = axes;
hold(ax, 'on')

for iObj = 1:numel(objArray)
    varName = ['CS_',objArray(iObj).ID];
    
    
    idx = objArray(iObj).Observation;
    plot(objArray(iObj).Time(idx),objArray(iObj).CircadianStimulus(idx),'-o','DisplayName',objArray(iObj).ID);
    
    Minute2Minute.Time = objArray(iObj).Time(idx);
    Minute2Minute.(varName) = objArray(iObj).CircadianStimulus(idx);
    
    for iInt = 1:height(Averages)
        idx = objArray(iObj).Time >= Averages.Bounds(iInt,1) & objArray(iObj).Time <= Averages.Bounds(iInt,2);
        Averages.(varName)(iInt,1) = mean(objArray(iObj).CircadianStimulus(idx));
    end
end

title('Alaskan Airlines - Daysimeter Readings')
ylabel('Circadian Stimulus (CS)')
legend('show')
grid on

plotPath = fullfile(prjDir, 'plot.pdf');
saveas(f, plotPath);


xlsxPath = fullfile(prjDir, 'AlaskanAirlines.xlsx');
writetable(Averages,xlsxPath,'Sheet','averages');
writetable(Minute2Minute,xlsxPath,'Sheet','minute2minute');

