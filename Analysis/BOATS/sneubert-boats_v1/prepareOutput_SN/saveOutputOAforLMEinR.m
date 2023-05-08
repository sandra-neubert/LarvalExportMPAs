%To create table in R that gives median change per LME, save OA output in R
%readable format
%Sandra Neubert

Folder = cd;
mainFolder = fullfile(Folder, '..');

%load data
load(fullfile(mainFolder, 'output_thesis/outputBoats_ThesisSN_reg0_mvmt0_d250_h.mat'))
boatsm0 = boats;
surf = repmat(boats.forcing.surf,1,1,150);
surf = permute(surf, [3,1,2]);
clear boats

load(fullfile(mainFolder, 'output_thesis/outputBoats_ThesisSN_reg0_mvmt1_d250_h.mat'))
boatsm1 = boats;
clear boats

%Fish Harvest
summedMapM0H = boatsm0.output.annual.harvest_t_out*3600*24*360*1e-9;            % [t m-2 yr -1];
summedMapM1H = boatsm1.output.annual.harvest_t_out*3600*24*360*1e-9;            % [t m-2 yr-1];

%diff fish H
DiffMapH = summedMapM1H - summedMapM0H;
DiffH = squeeze(DiffMapH(237,:,:));

%pc fish H
percMapH = ((summedMapM1H - summedMapM0H) ./ summedMapM0H)*100;
PCH = squeeze(percMapH(237,:,:));


%Fish B
summedMapM0 = boatsm0.output.annual.fish_t_out*1e-9;             % [Mt m-2];
summedMapM1 = boatsm1.output.annual.fish_t_out*1e-9;            % [Mt m-2];

%diff fish
DiffMapB = summedMapM1 - summedMapM0;
DiffB = squeeze(DiffMapB(237,:,:));

%pc fish
percMapB = ((summedMapM1 - summedMapM0) ./ summedMapM0)*100;
PCB = squeeze(percMapB(237,:,:));

%Get oceans cells lon/lat from BOATS (already centroids) for tracer start locations
maskLength = size(PCB, 1)*size(PCB, 2);
load(fullfile(mainFolder, 'Ecological.mat'))

%init files
ChangeOA = zeros(maskLength,3);
counter = 1;

%Bring lon, lat and ocean cell info together

    for i = 1:size(PCB, 1)
        for j = 1:size(PCB, 2)
        ChangeOA(counter, 1) = Ecological.lon(i,j);
        ChangeOA(counter, 2) = Ecological.lat(i,j);
        ChangeOA(counter, 3) = PCB(i,j); 
        %ChangeOA(counter, 4) = year;
        counter = counter + 1;
        end
    end



writematrix(ChangeOA,'PCB_OA.csv')