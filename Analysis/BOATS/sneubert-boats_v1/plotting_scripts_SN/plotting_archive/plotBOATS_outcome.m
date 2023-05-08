

%varOut = squeeze(nanmean(boats.output.annual.harvest_t_out));

%figure
%imAlpha=ones(size(squeeze(varOut(:,:))));
%imAlpha(isnan(squeeze(varOut(:,:))))=0;
%imagesc(squeeze(varOut(:,:)),'AlphaData',imAlpha);
%set(gca,'color',0*[1 1 1]);

%fname = 'C:\Users\sandr\Documents\Github\Thesis_Morgane\kscherrer-boats_v1\figures\';
%saveas(figure, 'C:\Users\sandr\Documents\Github\Thesis_Morgane\kscherrer-boats_v1\figures\test', 'jpeg');

clear all

% Nice map
addpath("C:\Users\sandr\Documents\MME\MA\m_map")

load("geo_time.mat")

LT     = repmat(geo_time.lat,1,360);
LG     = geo_time.lon';
LG     = repmat(LG,180,1);
 
%biomass
biomass=squeeze(boats.output.annual.fish_g_out(190,:,:,1));

%Pmax = 1e-15; Pmin = -1e-15;
Pmin = 0; Pmax = 100;

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,biomass);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('twB m^-^2'); % gwB m^-^2
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('Biomass','fontsize',14); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
%caxis([Pmin Pmax])
%set(gcf,'color','w');
saveas(gcf, 'C:\Users\sandr\Documents\Github\Thesis_Morgane\kscherrer-boats_v1\figures\boats_reg_0_no_mvmt_h_biomass', 'jpeg');
%_societenf1_effEtarget1

%Harvest
harvest=squeeze(boats.output.annual.harvest_g_out(180,:,:,2));

Pmin = 0; Pmax = 1e-9;

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,harvest);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('gwB y^-^1'); % gwB m^-^2
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('Harvest','fontsize',14); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
%set(gcf,'color','w');
saveas(gcf, 'C:\Users\sandr\Documents\Github\Thesis_Morgane\kscherrer-boats_v1\figures\boats_reg_1_no_mvmt_h_harvest', 'jpeg');


%effort
effort=squeeze(boats.output.annual.effort_g_out(3,:,:,2));
Pmin = 0; Pmax = 1e-3;

figure
m_proj('robinson','lon',[0 360]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,effort);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('W m^-^2'); % gwB m^-^2
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('Effort','fontsize',14); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
%set(gcf,'color','w');
saveas(gcf, 'C:\Users\sandr\Documents\Github\Thesis_Morgane\kscherrer-boats_v1\figures\boats_reg_1_no_mvmt_h_effort', 'jpeg');



%timeseries
test = boats.output.annual.fish_gi_g;
test = boats.output.annual.effort_gi_g;
test = boats.output.annual.harvest_gi_g;

plot(test)
ylabel('Biomass')
xlabel("Time in Years")
legend({'Size Class 1','Size Class 2', 'Size Class 3'},'Location','northeast')
ax = gca;
ax.FontSize = 13;