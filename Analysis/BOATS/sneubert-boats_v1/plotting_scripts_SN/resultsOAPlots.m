%Plot results of the open-access simulations (movement vs no movement)
%Sandra Neubert

clear all
addpath("C:\Users\sandr\Documents\MME\MA\m_map")

Folder = cd;
Folder = fullfile(Folder, '..');

load(fullfile(Folder, "geo_time.mat"))

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);

%load data
load(fullfile(Folder, 'output_thesis/outputBoats_ThesisSN_reg0_mvmt0_d250_h.mat'))
boatsm0 = boats;
surf = repmat(boats.forcing.surf,1,1,150);
surf = permute(surf, [3,1,2]);
clear boats

load(fullfile(Folder, 'output_thesis/outputBoats_ThesisSN_reg0_mvmt1_d250_h.mat'))
boatsm1 = boats;
clear boats

%Fish Harvest
summedMapM0H = boatsm0.output.annual.harvest_t_out*3600*24*360*1e-9;            % [t m-2 yr -1];
summedMapM1H = boatsm1.output.annual.harvest_t_out*3600*24*360*1e-9;            % [t m-2 yr-1];

%diff fish H
DiffMapH = summedMapM1H - summedMapM0H;
exampleDiffH = squeeze(DiffMapH(237,:,:));

%pc fish H
percMapH = ((summedMapM1H - summedMapM0H) ./ summedMapM0H)*100;
examplePercH = squeeze(percMapH(237,:,:));


%Fish B
summedMapM0 = boatsm0.output.annual.fish_t_out*1e-9;             % [Mt m-2];
summedMapM1 = boatsm1.output.annual.fish_t_out*1e-9;            % [Mt m-2];

%diff fish
DiffMapB = summedMapM1 - summedMapM0;
exampleDiffB = squeeze(DiffMapB(237,:,:));

%pc fish
percMapB = ((summedMapM1 - summedMapM0) ./ summedMapM0)*100;
examplePercB = squeeze(percMapB(237,:,:));

%plot
t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
nexttile
Pmin1 = -prctile(exampleDiffH ,95, "all"); Pmax1 = prctile(exampleDiffH ,95, "all");
m_proj('robinson','lon',[0 360], 'lat', [-75 75]);  %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,exampleDiffH);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('A. Harvest difference','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin1 Pmax1])
nexttile
Pmin2 = -prctile(examplePercH ,95, "all"); Pmax2 = prctile(examplePercH ,95, "all");
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,examplePercH);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Percentage change (%)');
caxis([Pmin2 Pmax2])
title('B. Harvest percentage change','fontsize',12, 'Position', [0 1.6 0]);
nexttile
Pmin3 = -prctile(exampleDiffB ,95, "all"); Pmax3 = prctile(exampleDiffB ,95, "all");
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,exampleDiffB );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Biomass (twB m^-^2)');
title('A. Fish biomass difference','fontsize',12, 'Position', [0 1.6 0]);
caxis([Pmin3 Pmax3])
nexttile
Pmin4 = -prctile(examplePercB ,95, "all"); Pmax4 = prctile(examplePercB,95, "all");
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,examplePercB);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Percentage change (%)');
caxis([Pmin4 Pmax4])
title('B. Fish biomass percentage change','fontsize',12, 'Position', [0 1.6 0]);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm

exportgraphics(t,fullfile(Folder, 'figures/HOAMovementComparison/CombinedOA(m1vsm0)95thPercY237NEW.png',"Resolution",700)) 


%harvest
summedGlobalHM0 = boatsm0.output.annual.harvest_gi_t*3600*24*360*1e-9;             % [t];
summedGlobalHM1 = boatsm1.output.annual.harvest_gi_t*3600*24*360*1e-9; 

GlobPercH = ((summedGlobalHM1 - summedGlobalHM0) ./ summedGlobalHM0)*100;
GlobDiffH = (summedGlobalHM1 - summedGlobalHM0);

%biomass
summedGlobalBM0 = boatsm0.output.annual.fish_gi_t*1e-9;             % [t];
summedGlobalBM1 = boatsm1.output.annual.fish_gi_t*1e-9; 

GlobPercB = ((summedGlobalBM1 - summedGlobalBM0) ./ summedGlobalBM0)*100;
GlobDiffB = (summedGlobalBM1 - summedGlobalBM0);


%plot
%grayColor = [128 128 128]/255; %[.7 .7 .7];
peak_yr = 193;%179;
xmin = peak_yr-45 -15; %-15 only so plot legends can be seen easier
xmax = 250; %xmin+150; % To show simulation from 1950-2100

t = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');
nexttile
plot(summedGlobalHM0 ,'Linewidth',1.5,'color',"#0072BD")
hold on;
plot(summedGlobalHM1 ,'Linewidth',1.5,'color',"#EDB120")
%xlim([xmin xmax])
title("A. Harvest")
xlabel('Years')
ylabel('Harvest (twB yr^-^1)')
ylim([0 max(ylim)])
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
legend('no movement','movement','Location','northeast')
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile
plot(GlobDiffH ,'Linewidth',1.5,'color','black')
%xlim([xmin xmax])
title({"B. Harvest", "difference"})
xlabel('Years')
ylabel('Harvest (twB yr^-^1)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile
plot(GlobPercH,'Linewidth',1.5,'color','black')
%xlim([xmin xmax])
title({"C. Harvest", "percentage change"})
xlabel('Years')
ylabel('Percentage Change (%)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
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
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
legend('no movement','movement','Location','northeast')
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile 
plot(GlobDiffB,'Linewidth',1.5,'color','black')
%xlim([xmin xmax])
title({"E. Fish biomass", "difference"})
xlabel('Years')
ylabel('Biomass (twB)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile
plot(GlobPercB,'Linewidth',1.5,'color','black')
%xlim([xmin xmax])
title({"F. Fish biomass", "percentage change"})
xlabel('Years')
ylabel('Percentage Change (%)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
set(gca,'FontSize',11,'Linewidth',0.5)


set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 30 18]); %x_width=10cm y_width=15cm
%saveas(gcf,'figures/fig1.png')
%exportgraphics(t,'figures/NHMovementComparison/CombinedNH(m1vsm0)TimeSeriesNew.png',"Resolution",700)

print(gcf,fullfile(Folder, 'figures/HOAMovementComparison/CombinedOA(m1vsm0)TimeSeriesNEWPEAK.png'),'-dpng','-r500');
%exportgraphics(t,'figures/NHMovementComparison/CombinedNH(m1vsm0)TimeSeries.png',"Resolution",300)

%Actual peak 
peak_yr = 179;
xmin = peak_yr-45;
xmax = 250; %xmin+150; % To show simulation from 1950-2100

t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
nexttile
plot(summedGlobalHM0 ,'Linewidth',1.5,'color',"#0072BD")
hold on;
plot(summedGlobalHM1 ,'Linewidth',1.5,'color',"#EDB120")
%xlim([xmin xmax])
title("A. Harvest")
xlabel('Years')
ylabel('Harvest (twB yr^-^1)')
xlim([xmin xmax])
xticks([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1960','1985','2010','2035','2060'})
legend('no movement','movement','Location','southwest')
set(gca,'FontSize',11,'Linewidth',0.5)
nexttile
plot(summedGlobalBM0,'Linewidth',1.5,'color',	"#0072BD")
hold on;
plot(summedGlobalBM1,'Linewidth',1.5,'color',	"#EDB120")
%xlim([xmin xmax])
title("B. Fish biomass")
xlabel('Years')
ylabel('Biomass (twB)')
xlim([xmin xmax])
xticks([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1960','1985','2010','2035','2060'})
legend('no movement','movement','Location','northeast')
set(gca,'FontSize',11,'Linewidth',0.5)

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 15 10]); %x_width=10cm y_width=15cm

print(gcf,fullfile(Folder, 'figures/HOAMovementComparison/HandBOA(m1vsm0)TimeSeriesNEW.png'),'-dpng','-r500');