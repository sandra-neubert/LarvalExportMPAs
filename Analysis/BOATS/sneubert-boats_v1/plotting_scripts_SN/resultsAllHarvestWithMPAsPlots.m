%Plot Harvest in year 237 for all 4 simulations (movement vs no movement;
%MPA vs Open-access)
%For simulations with MPAs, put MPAs on top of maps

%Sandra Neubert

clear all

Folder = cd;
Folder = fullfile(Folder, '..');

addpath("C:\Users\sandr\Documents\MME\MA\m_map")

load(fullfile(Folder, "geo_time.mat"))

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);


load(fullfile(Folder, 'output_thesis/outputBoats_ThesisSN_reg1C_mvmt0_d250_h.mat'))
boatsm0reg1 = boats;
surf = repmat(boats.forcing.surf,1,1,150);
surf = permute(surf, [3,1,2]);
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


Hm0reg1 = squeeze(boatsm0reg1.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;
Hm1reg1 = squeeze(boatsm1reg1.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;   
Hm1reg0 = squeeze(boatsm1reg0.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;   
Hm0reg0 = squeeze(boatsm0reg0.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;   

load(fullfile(Folder, "preprocessingMPAs/MPAMatrixWaldronInclCurrent.mat"))

cheapestFullMPAs = MPAMatrix(:,:, 3);
MpaTest1 = cheapestFullMPAs(16:165,:);
MpaTest = MpaTest1;
MpaTest(find(MpaTest1 < 1)) = nan;

Hm1reg1NoMPA = Hm1reg1 ;
Hm1reg1NoMPA(find(MpaTest1 == 1)) = nan;

Hm0reg1NoMPA = Hm0reg1 ;
Hm0reg1NoMPA(find(MpaTest1 == 1)) = nan;

%regulation simulations first
t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
Pmin = 0; Pmax = prctile(Hm1reg1,95, "all");
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,MpaTest);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(flipud(hot)) %(parula(2)) %hot pink summer
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('Cheapest MPAs (Full)','fontsize',12);
%a=get(cb); %gets properties of colorbar
%a =  a.Position;
%set(cb,'Position',[0.87 0.07 0.03 0.08]) % a(1)+dx a(2)+dy w h]
freezeColors; %freezeColors(jicolorbar);
hold on
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm0reg1NoMPA);
%m_coast('patch',[.8 .8 .8],'edgecolor','black');
%m_grid('tickdir','out','fontsize',10);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 12;
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('A. Harvest (MPAs without movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,MpaTest);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
cb = colorbar;
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(flipud(hot)) %(parula(2)) %hot pink summer
cb.Label.FontSize = 12;
title('Cheapest MPAs (Full)','fontsize',12);
freezeColors; %freezeColors(jicolorbar);
hold on
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm1reg1NoMPA);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 12;
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('B. Harvest (MPAs with movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm0reg0 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 12;
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('C. Harvest (Open access without movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm1reg0 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 12;
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('D. Harvest (Open access with movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
exportgraphics(t,fullfile(Folder, 'figures/HRegMovementComparison/CombinedHRegY237MPAs.png'),"Resolution",700)

%regulation simulations last
t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
Pmin = 0; Pmax = prctile(Hm1reg1,95, "all");
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm0reg0 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 12;
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('A. Harvest (Open access without movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm1reg0 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 12;
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('B. Harvest (Open access with movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,MpaTest);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(flipud(hot)) %(parula(2)) %hot pink summer
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('Cheapest MPAs (Full)','fontsize',12);
%a=get(cb); %gets properties of colorbar
%a =  a.Position;
%set(cb,'Position',[0.87 0.07 0.03 0.08]) % a(1)+dx a(2)+dy w h]
freezeColors; %freezeColors(jicolorbar);
hold on
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm0reg1NoMPA);
%m_coast('patch',[.8 .8 .8],'edgecolor','black');
%m_grid('tickdir','out','fontsize',10);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 12;
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('C. Harvest (MPAs without movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,MpaTest);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
cb = colorbar;
caxis([-0.5 1.5]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(flipud(hot)) %(parula(2)) %hot pink summer
cb.Label.FontSize = 12;
title('Cheapest MPAs (Full)','fontsize',12);
freezeColors; %freezeColors(jicolorbar);
hold on
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm1reg1NoMPA);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 12;
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('D. Harvest (MPAs with movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

exportgraphics(t,fullfile(Folder, 'figures/HRegMovementComparison/CombinedHRegY237MPAsFlipped.png'),"Resolution",700)

