%Use Waldron Top 30 MPA network scenario (biodiversity focused) and add current MPAs to it 
%Sandra Neubert

clear all

Folder = cd;
Folder = fullfile(Folder, '..');

input_path = "C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\input"; 
mpaPath = fullfile(input_path, "mpaWaldron", "mpa_scenarios.csv");
mpasWaldron = readmatrix(mpaPath); %order: "Lon" "Lat" "Current_MPAs","Cheapest_Half","Cheapest_Full","Top30_Half","Top30_Full"

v = (1:1:64800)';

mpasWaldron = horzcat(mpasWaldron, v); %add index for cells 
ind1 = (mpasWaldron (:,2) < 75) & (mpasWaldron (:,2) > -75);
mpasWaldronReduced = mpasWaldron(ind1,:);

currentSum = sum(mpasWaldronReduced(:,3), "omitnan");
halfSum = sum(mpasWaldronReduced(:,6), "omitnan");
fullSum = sum(mpasWaldronReduced(:,7), "omitnan");

toSelect = halfSum -currentSum;


ind2 = ~((mpasWaldron (:,2) < 75) & (mpasWaldron (:,2) > -75)); 
mpasWaldronCutoff = mpasWaldron(ind2,:);%apply 75° cutoff
toAddCutoff = mpasWaldronCutoff(:, 3);
ind3 = toAddCutoff == 1; %where current MPAs are
toAddCutoff(ind3) = 0;
toAddCutoff = horzcat(mpasWaldronCutoff(:, [1,2]), toAddCutoff); %long, lat 
toAddCutoff = horzcat(toAddCutoff, mpasWaldronCutoff(:, [8]));

%%% get full 30% mpa info = 1 and keep index
FullInfo = mpasWaldronReduced(:, [1,2,3,7,8]);
ind4 = FullInfo(:,4) == 1;
MPAFull = FullInfo(ind4,:);

%take out those that are already protected
ind5 = MPAFull(:,3) == 1; 
toSelectFrom = MPAFull(~ind5,:);

%now select random length(toSelect) elements from toSelectFrom
msize = size(toSelectFrom,1);
selected = toSelectFrom(randperm(msize, toSelect), :);
selected = selected(:, [1,2,4,5]);


FullInfo = mpasWaldronReduced(:, [1,2,3,7,8]);
ind6 = FullInfo(:,3) == 1;
CurrentMPAs = FullInfo(ind6,:);
CurrentMPAs = CurrentMPAs(:, [1:3,5]);

selectedCombCurrent = vertcat(selected, CurrentMPAs);
ind7 = ~ismember(FullInfo(:,5), selectedCombCurrent(:,4));
noMPA = FullInfo(ind7,:);
noMPA = noMPA(:, [1:3,5]);

top30HalfInclCurrent = vertcat(noMPA, selectedCombCurrent);
top30HalfInclCurrent = vertcat(top30HalfInclCurrent, toAddCutoff);
top30HalfInclCurrent=sortrows(top30HalfInclCurrent,4);

fullCombCurrent = vertcat(toSelectFrom(:, [1,2,4,5]), CurrentMPAs);
ind8 = ~ismember(FullInfo(:,5), fullCombCurrent(:,4));
noMPAFull = FullInfo(ind8,:);
noMPAFull = noMPAFull(:, [1:3,5]);

top30FullInclCurrent = vertcat(noMPAFull, fullCombCurrent);
top30FullInclCurrent = vertcat(top30FullInclCurrent, toAddCutoff);
top30FullInclCurrent = sortrows(top30FullInclCurrent,4);

% mpasWaldronTest = mpasWaldron(:, [1:3]);
% mpasWaldronTest = horzcat(mpasWaldronTest, mpasWaldron(:, [4,5])); %run
% cheapest stright before this
mpasWaldronTest = horzcat(mpasWaldronTest , top30HalfInclCurrent(:, [3]));
mpasWaldronTest = horzcat(mpasWaldronTest, top30FullInclCurrent(:, [3]));
mpasWaldron = mpasWaldronTest;

writematrix(mpasWaldron,'mpasWaldronNew.csv') 

MPAMatrix = zeros(180, 360, 5); 

for cellNum = 1:size(mpasWaldron,1) %loop through BOATS cells
        lon = round(mpasWaldron(cellNum, 1));
        lat = round(mpasWaldron(cellNum, 2)+90);
        for i = 3:7 %order: "Current_MPAs","Cheapest_Half","Cheapest_Full","Top30_Half","Top30_Full"
            MPAMatrix (lat, lon, i-2) = mpasWaldron(cellNum, i);
        end
end

%save('MPAMatrixWaldronInclCurrent.mat','MPAMatrix','-v7.3')
%then: run prepWaldronMPAs.m loop (but just loop and MPAmatrix thing, not
%rest
