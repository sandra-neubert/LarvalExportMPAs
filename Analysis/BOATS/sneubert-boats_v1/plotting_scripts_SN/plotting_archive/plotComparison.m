clear all

load('Boats_VB1_reg1_mvmt0_m250_relabledForcLockedInBoth_h.mat')

boatsomnT = boats;
lboatsomnT = squeeze(boatsomnT.output.annual.harvest_t_out(250,:,:));


% Nice map
addpath("C:\Users\sandr\Documents\MME\MA\m_map")

load("geo_time.mat")

LT     = repmat(geo_time.lat,1,360);
LG     = geo_time.lon';
LG     = repmat(LG,180,1);
 
Pmin = 0; Pmax = 5e-9;

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,lboatsomnT);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
colormap(m_colmap('blue','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('gwB s^-^1'); % gwB m^-^2
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('Harvest (regulated)','fontsize',14); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
%set(gcf,'color','w');
saveas(gcf, 'C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\figures\HarvestRegulated', 'jpeg');

load('Boats_VB1_reg0_mvmt0_m250_relabledForc_h.mat')
boatsoa = boats; 
lboatsoa = squeeze(boatsoa.output.annual.harvest_t_out(250,:,:));

%lboatsoa  = lboatsoa .* 31556952;

Pmin = 0; Pmax = 5e-9;

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,lboatsoa);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
colormap(m_colmap('blue','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('gwB s^-^1'); % gwB m^-^2
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('Harvest (open access)','fontsize',14); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
set(gcf,'color','w');
saveas(gcf, 'C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\figures\HarvestOA', 'jpeg');


test1 = lboatsoa - lboatsomnT;

Pmin = 0; Pmax = 5e-10;

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,test1);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
colormap(m_colmap('green','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('gwB s^-^1'); % gwB m^-^2
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('Harvest Difference (oa-reg)','fontsize',14); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
set(gcf,'color','w');
saveas(gcf, 'C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\figures\HarvestDifference', 'jpeg');
