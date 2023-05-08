addpath("C:\Users\sandr\Documents\MME\MA\m_map")

load("geo_time.mat")

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);


load('output_thesis/outputBoats_ThesisSN_reg1C_mvmt0_d250_h.mat')
boatsm0reg1 = boats;
surf = repmat(boats.forcing.surf,1,1,150);
surf = permute(surf, [3,1,2]);
clear boats

load('output_thesis/outputBoats_ThesisSN_reg0_mvmt0_d250_h.mat')
boatsm0reg0 = boats;
clear boats

load('output_thesis/outputBoats_ThesisSN_reg1C_mvmt1_d250_h.mat')
boatsm1reg1 = boats;
clear boats

load('output_thesis/outputBoats_ThesisSN_reg0_mvmt1_d250_h.mat')
boatsm1reg0 = boats;
clear boats


Hm0reg1 = squeeze(boatsm0reg1.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;
Hm1reg1 = squeeze(boatsm1reg1.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;   
Hm1reg0 = squeeze(boatsm1reg0.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;   
Hm0reg0 = squeeze(boatsm0reg0.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;   


t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
Pmin = 0; Pmax = prctile(Hm1reg1,95, "all");
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm0reg1 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 11;
h.Label.String = ('Harvest (gwB m^-^2 s^-^2)');
title('MPAs without movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm1reg1 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 11;
h.Label.String = ('Harvest (gwB m^-^2 s^-^2)');
title('MPAs with movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm0reg0 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 11;
h.Label.String = ('Harvest (gwB m^-^2 s^-^2)');
title('Open access without movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm1reg0 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 11;
h.Label.String = ('Harvest (gwB m^-^2 s^-^2)');
title('Open access with movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
exportgraphics(t,'figures/HMovementComparison/CombinedHTEST.png',"Resolution",700)

%indiviudal graphs
%Hm1reg1 = squeeze(boats.output.annual.harvest_t_out(237,:,:));


t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
Pmin = 0; Pmax = prctile(Hm1reg1 ,95, "all");
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm0reg1 );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',10);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 14;
h.Label.FontSize = 14;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('(Harvest (MPAs without movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])

exportgraphics(t,'figures/HMovementComparison/Hm0reg1.png',"Resolution",400)
