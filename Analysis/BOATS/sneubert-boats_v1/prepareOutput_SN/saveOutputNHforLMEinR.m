%To create table in R that gives median change per LME, save NH output in R
%readable format
%Sandra Neubert

Folder = cd;
mainFolder = fullfile(Folder, '..');

clear all

load(fullfile(mainFolder, 'output/Boats_ThesisSN_reg0_mvmt0_d150_nh.mat'))
boatsm0 = boats;
clear boats

load(fullfile(mainFolder, 'output/Boats_ThesisSN_reg0_mvmt1_d150_nh.mat'))
boatsm1 = boats;
clear boats

eggsm0 = boatsm0.output.annual.flux_in_num_eggs;
eggsm1 = boatsm1.output.annual.flux_in_num_eggs;

eggsm0Sum = sum(eggsm0,4, "omitnan");
eggsm1Sum = sum(eggsm1,4, "omitnan");

diffEggsSum = eggsm1Sum - eggsm0Sum ;
examplediffSum = squeeze(diffEggsSum(150,:,:));

summedMapM0 = boatsm0.output.annual.fish_t_out;%*1e-12;             % [Mt m-2];
summedMapM1 = boatsm1.output.annual.fish_t_out; %*1e-12;             % [Mt m-2];

DiffMapB = summedMapM1 - summedMapM0;
exampleDiffB = squeeze(DiffMapB(150,:,:));

eggsm0Sum = sum(eggsm0,4, "omitnan");
eggsm1Sum = sum(eggsm1,4, "omitnan");

percEggsSum = ((eggsm1Sum - eggsm0Sum) ./  eggsm0Sum) *100;
examplepercSum = squeeze(percEggsSum(150,:,:));

summedMapM0 = boatsm0.output.annual.fish_t_out;%*1e-12;             % [Mt m-2];
summedMapM1 = boatsm1.output.annual.fish_t_out; %*1e-12;             % [Mt m-2];

percMapB = ((summedMapM1 - summedMapM0) ./ summedMapM0)*100;
examplePercB = squeeze(percMapB(150,:,:));

%%%%%%%%%%%%%%%%%%%%%%%
maskLength = size(examplePercB, 1)*size(examplePercB, 2);
load(fullfile(mainFolder, 'Ecological.mat'))

%init files
Changes = zeros(maskLength,3);
counter = 1;

%Bring lon, lat and ocean cell info together

    for i = 1:size(examplePercB, 1)
        for j = 1:size(examplePercB, 2)
        Changes(counter, 1) = Ecological.lon(i,j);
        Changes(counter, 2) = Ecological.lat(i,j);
        Changes(counter, 3) = examplePercB(i,j); %land/ocean info
        counter = counter + 1;
        end
    end



writematrix(Changes,'PCB.csv')