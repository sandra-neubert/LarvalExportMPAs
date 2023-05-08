load('output/Boats_ThesisSN_reg0_mvmt0_d150_nh.mat')
boatsm0 = boats;
clear boats

load('output/Boats_ThesisSN_reg0_mvmt1_d150_nh.mat')
boatsm1 = boats;
clear boats

eggsm0 = boatsm0.output.annual.flux_in_num_eggs;
exampleEggsm0 = squeeze(eggsm0(150,:,:, 2));

eggsm1 = boatsm1.output.annual.flux_in_num_eggs;
exampleEggsm1 = squeeze(eggsm1(150,:,:, 2));

diffEggs = exampleEggsm1 - exampleEggsm0; %*1000 for km2; /1000 for kg


addpath("C:\Users\sandr\Documents\MME\MA\m_map")

load("geo_time.mat")

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);
% 

Pmin = -5e-07; Pmax = 5e-07;
figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,diffEggs); 
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 11;
h.Label.String = ('Biomass (gwB km^-^2)');
title('Difference in egg biomass (movement - no movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
%set(gcf,'color','w');

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
%saveas(gcf,'figures/fig1.png')
print(gcf,'figures/NHMovementComparison/EggDiffNH(M1-M0)Group2Y150.png','-dpng','-r500'); 


%sum
eggsm0Sum = sum(eggsm0,4, "omitnan");
eggsm1Sum = sum(eggsm1,4, "omitnan");

diffEggsSum = eggsm1Sum - eggsm0Sum ;
examplediffSum = squeeze(diffEggsSum(150,:,:));

Pmin = -2e-06; Pmax = 2e-06;
figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,examplediffSum );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 11;
h.Label.String = ('Biomass (gwB m^-^2)');
title('Difference in summed egg biomass (movement - no movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
%set(gcf,'color','w');

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
%saveas(gcf,'figures/fig1.png')
print(gcf,'figures/NHMovementComparison/SummedEggDiffNH(M1-M0)150Y.png','-dpng','-r500'); 

%%%%%%%%%%
Globm0Sum = squeeze(sum(eggsm0,[2,3], "omitnan"));
Globm0Sum = squeeze(sum(Globm0Sum,2, "omitnan"));
plot(Globm0Sum)

Globm1Sum = squeeze(sum(eggsm1,[2,3], "omitnan"));
Globm1Sum = squeeze(sum(Globm1Sum,2, "omitnan"));
plot(Globm1Sum)

GlobDiffEgg = Globm1Sum - Globm0Sum;
plot(GlobDiffEgg)
print(gcf,'figures/NHMovementComparison/SummedEggDiff(M1-M0)TimeSeries.png','-dpng','-r500'); 

%%%%%%%%%%% biomass comparison % differences because eggs end up in cells
%%%%%%%%%%% with different carrying capacities
summedMapM0 = boatsm0.output.annual.fish_t_out;%*1e-12;             % [Mt m-2];
summedMapM1 = boatsm1.output.annual.fish_t_out; %*1e-12;             % [Mt m-2];

DiffMapB = summedMapM1 - summedMapM0;
exampleDiffB = squeeze(DiffMapB(150,:,:));

Pmin = -0.11; Pmax = 0.11;
figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,exampleDiffB);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 11;
h.Label.String = ('Biomass (gwB m^-^2)');
%title(h,'gwB/m2','fontsize',15);
title('Difference in biomass (movement - no movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
%set(gcf,'color','w');

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
%saveas(gcf,'figures/fig1.png')
print(gcf,'figures/NHMovementComparison/SummedBDiffNH(M1-M0)150Y.png','-dpng','-r500'); 

summedGlobalM0 = boatsm0.output.annual.fish_gi_t;%*1e-12;             % [Mt];
summedGlobalM1 = boatsm1.output.annual.fish_gi_t;%*1e-12;             % [Mt];

GlobDiffB = summedGlobalM1 - summedGlobalM0;
plot(GlobDiffB)
print(gcf,'figures/NHMovementComparison/SummedBDiff(M1-M0)TimeSeries.png','-dpng','-r500'); 

%%%%%%%%%%%%%%%%%%%%%%
%Ratios

eggsm0 = boatsm0.output.annual.flux_in_num_eggs;
exampleEggsm0 = squeeze(eggsm0(150,:,:, 2));

eggsm1 = boatsm1.output.annual.flux_in_num_eggs;
exampleEggsm1 = squeeze(eggsm1(150,:,:, 2));

ratioEggs = exampleEggsm1 ./ exampleEggsm0; 

Pmin = 0.6; Pmax = 1.4;
figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,ratioEggs); 
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
caxis([Pmin Pmax])
h.Label.FontSize = 11;
h.Label.String = ('Change in biomass (%)');
h.Ticks = linspace(0.6, 1.4, 9) ; %Create 8 ticks from zero to 1
h.TickLabels = {'-40', '-30', '-20', '-10', '0', '10', '20', '30', '40'} ; 
title('Egg biomass ratio (movement/no movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
%caxis([Pmin Pmax])
%set(gcf,'color','w');

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
%saveas(gcf,'figures/fig1.png')
print(gcf,'figures/NHMovementComparison/EggRatioNH(M1-M0)Group2Y150.png','-dpng','-r500'); 

%%%
eggsm0Sum = sum(eggsm0,4, "omitnan");
eggsm1Sum = sum(eggsm1,4, "omitnan");

ratioEggsSum = eggsm1Sum ./ eggsm0Sum ;
exampleRatioSum = squeeze(ratioEggsSum(150,:,:));

Pmin = 0.7; Pmax = 1.3;
figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,exampleRatioSum );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
caxis([Pmin Pmax])
h.Label.FontSize = 11;
h.Label.String = ('Change in biomass (%)');
h.Ticks = linspace(0.7, 1.3, 7) ; %Create 8 ticks from zero to 1
h.TickLabels = {'-30', '-20', '-10', '0', '10', '20', '30'} ; 
title('Egg biomass ratio (movement/no movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'

%set(gcf,'color','w');

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
%saveas(gcf,'figures/fig1.png')
print(gcf,'figures/NHMovementComparison/SummedEggRatioNH(M1-M0)150Y.png','-dpng','-r500'); 

%%% 
Globm0Sum = squeeze(sum(eggsm0,[2,3], "omitnan"));
Globm0Sum = squeeze(sum(Globm0Sum,2, "omitnan"));
plot(Globm0Sum)

Globm1Sum = squeeze(sum(eggsm1,[2,3], "omitnan"));
Globm1Sum = squeeze(sum(Globm1Sum,2, "omitnan"));
plot(Globm1Sum)

GlobRatioEgg = Globm1Sum ./ Globm0Sum;
plot(GlobRatioEgg)
print(gcf,'figures/NHMovementComparison/SummedEggRatio(M1-M0)TimeSeries.png','-dpng','-r500'); 


%%%%%%%%%%% biomass comparison % differences because eggs end up in cells
%%%%%%%%%%% with different carrying capacities
summedMapM0 = boatsm0.output.annual.fish_t_out;%*1e-12;             % [Mt m-2];
summedMapM1 = boatsm1.output.annual.fish_t_out; %*1e-12;             % [Mt m-2];

RatioMapB = summedMapM1 ./ summedMapM0;
exampleRatioB = squeeze(RatioMapB(150,:,:));

Pmin = 0.9; Pmax = 1.1;
figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,exampleRatioB);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
caxis([Pmin Pmax])
h.Label.FontSize = 11;
h.Label.String = ('Change in biomass (%)');
h.Ticks = linspace(0.9, 1.1, 5) ; %Create 8 ticks from zero to 1
h.TickLabels = {'-10', '-5', '0', '5', '10'} ; 
title('Biomass ratio (movement/no movement)','fontsize',12, 'Position', [0 1.6 0]);

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
%saveas(gcf,'figures/fig1.png')
print(gcf,'figures/NHMovementComparison/SummedBRatioNH(M1-M0)150Y.png','-dpng','-r500'); 

summedGlobalM0 = boatsm0.output.annual.fish_gi_t;             % [Mt];
summedGlobalM1 = boatsm1.output.annual.fish_gi_t;             % [Mt];

GlobRatioB = summedGlobalM1 ./ summedGlobalM0;
plot(GlobRatioB)

print(gcf,'figures/NHMovementComparison/SummedBRatio(M1-M0)TimeSeries.png','-dpng','-r500'); 



%%% precentage change
%sum
eggsm0Sum = sum(eggsm0,4, "omitnan");
eggsm1Sum = sum(eggsm1,4, "omitnan");

percEggsSum = ((eggsm1Sum - eggsm0Sum) ./  eggsm0Sum) *100;
examplepercSum = squeeze(percEggsSum(150,:,:));

Pmin = -30; Pmax = 30;
figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,examplepercSum );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 11;
h.Label.String = ('Percentage change (%)');
caxis([Pmin Pmax])
title('Egg biomass percentage change','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'

%set(gcf,'color','w');

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
%saveas(gcf,'figures/fig1.png')
print(gcf,'figures/NHMovementComparison/SummedEggPCNH(M1-M0)150Y.png','-dpng','-r500');





eggsm0Sum = sum(eggsm0,4, "omitnan");
eggsm1Sum = sum(eggsm1,4, "omitnan");

diffEggsSum = eggsm1Sum - eggsm0Sum ;
examplediffSum = squeeze(diffEggsSum(150,:,:));


test0 = squeeze(sum(eggsm0Sum,[2,3] , "omitnan"));
test1 = squeeze(sum(eggsm1Sum,[2,3] , "omitnan"));

diffEggs = test1 - test0;
plot(diffEggs)

ratioEggsTest = test1 ./ test0;
plot(ratioEggsTest)
