addpath("C:\Users\sandr\Documents\MME\MA\m_map")

load("geo_time.mat")

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);
% 

%PlotMPAs
testrestart = restart.dfish;
examplerestart = squeeze(testrestart(:,:,2, 1));

Pmin = 0; Pmax = 1e-1;
figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,examplerestart );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
colormap(m_colmap('blue','step',6));
h=colorbar('eastoutside');%,'Ticks');
%h.Label.String = ('gwB s^-^1'); % gwB m^-^2
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('Egg Biomass (open access)','fontsize',14); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
set(gcf,'color','w');
