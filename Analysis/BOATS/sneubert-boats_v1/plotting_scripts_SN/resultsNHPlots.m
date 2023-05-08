%Plot results of the no harvest simulation (spin-up) to confirm that
%including the movement algorithm worked

%Sandra Neubert
clear all

Folder = cd;
Folder = fullfile(Folder, '..');

addpath("C:\Users\sandr\Documents\MME\MA\m_map")

load(fullfile(Folder, "geo_time.mat"))

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);

%load data
load(fullfile(Folder, 'output_thesis/Boats_ThesisSN_reg0_mvmt0_d150_nh.mat'))
boatsm0 = boats;
surf = repmat(boats.forcing.surf,1,1,150);
surf = permute(surf, [3,1,2]);
clear boats

load(fullfile(Folder, 'output_thesis/Boats_ThesisSN_reg0_mvmt1_d150_nh.mat'))
boatsm1 = boats;
clear boats

eggsm0 = boatsm0.output.annual.flux_in_num_eggs;
eggsm1 = boatsm1.output.annual.flux_in_num_eggs;

eggsm0Sum = sum(eggsm0,4, "omitnan");
eggsm1Sum = sum(eggsm1,4, "omitnan");

%diff eggs
diffEggsSum = eggsm1Sum - eggsm0Sum ;
examplediffSum = squeeze(diffEggsSum(150,:,:))*1e-9;

%PC eggs
percEggsSum = ((eggsm1Sum - eggsm0Sum) ./  eggsm0Sum) *100;
examplepercSum = squeeze(percEggsSum(150,:,:));

%Fish 
summedMapM0 = boatsm0.output.annual.fish_t_out;%*1e-12;             % [Mt m-2];
summedMapM1 = boatsm1.output.annual.fish_t_out; %*1e-12;             % [Mt m-2];

%diff fish
DiffMapB = summedMapM1 - summedMapM0;
exampleDiffB = squeeze(DiffMapB(150,:,:))*1e-9;

%pc fish
percMapB = ((summedMapM1 - summedMapM0) ./ summedMapM0)*100;
examplePercB = squeeze(percMapB(150,:,:));

%plot
t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
nexttile
Pmin1 = -prctile(examplediffSum ,99, "all"); Pmax1 = prctile(examplediffSum ,99, "all");
m_proj('robinson','lon',[0 360], 'lat', [-75 75]);  %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,examplediffSum );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Biomass (twB m^-^2)');
title('A. Egg biomass difference','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin1 Pmax1])
nexttile
Pmin2 = -prctile(examplepercSum ,99, "all"); Pmax2 = prctile(examplepercSum ,99, "all");
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,examplepercSum );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Percentage change (%)');
caxis([Pmin2 Pmax2])
title('B. Egg biomass percentage change','fontsize',12, 'Position', [0 1.6 0]);
nexttile
Pmin3 = -prctile(exampleDiffB ,99, "all"); Pmax3 = prctile(exampleDiffB ,99, "all");
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,exampleDiffB );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Biomass (twB m^-^2)');
title('C. Fish biomass difference','fontsize',12, 'Position', [0 1.6 0]);
caxis([Pmin3 Pmax3])
nexttile
Pmin4 = -prctile(examplePercB ,99, "all"); Pmax4 = prctile(examplePercB,99, "all");
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,examplePercB);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Percentage change (%)');
caxis([Pmin4 Pmax4])
title('D. Fish biomass percentage change','fontsize',12, 'Position', [0 1.6 0]);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm

exportgraphics(t,fullfile(Folder, 'figures/NHMovementComparison/CombinedNH(m1vsm0)99thPercY150.png'),"Resolution",700) % of not working set resolution higher

%indiviudal plots
% %Pmin = -2e-06; Pmax = 2e-06;
% %Pmin = -1e-05; Pmax = 1e-05;
% Pmin = -prctile(examplediffSum ,99, "all"); Pmax = prctile(examplediffSum ,99, "all");
% figure
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,examplediffSum );
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Biomass (twB m^-^2)');
% %h.Ticks = linspace(Pmin, Pmax, 5) ; 
% %h.TickLabels = {'>10',1,2,3, '<10'} ; 
% title('A. Difference in summed egg biomass (movement - no movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin Pmax])
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
% %print(gcf,'figures/NHMovementComparison/SummedEggDiffNH(M1-M0)150Y.png','-dpng','-r500'); 
% 
% 
% Pmin = -0.11; Pmax = 0.11;
% figure
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,exampleDiffB);
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Biomass (gwB m^-^2)');
% %title(h,'gwB/m2','fontsize',15);
% title('Difference in biomass (movement - no movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin Pmax])
% %set(gcf,'color','w');
% 
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
% %saveas(gcf,'figures/fig1.png')
% print(gcf,'figures/NHMovementComparison/SummedBDiffNH(M1-M0)150Y.png','-dpng','-r500'); 
% 
% %%% precentage change
% %sum
% Pmin = -30; Pmax = 30;
% figure
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,examplepercSum );
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Percentage change (%)');
% caxis([Pmin Pmax])
% title('Egg biomass percentage change','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
% print(gcf,'figures/NHMovementComparison/SummedEggPCNH(M1-M0)150Y.png','-dpng','-r500');

% Pmin = -10; Pmax = 10;
% figure
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,examplePercB);
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% caxis([Pmin Pmax])
% h.Label.FontSize = 11;
% h.Label.String = ('Change in biomass (%)');
% h.Ticks = linspace(0.9, 1.1, 5) ; %Create 8 ticks from zero to 1
% h.TickLabels = {'-10', '-5', '0', '5', '10'} ; 
% title('Biomass ratio (movement/no movement)','fontsize',12, 'Position', [0 1.6 0]);
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
% print(gcf,'figures/NHMovementComparison/SummedBRatioNH(M1-M0)150Y.png','-dpng','-r500'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%eggs
eggsm0Sum = ((sum(eggsm0,4, "omitnan")) .* surf) ;
eggsm1Sum = ((sum(eggsm1,4, "omitnan")) .* surf) ;

Globm0SumEgg  = squeeze(sum(eggsm0Sum,[2,3] , "omitnan"))*1e-9;
Globm1SumEgg = squeeze(sum(eggsm1Sum,[2,3] , "omitnan"))*1e-9;

GlobPercEgg = ((Globm1SumEgg - Globm0SumEgg) ./ Globm0SumEgg)*100;
GlobDiffEgg = (Globm1SumEgg - Globm0SumEgg);

%fish
summedGlobalBM0 = boatsm0.output.annual.fish_gi_t*1e-9;             % [Mt];
summedGlobalBM1 = boatsm1.output.annual.fish_gi_t*1e-9; 

GlobPercB = ((summedGlobalBM1 - summedGlobalBM0) ./ summedGlobalBM0)*100;
GlobDiffB = (summedGlobalBM1 - summedGlobalBM0);


%grayColor = [128 128 128]/255; %[.7 .7 .7];
t = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');
nexttile
plot(Globm0SumEgg,'Linewidth',1.5,'color',"#0072BD")
hold on;
plot(Globm1SumEgg,'Linewidth',1.5,'color',"#EDB120")
%xlim([xmin xmax])
title("A. Egg biomass")
xlabel('Years')
ylim([0 max(ylim)])
ylabel('Biomass (twB)')
legend('no movement','movement')
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile
plot(GlobDiffEgg,'Linewidth',1.5,'color','black')
%xlim([xmin xmax])
title({"B. Egg biomass", "difference"})
xlabel('Years')
ylabel('Biomass (twB)')
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile
plot(GlobPercEgg,'Linewidth',1.5,'color','black')
%xlim([xmin xmax])
title({"C. Egg biomass", "percentage change"})
xlabel('Years')
ylabel('Percentage Change (%)')
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile
plot(summedGlobalBM0,'Linewidth',1.5,'color',	"#0072BD")
hold on;
plot(summedGlobalBM1,'Linewidth',1.5,'color',	"#EDB120")
%xlim([xmin xmax])
title("D. Fish biomass")
xlabel('Years')
ylabel('Biomass (twB)')
ylim([0 max(ylim)])
legend('no movement','movement')
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile 
plot(GlobDiffB,'Linewidth',1.5,'color','black')
%xlim([xmin xmax])
title({"E. Fish biomass", "difference"})
xlabel('Years')
ylabel('Biomass (twB)')
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile
plot(GlobPercB,'Linewidth',1.5,'color','black')
%xlim([xmin xmax])
title({"F. Fish biomass", "percentage change"})
xlabel('Years')
ylabel('Percentage Change (%)')
set(gca,'FontSize',11,'Linewidth',0.5)


set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
%saveas(gcf,'figures/fig1.png')
%exportgraphics(t,'figures/NHMovementComparison/CombinedNH(m1vsm0)TimeSeriesNew.png',"Resolution",700)

print(gcf,fullfile(Folder, 'figures/NHMovementComparison/CombinedNH(m1vsm0)TimeSeriesNEW_150.png'),'-dpng','-r500');
%exportgraphics(t,'figures/NHMovementComparison/CombinedNH(m1vsm0)TimeSeries.png',"Resolution",300)










% figure
% %Pmin1 = -2e-06; Pmax1 = 2e-06;
% h1 = subplot(2,2,1);
% Pmin1 = -2e-06; Pmax1 = 2e-06;
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]);  %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,examplediffSum );
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Biomass (gwB m^-^2)');
% title('Egg biomass difference','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin1 Pmax1])
% 
% 
% subplot(2,2,2)
% Pmin2 = -30; Pmax2 = 30;
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,examplepercSum );
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Percentage change (%)');
% caxis([Pmin2 Pmax2])
% title('Egg biomass percentage change','fontsize',12, 'Position', [0 1.6 0]);
% 
% 
% subplot(2,2,3)
% Pmin3 = -0.11; Pmax3 = 0.11;
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,exampleDiffB );
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Biomass (gwB m^-^2)');
% title('Fish biomass difference','fontsize',12, 'Position', [0 1.6 0]);
% caxis([Pmin3 Pmax3])
% 
% subplot(2,2,4)
% Pmin4 = -10; Pmax4 = 10;
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,examplePercB);
% m_coast('patch',[.8 .8 .8]),'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Percentage change (%)');
% caxis([Pmin4 Pmax4])
% title('Fish biomass percentage change','fontsize',12, 'Position', [0 1.6 0]);
% 
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 35 22]); %x_width=10cm y_width=15cm
% print(gcf,'figures/NHMovementComparison/Results1CombinedMap150Y.png','-dpng','-r500');
