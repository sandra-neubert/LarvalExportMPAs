%Plot MPAs
%Sandra Neubert

clear all

Folder = cd;
Folder = fullfile(Folder, '..');

load(fullfile(Folder, "preprocessingMPAs/MPAMatrixWaldronInclCurrent.mat"))

addpath("C:\Users\sandr\Documents\MME\MA\m_map")
load(fullfile(Folder, "geo_time.mat"))

LT     = repmat(geo_time.lat,1,360);
LG     = geo_time.lon';
LG     = repmat(LG,180,1);

%PlotMPAs
currentMPAs = MPAMatrix(:,:, 1);
cheapestHalfMPAs = MPAMatrix(:,:, 2);
cheapestFullMPAs = MPAMatrix(:,:, 3);
top30HalfMPAs = MPAMatrix(:,:,4);
top30FullMPAs = MPAMatrix(:,:,5);

%Indiviudal MPAs
%Pmin = 0; Pmax = 1e-9;
figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,currentMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(parula(2))
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('Current MPAs','fontsize',14);
a=get(cb); %gets properties of colorbar
a =  a.Position;
set(cb,'Position',[0.85 0.25 0.03 0.08])
print(gcf,fullfile(Folder, 'figures/MPAs/CurrentMPAs.png'),'-dpng','-r500'); 

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,cheapestHalfMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(parula(2))
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('Cheapest MPAs (Half)','fontsize',14);
a=get(cb); %gets properties of colorbar
a =  a.Position;
set(cb,'Position',[0.85 0.25 0.03 0.08])
print(gcf,fullfile(Folder, 'figures/MPAs/CheapestHalfMPAsLockedInAreas.png'),'-dpng','-r500'); 

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,cheapestFullMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(parula(2))
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('Cheapest MPAs (Full)','fontsize',14);
a=get(cb); %gets properties of colorbar
a =  a.Position;
set(cb,'Position',[0.85 0.25 0.03 0.08])
print(gcf,fullfile(Folder, 'figures/MPAs/CheapestFullMPAsLockedInAreas.png'),'-dpng','-r500');

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,top30HalfMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(parula(2))
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('Top 30 MPAs (Half)','fontsize',14);
a=get(cb); %gets properties of colorbar
a =  a.Position;
set(cb,'Position',[0.85 0.25 0.03 0.08])
print(gcf,fullfile(Folder, 'figures/MPAs/top30HalfMPAsLockedInAreas.png'),'-dpng','-r500'); 

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,top30FullMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(parula(2))
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('Top 30 MPAs (Full)','fontsize',14);
a=get(cb); %gets properties of colorbar
a =  a.Position;
set(cb,'Position',[0.85 0.25 0.03 0.08])
print(gcf,fullfile(Folder, 'figures/MPAs/top30FullMPAsLockedInAreas.png'),'-dpng','-r500'); 



% figure
% h1 = subplot(1,3,1);
t = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');
nexttile([2 1])
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,currentMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',8);
title('A. Current MPAs','fontsize',12);

nexttile
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,cheapestHalfMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',8);
title('B. Cheapest MPAs (Half)','fontsize',12);

nexttile
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,cheapestFullMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',8);
title('C. Cheapest MPAs (Full)','fontsize',12);


nexttile
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,top30HalfMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',8);
title('D. Top 30 MPAs (Half)','fontsize',12);


nexttile
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,top30FullMPAs);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',8);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(parula(2))
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('E. Top 30 MPAs (Full)','fontsize',12);
a=get(cb); %gets properties of colorbar
a =  a.Position;
set(cb,'Position',[0.4 0.5 0.017 0.055])

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 29 18]); %x_width=10cm y_width=15cm

exportgraphics(t,fullfile(Folder, 'figures/MPAs/MPAsComb.png'),"Resolution",600) % of not working set resolution higher

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);

%Plot only cheapest MPAs
% h1 = subplot(1,3,1);
t = tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact');
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]);
m_pcolor(LG,LT,currentMPAs(16:165,:));
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',11);
title('A. Current MPAs','fontsize',12);

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]);
m_pcolor(LG,LT,cheapestHalfMPAs(16:165,:));
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',11);
title('B. Cheapest MPAs (Half)','fontsize',12);

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]);
m_pcolor(LG,LT,cheapestFullMPAs(16:165,:));
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',11);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(parula(2))
%cb.AxisLocation = 'in'
cb.Label.FontSize = 14;
cb.FontSize = 14;
title('C. Cheapest MPAs (Full)','fontsize',12);
a=get(cb); %gets properties of colorbar
a =  a.Position;
set(cb,'Position',[0.91 0.29 0.017 0.055])

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 29 18]); %x_width=10cm y_width=15cm

exportgraphics(t,fullfile(Folder, 'figures/MPAs/MPAsCheapestComb.png'),"Resolution",400) % of not working set resolution higher
