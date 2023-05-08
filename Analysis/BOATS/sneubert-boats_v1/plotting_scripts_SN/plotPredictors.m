%Plot predictors of GLM (R)
%Sandra Neubert
Folder = cd;
Folder = fullfile(Folder, '..');

load(fullfile(Folder, "Ecological.mat"))
npp = Ecological.npp;
temp = Ecological.temperature;

meanNPP  = squeeze(mean(npp,3));
meanTemp = squeeze(mean(temp,3));

addpath("C:\Users\sandr\Documents\MME\MA\m_map")
load(fullfile(Folder, "geo_time.mat"))

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);


t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
Pmin = 0; Pmax = prctile(meanNPP,99, "all");
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,meanNPP);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',20);%('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
%colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('NPP (mmolC m^-^2 s^-^1)'); % gwB m^-^2
h.Label.FontSize = 20;
h.FontSize = 20;
%title(h,'gwB/m2','fontsize',15);
title('Mean net primary production','fontsize',20, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
exportgraphics(t,fullfile(Folder, 'figures/PredictorsGLM/MeanNPP99th.png'),"Resolution",400)

t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,meanTemp);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',14);%('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
%colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('Temperature (°C)'); % gwB m^-^2
h.Label.FontSize = 14;
h.FontSize = 14;
%title(h,'gwB/m2','fontsize',15);
title('Mean temperature','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 25 18]); %x_width=10cm y_width=15cm
exportgraphics(t,fullfile(Folder, 'figures/PredictorsGLM/MeanTemp.png'),"Resolution",400)