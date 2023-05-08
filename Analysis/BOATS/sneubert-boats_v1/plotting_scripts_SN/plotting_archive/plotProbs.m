addpath("C:\Users\sandr\Documents\MME\MA\m_map")

load("geo_time.mat")

% LT     = repmat(geo_time.lat,1,360);
% LG     = geo_time.lon';
% LG     = repmat(LG,180,1);

LT     = repmat(geo_time.lat(16:165,:),1,360);
LG     = geo_time.lon';
LG     = repmat(LG,150,1);
% 
% testMPAs = societenf(:,:,250);
% figure
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); 

testMove = squeeze(ProbMat(1,1,:,:));
figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,testMove );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',7);%('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
%colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('Probability'); % gwB m^-^2
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('Probability to stay in a cell (January)','fontsize',14); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
print(gcf,'testProbs3.png','-dpng','-r500'); 
