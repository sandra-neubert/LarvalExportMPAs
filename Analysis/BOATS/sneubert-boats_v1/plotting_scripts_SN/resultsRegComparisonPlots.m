clear all

Folder = cd;
Folder = fullfile(Folder, '..');

addpath("C:\Users\sandr\Documents\MME\MA\m_map")
addpath(fullfile(Folder, "prepareOutput_SN"))

load(fullfile(Folder, "geo_time.mat"))

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);

%prep stuff for comparison
%1. global trend
load(fullfile(Folder, 'output_thesis/outputBoats_ThesisSN_reg1C_mvmt0_d250_h.mat'))
boatsm0reg1 = boats;
surf = repmat(boats.forcing.surf,1,1,250);
surf = permute(surf, [3,1,2]);
price          = boats.forcing_used.price(1);          % ONLY OK IF PRICE IS CONSTANT!
cost_effort    = boats.forcing_used.cost_effort(1);    % ONLY OK IF COST per EFFORT IS CONSTANT!
clear boats

load(fullfile(Folder, 'output_thesis/outputBoats_ThesisSN_reg0_mvmt0_d250_h.mat'))
boatsm0reg0 = boats;
clear boats

load(fullfile(Folder, 'output_thesis/outputBoats_ThesisSN_reg1C_mvmt1_d250_h.mat'))
boatsm1reg1 = boats;
clear boats

load(fullfile(Folder, 'output_thesis/outputBoats_ThesisSN_reg0_mvmt1_d250_h.mat'))
boatsm1reg0 = boats;
clear boats


%get harvest_gi_t for all and transform to tonnes and years
globHboatsm0reg1 = boatsm0reg1.output.annual.harvest_gi_t*3600*24*360*1e-9;
globHboatsm1reg1 = boatsm1reg1.output.annual.harvest_gi_t*3600*24*360*1e-9;
globHboatsm1reg0 = boatsm1reg0.output.annual.harvest_gi_t*3600*24*360*1e-9;
globHboatsm0reg0 = boatsm0reg0.output.annual.harvest_gi_t*3600*24*360*1e-9;

globHDiffm1 = globHboatsm1reg1 - globHboatsm1reg0;
globHDiffm0 = globHboatsm0reg1 - globHboatsm0reg0;

globHPCm1 = ((globHboatsm1reg1-globHboatsm1reg0 ) ./ globHboatsm1reg0)*100 ;
globHPCm0 = ((globHboatsm0reg1 -globHboatsm0reg0) ./ globHboatsm0reg0)*100;

%get fish_gi_t for all and transform to tonnes and years
globBboatsm0reg1 = boatsm0reg1.output.annual.fish_gi_t*1e-9;
globBboatsm1reg1 = boatsm1reg1.output.annual.fish_gi_t*1e-9;
globBboatsm1reg0 = boatsm1reg0.output.annual.fish_gi_t*1e-9;
globBboatsm0reg0 = boatsm0reg0.output.annual.fish_gi_t*1e-9;

globBDiffm1 = globBboatsm1reg1 - globBboatsm1reg0;
globBDiffm0 = globBboatsm0reg1 - globBboatsm0reg0;

globBPCm1 = ((globBboatsm1reg1-globBboatsm1reg0 ) ./ globBboatsm1reg0)*100;
globBPCm0 = ((globBboatsm0reg1 -globBboatsm0reg0) ./ globBboatsm0reg0)*100;

%to get tonnes offset:
fishoffset = globBboatsm1reg1 -globBboatsm0reg1;
Hoffset = globHboatsm1reg1 -globHboatsm0reg1;

%Profit %SOMETHING NOT RIGHT HERE: PROFIT NEGATIVE!!
globPm0reg1 = calcProfit_gi_t(boatsm0reg1.output.annual.harvest_gi_t, boatsm0reg1.output.annual.effort_gi_t, price, cost_effort);
globPm1reg1 = calcProfit_gi_t(boatsm1reg1.output.annual.harvest_gi_t, boatsm1reg1.output.annual.effort_gi_t, price, cost_effort);
globPm0reg0 = calcProfit_gi_t(boatsm0reg0.output.annual.harvest_gi_t, boatsm0reg0.output.annual.effort_gi_t, price, cost_effort);
globPm1reg0 = calcProfit_gi_t(boatsm1reg0.output.annual.harvest_gi_t, boatsm1reg0.output.annual.effort_gi_t, price, cost_effort);

globPDiffm1 = globPm1reg1 - globPm1reg0;
globPDiffm0 = globPm0reg1 - globPm0reg0;

globPPCm1 = ((globPm1reg1 - globPm1reg0) ./ globPm1reg0)*100 ;
globPPCm0 = ((globPm0reg1 - globPm0reg0) ./ globPm0reg0)*100;


peak_yr = 193;%179;
xmin = peak_yr-45 -15; %-15 only so plot legends can be seen easier
xmax = 250; %xmin+150; % To show simulation from 1950-2100

%for shading
x_points1 = [xmin-1, xmin-1, 193, 193];  
color1 = [0 0.4470 0.7410];
x_points2 = [193, 193, 223, 223];  
color2 = [0.9290 0.6940 0.1250];
x_points3 = [223, 223, 228, 228];  
color3 = [0.8500 0.3250 0.0980];
x_points4 = [228, 228, xmax, xmax];  
color4 = [0.6350 0.0780 0.1840];

%plot
t = tiledlayout(3,3,'TileSpacing','Compact','Padding','Compact');
nexttile
plot(globHboatsm0reg1 ,'Linewidth',1.5,'color',"#0072BD")
title("A. Harvest")
xlabel('Years')
ylabel('Harvest (twB yr^-^1)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
hold on;
plot(globHboatsm1reg1 ,'Linewidth',1.5,'color',"#EDB120")
hold on;
plot(globHboatsm0reg0,'--' ,'Linewidth',1.5,'color',"#0072BD")
hold on;
plot(globHboatsm1reg0,'--' ,'Linewidth',1.5,'color',"#EDB120")
%legend('m_0mpa_1','m_1mpa_1','m_0mpa_0','m_1mpa_0','Location','southwest','NumColumns',2);
set(gca,'FontSize',11,'Linewidth',0.5)
hold on; %if you want shading: outcomment all the bits here under every
% plot and comment legend above
y_points1 = [min(ylim), max(ylim), max(ylim), min(ylim)];
a1 = fill(x_points1, y_points1, color1);
a1.FaceAlpha = 0.1;
a2 = fill(x_points2, y_points1, color2);
a2.FaceAlpha = 0.1;
hold on;
a3 = fill(x_points3, y_points1, color3);
a3.FaceAlpha = 0.1;
hold on;
a4 = fill(x_points4, y_points1, color4);
a4.FaceAlpha = 0.1;
hold off
grid on;
legend('m_0mpa_1','m_1mpa_1','m_0mpa_0','m_1mpa_0','Location','southwest','NumColumns',2);
box on


nexttile
plot(globHDiffm0,'Linewidth',1.5,'color',"#0072BD")
%xlim([xmin xmax])
title({"B. Harvest", "difference"})
xlabel('Years')
ylabel('Harvest (twB yr^-^1)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
plot(globHDiffm1,'Linewidth',1.5,'color',"#EDB120")
%legend('m_0','m_1','Location','northwest')
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
y_points1 = [min(ylim), max(ylim), max(ylim), min(ylim)];
a1 = fill(x_points1, y_points1, color1);
a1.FaceAlpha = 0.1;
a2 = fill(x_points2, y_points1, color2);
a2.FaceAlpha = 0.1;
hold on;
a3 = fill(x_points3, y_points1, color3);
a3.FaceAlpha = 0.1;
hold on;
a4 = fill(x_points4, y_points1, color4);
a4.FaceAlpha = 0.1;
hold off
grid on;
legend('m_0','m_1','Location','northwest');
box on


nexttile
plot(globHPCm0,'Linewidth',1.5,'color',"#0072BD")
%xlim([xmin xmax])
title({"C. Harvest", "percentage change"})
xlabel('Years')
ylabel('Percentage Change (%)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
plot(globHPCm1,'Linewidth',1.5,'color',"#EDB120")
%legend('m_0','m_1','Location','northwest')
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
y_points1 = [min(ylim), max(ylim), max(ylim), min(ylim)];
a1 = fill(x_points1, y_points1, color1);
a1.FaceAlpha = 0.1;
a2 = fill(x_points2, y_points1, color2);
a2.FaceAlpha = 0.1;
hold on;
a3 = fill(x_points3, y_points1, color3);
a3.FaceAlpha = 0.1;
hold on;
a4 = fill(x_points4, y_points1, color4);
a4.FaceAlpha = 0.1;
hold off
grid on;
legend('m_0','m_1','Location','northwest');
box on

nexttile
plot(globBboatsm0reg1 ,'Linewidth',1.5,'color',"#0072BD")
title("D. Fish biomass")
xlabel('Years')
ylabel('Biomass (twB)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
hold on;
plot(globBboatsm1reg1 ,'Linewidth',1.5,'color',"#EDB120")
%xlim([xmin xmax])
hold on;
plot(globBboatsm0reg0,'--' ,'Linewidth',1.5,'color',"#0072BD")
hold on;
plot(globBboatsm1reg0,'--' ,'Linewidth',1.5,'color',"#EDB120")
%legend('m_0mpa_1','m_1mpa_1','m_0mpa_0','m_1mpa_0','Location','northeast','NumColumns',2)
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
y_points1 = [min(ylim), max(ylim), max(ylim), min(ylim)];
a1 = fill(x_points1, y_points1, color1);
a1.FaceAlpha = 0.1;
a2 = fill(x_points2, y_points1, color2);
a2.FaceAlpha = 0.1;
hold on;
a3 = fill(x_points3, y_points1, color3);
a3.FaceAlpha = 0.1;
hold on;
a4 = fill(x_points4, y_points1, color4);
a4.FaceAlpha = 0.1;
hold off
grid on;
legend('m_0mpa_1','m_1mpa_1','m_0mpa_0','m_1mpa_0','Location','northeast','NumColumns',2);
box on

nexttile
plot(globBDiffm0,'Linewidth',1.5,'color',"#0072BD")
%xlim([xmin xmax])
title({"E. Fish biomass", "difference"})
xlabel('Years')
ylabel('Biomass (twB)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
plot(globBDiffm1,'Linewidth',1.5,'color',"#EDB120")
%legend('m_0','m_1','Location','northwest')
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
y_points1 = [min(ylim), max(ylim), max(ylim), min(ylim)];
a1 = fill(x_points1, y_points1, color1);
a1.FaceAlpha = 0.1;
a2 = fill(x_points2, y_points1, color2);
a2.FaceAlpha = 0.1;
hold on;
a3 = fill(x_points3, y_points1, color3);
a3.FaceAlpha = 0.1;
hold on;
a4 = fill(x_points4, y_points1, color4);
a4.FaceAlpha = 0.1;
hold off
grid on;
legend('m_0','m_1','Location','northwest');
box on


nexttile
plot(globBPCm0,'Linewidth',1.5,'color',"#0072BD")
%xlim([xmin xmax])
title({"F. Fish biomass", "percentage change"})
xlabel('Years')
ylabel('Percentage Change (%)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
plot(globBPCm1,'Linewidth',1.5,'color',"#EDB120")
%legend('m_0','m_1','Location','northwest')
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
y_points1 = [min(ylim), max(ylim), max(ylim), min(ylim)];
a1 = fill(x_points1, y_points1, color1);
a1.FaceAlpha = 0.1;
a2 = fill(x_points2, y_points1, color2);
a2.FaceAlpha = 0.1;
hold on;
a3 = fill(x_points3, y_points1, color3);
a3.FaceAlpha = 0.1;
hold on;
a4 = fill(x_points4, y_points1, color4);
a4.FaceAlpha = 0.1;
hold off
grid on;
legend('m_0','m_1','Location','northwest');
box on


nexttile
plot(globPm0reg1 ,'Linewidth',1.5,'color',"#0072BD")
title("G. Profit")
xlabel('Years')
ylabel('Profit (B$ yr^-^1)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
hold on;
plot(globPm1reg1 ,'Linewidth',1.5,'color',"#EDB120")
%xlim([xmin xmax])
hold on;
plot(globPm0reg0,'--' ,'Linewidth',1.5,'color',"#0072BD")
hold on;
plot(globPm1reg0,'--' ,'Linewidth',1.5,'color',"#EDB120")
%legend('m_0mpa_1','m_1mpa_1','m_0mpa_0','m_1mpa_0','Location','southwest','NumColumns',2)
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
y_points1 = [min(ylim), max(ylim), max(ylim), min(ylim)];
a1 = fill(x_points1, y_points1, color1);
a1.FaceAlpha = 0.1;
a2 = fill(x_points2, y_points1, color2);
a2.FaceAlpha = 0.1;
hold on;
a3 = fill(x_points3, y_points1, color3);
a3.FaceAlpha = 0.1;
hold on;
a4 = fill(x_points4, y_points1, color4);
a4.FaceAlpha = 0.1;
hold off
grid on;
legend('m_0mpa_1','m_1mpa_1','m_0mpa_0','m_1mpa_0','Location','southwest','NumColumns',2);
box on

nexttile
plot(globPDiffm0,'Linewidth',1.5,'color',"#0072BD")
%xlim([xmin xmax])
title({"H. Profit", "difference"})
xlabel('Years')
ylabel('Profit (B$ yr^-^1)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
plot(globPDiffm1,'Linewidth',1.5,'color',"#EDB120")
%legend('m_0','m_1','Location','northwest')
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
y_points1 = [min(ylim), max(ylim), max(ylim), min(ylim)];
a1 = fill(x_points1, y_points1, color1);
a1.FaceAlpha = 0.1;
a2 = fill(x_points2, y_points1, color2);
a2.FaceAlpha = 0.1;
hold on;
a3 = fill(x_points3, y_points1, color3);
a3.FaceAlpha = 0.1;
hold on;
a4 = fill(x_points4, y_points1, color4);
a4.FaceAlpha = 0.1;
hold off
grid on;
legend('m_0','m_1','Location','northwest');
box on


nexttile
plot(globPPCm0,'Linewidth',1.5,'color',"#0072BD")
%xlim([xmin xmax])
title({"I. Profit", "percentage change"})
xlabel('Years')
ylabel('Percentage Change (%)')
xlim([xmin xmax])
xticks([148 173 198 223 248]) %([144 169 194 219 244]) %linspace(xmin+10, 244, 5)
set(gca,'XTickLabel',{'1950','1975','2000','2025','2050'})%{'1960','1985','2010','2035','2060'})
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
plot(globPPCm1,'Linewidth',1.5,'color',"#EDB120")
%legend('m_0','m_1','Location','northwest')
set(gca,'FontSize',11,'Linewidth',0.5)
hold on;
y_points1 = [min(ylim), max(ylim), max(ylim), min(ylim)];
a1 = fill(x_points1, y_points1, color1);
a1.FaceAlpha = 0.1;
a2 = fill(x_points2, y_points1, color2);
a2.FaceAlpha = 0.1;
hold on;
a3 = fill(x_points3, y_points1, color3);
a3.FaceAlpha = 0.1;
hold on;
a4 = fill(x_points4, y_points1, color4);
a4.FaceAlpha = 0.1;
hold off
grid on;
legend('m_0','m_1','Location','northwest');
box on


print(gcf,fullfile(Folder, 'figures/HRegMovementComparison/CombinedHReg(m1vsm0)TimeSeriesNEW_250ShadedPEAK2.png'),'-dpng','-r400');


globalTotalHm0reg1 = sum(globHboatsm0reg1(193:end,:)); %from when MPAs were implemented to end
globalTotalHm1reg1 = sum(globHboatsm1reg1(193:end,:));
globalTotalHm0reg0 = sum(globHboatsm0reg0(193:end,:));
globalTotalHm1reg0 = sum(globHboatsm1reg0(193:end,:));

globTotalHPCm1 = ((globalTotalHm1reg1 - globalTotalHm1reg0) ./ globalTotalHm1reg0)*100 ;
globTotalHPCm0 = ((globalTotalHm0reg1 - globalTotalHm0reg0) ./ globalTotalHm0reg0)*100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 
% nexttile
% plot(summedGlobalBM0,'Linewidth',1.5,'color',	"#0072BD")
% hold on;
% plot(summedGlobalBM1,'Linewidth',1.5,'color',	"#EDB120")
% %xlim([xmin xmax])
% title("D. Fish biomass")
% xlabel('Years')
% ylabel('Biomass (twB)')
% legend('no movement','movement','Location','southwest')
% set(gca,'FontSize',11,'Linewidth',0.5)
% nexttile 
% plot(GlobDiffB,'Linewidth',1.5,'color','black')
% %xlim([xmin xmax])
% title({"E. Fish biomass", "difference"})
% xlabel('Years')
% ylabel('Biomass (twB)')
% set(gca,'FontSize',11,'Linewidth',0.5)
% nexttile
% plot(GlobPercB,'Linewidth',1.5,'color','black')
% %xlim([xmin xmax])
% title({"F. Fish biomass", "percentage change"})
% xlabel('Years')
% ylabel('Percentage Change (%)')
% set(gca,'FontSize',11,'Linewidth',0.5)
% 
% 
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 30 18]);



%%%%%%%%%%% 
%plot biomass snap shot year 237

%get fish_t_out for all 

Bm0reg1 = squeeze(boatsm0reg1.output.annual.fish_t_out(237,:,:))*1e-9;
Bm1reg1 = squeeze(boatsm1reg1.output.annual.fish_t_out(237,:,:))*1e-9;
Bm1reg0 = squeeze(boatsm1reg0.output.annual.fish_t_out(237,:,:))*1e-9;
Bm0reg0 = squeeze(boatsm0reg0.output.annual.fish_t_out(237,:,:))*1e-9;

Pmin = 0; Pmax = prctile(Bm0reg1 ,95, "all");
t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Bm0reg1 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Biomass (twB m^-^2)');
title('MPAs without movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Bm1reg1 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Biomass (twB m^-^2)');
title('MPAs with movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Bm0reg0 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Biomass (twB m^-^2)');
title('Open access without movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Bm1reg0 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Biomass (twB m^-^2)');
title('Open access with movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])


set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
%print(gcf,'figures/HRegMovementComparison/SummedB(M1-M0)237YPerc95.png','-dpng','-r500'); 

exportgraphics(t,fullfile(Folder, 'figures/HRegMovementComparison/CombinedB(m1vsm0)99thPercY237.png'),"Resolution",700) 



%%%%%%%%%%%%%%%%
surf = squeeze(surf(:,:,1));
%load all harvest and get year 237
Hm0reg1 = squeeze(boatsm0reg1.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;
Hm1reg1 = squeeze(boatsm1reg1.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;
Hm1reg0 = squeeze(boatsm1reg0.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;
Hm0reg0 = squeeze(boatsm0reg0.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;

HDiffMapm1 = Hm1reg1 -Hm1reg0 ;
HDiffMapm0 = Hm0reg1 -Hm0reg0 ;

% HPCMapm1 = (Hm1reg1 -Hm1reg0) ./  Hm1reg0;
% HPCMapm0 = (Hm0reg1 -Hm0reg0) ./ Hm0reg0;

t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
Pmin = -prctile(HDiffMapm1,95, "all"); Pmax = prctile(HDiffMapm1,95, "all"); %prctile(HDiffMapm1,5, "all")
%Pmin = -5e-11; Pmax = 5e-11;
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,HDiffMapm0);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
title('A. Harvest change without movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,HDiffMapm1);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
title('B. Harvest change with movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

exportgraphics(t,fullfile(Folder, 'figures/HRegMovementComparison/HarvestLoss(m1vsm0)95thPercY237.png'),"Resolution",700) 


% t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
% Pmin = -1; Pmax = 1;
% nexttile
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,HPCMapm0);
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('blues','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Harvest (twB m^-^2 y^-^2)');
% title('Harvest difference without movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin Pmax])
% 
% nexttile
% Pmin = -5; Pmax = 5;
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,HPCMapm1);
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Harvest (twB m^-^2 y^-^2)');
% title('Harvest difference with movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin Pmax])

%%%%%%%%%%%%
%larval export
HLarvExpDDiff = HDiffMapm1 - HDiffMapm0;
%HLarvExpDPC = (HDiffMapm1 - HDiffMapm0) ./ HDiffMapm0; %not working
%because division by 0


t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
%Pmin = -0.5; Pmax = 0.5; 
Pmin = -prctile(HLarvExpDDiff,95, "all"); Pmax = prctile(HLarvExpDDiff,95, "all"); 
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,HLarvExpDDiff );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
title('Additional harvest (no movement vs movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
exportgraphics(t,fullfile(Folder, 'figures/HRegMovementComparison/HarvestLossDiff(m1vsm0)95thPercY237.png'),"Resolution",700) % of not working set resolution higher

%%%%%%%%%%%%% combine plots

t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
Pmin = -prctile(HDiffMapm1,95, "all"); Pmax = prctile(HDiffMapm1,95, "all"); %prctile(HDiffMapm1,5, "all")
%Pmin = -5e-11; Pmax = 5e-11;
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,HDiffMapm0);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
title('A. Harvest change without movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,HDiffMapm1);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
title('B. Harvest change with movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile([1 2])
Pmin1 = -prctile(HLarvExpDDiff,95, "all"); Pmax1 = prctile(HLarvExpDDiff,95, "all"); 
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,HLarvExpDDiff );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
title('C. Additional harvest','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin1 Pmax1])

exportgraphics(t,fullfile(Folder, 'figures/HRegMovementComparison/CombHChangePlots(m1vsm0)95thPercY237.png'),"Resolution",700) 

%%% save data 
load(fullfile(Folder, "Ecological.mat"))
maskLength = size(HLarvExpDDiff, 1)*size(HLarvExpDDiff, 2);

%init files
LarVExp = zeros(maskLength,3);
counter = 1;

%Bring lon, lat and ocean cell info together

    for i = 1:size(HLarvExpDDiff, 1)
        for j = 1:size(HLarvExpDDiff, 2)
        LarVExp(counter, 1) = Ecological.lon(i,j);
        LarVExp(counter, 2) = Ecological.lat(i,j);
        LarVExp(counter, 3) = HLarvExpDDiff(i,j); %land/ocean info
        counter = counter + 1;
        end
    end

writematrix(LarVExp,fullfile(Folder, 'LarvExp.csv'))

% load(fullfile(Folder, 'output_thesis/outputBoats_ThesisSN_reg1C_mvmt0_d250_h.mat'))
% boatsm0 = boats;
% surf = repmat(boats.forcing.surf,1,1,150);
% %surf = permute(surf, [3,1,2]);
% % Price, cost and profit [$ m-2 s-1]
% price          = boats.forcing_used.price(1);          % ONLY OK IF PRICE IS CONSTANT!
% cost_effort    = boats.forcing_used.cost_effort(1);    % ONLY OK IF COST per EFFORT IS CONSTANT!
% clear boats
% 
% load(fullfile(Folder, 'output_thesis/outputBoats_ThesisSN_reg1C_mvmt1_d250_h.mat'))
% boatsm1 = boats;
% clear boats
% 
% % 
% Pmin = 0; Pmax = 6;
% figure
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,test0 );
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Biomass (gwB m^-^2)');
% title('Difference in summed egg biomass (movement - no movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin Pmax])
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
% 
% 
% test1 = squeeze(boatsm1.output.annual.fish_t_out(240,:,:));
% 
% Pmin = 0; Pmax = 6;
% figure
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,test1 );
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',7);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 11;
% h.Label.String = ('Biomass (gwB m^-^2)');
% title('Difference in summed egg biomass (movement - no movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin Pmax])
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
