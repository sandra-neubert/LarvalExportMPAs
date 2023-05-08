%Run script resultsRegComparisonPlots.m before to get data

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

%load all harvest and get year 237
Hm0reg1 = squeeze(boatsm0reg1.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;
Hm1reg1 = squeeze(boatsm1reg1.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;
Hm1reg0 = squeeze(boatsm1reg0.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;
Hm0reg0 = squeeze(boatsm0reg0.output.annual.harvest_t_out(237,:,:))*3600*24*360*1e-9;

HDiffMapm1 = Hm1reg1 -Hm1reg0 ;
HDiffMapm0 = Hm0reg1 -Hm0reg0 ;

HLarvExpDDiff = HDiffMapm1 - HDiffMapm0;
%HLarvExpDPC = (HDiffMapm1 - HDiffMapm0) ./ HDiffMapm0; %not working
%because division by 0

load(fullfile(Folder, "preprocessingMPAs/MPAMatrixWaldronInclCurrent.mat"))

cheapestFullMPAs = MPAMatrix(:,:, 3);
MpaTest1 = cheapestFullMPAs(16:165,:);
MpaTest = MpaTest1;
MpaTest(find(MpaTest1 < 1)) = nan;

HLarvExpDDiffNoMPA = HLarvExpDDiff;
HLarvExpDDiffNoMPA(find(MpaTest1 == 1)) = nan;

unfreezeColors

t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
nexttile
m_proj('robinson','lon',[210 300], 'lat', [-42 10]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,invStayProb );
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',10);%('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
%colormap(m_colmap('divergent','step',6));
%colormap(m_colmap('jet','step',6));
colormap();
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('Probability (%)'); % gwB m^-^2
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('A. Movement index','fontsize',12);%, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 27 18]); %x_width=10cm y_width=15cm
exportgraphics(t,fullfile(Folder, 'figures/CutOutFigures/HumboldtCutoutMoveInd.png'),"Resolution",500)

t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
Pmin = 0; Pmax = prctile(meanNPP,99, "all");
nexttile
m_proj('robinson','lon',[210 300], 'lat', [-42 10]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,meanNPP);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',10);%('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
%colormap(m_colmap('divergent','step',6));
%colormap(m_colmap('jet','step',6));
colormap();
h=colorbar('eastoutside');%,'Ticks');
h.Label.String = ('NPP (mmolC m^-^2 s^-^1)'); % gwB m^-^2
%h.FontSize = 14;
h.Label.FontSize = 12;
%title(h,'gwB/m2','fontsize',15);
title('C. Mean net primary production','fontsize',12);%, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 27 18]); %x_width=10cm y_width=15cm
exportgraphics(t,fullfile(Folder, 'figures/CutOutFigures/HumboldtCutoutMeanNPP99th.png'),"Resolution",500)

t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
%Pmin = -0.5; Pmax = 0.5; 
Pmin = -prctile(HLarvExpDDiffNoMPA,95, "all"); Pmax = prctile(HLarvExpDDiffNoMPA,95, "all"); 
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,MpaTest);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.7 1.8]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(gray)%flipud(turbo)) %(parula(2)) %hot pink summer
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('Cheapest MPAs (Full)','fontsize',12);
%a=get(cb); %gets properties of colorbar
%a =  a.Position;
%set(cb,'Position',[0.87 0.07 0.03 0.08]) % a(1)+dx a(2)+dy w h]
freezeColors; %freezeColors(jicolorbar);
hold on;
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,HLarvExpDDiffNoMPA);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
title('Additional harvest (no movement vs movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])


t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
%Pmin = -0.5; Pmax = 0.5; 
Pmin = -prctile(HLarvExpDDiffNoMPA,95, "all"); Pmax = prctile(HLarvExpDDiffNoMPA,95, "all"); 
nexttile
m_proj('robinson','lon',[210 300], 'lat', [-42 10]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,MpaTest);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',10);
cb = colorbar;
%ylabel(cb,'data rate') 
caxis([-0.7 1.8]) 
cb.Ticks = [0 1]; 
cb.TickLabels = {'No MPA','MPA'}; 
colormap(gray)%flipud(turbo)) %(parula(2)) %hot pink summer
%cb.AxisLocation = 'in'
cb.Label.FontSize = 12;
title('Cheapest MPAs (Full)','fontsize',12);
freezeColors; %freezeColors(jicolorbar);
hold on;
m_pcolor(LG,LT,HLarvExpDDiffNoMPA);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
title('B. Additional harvest','fontsize',12);%, 'Position', [0 0.01 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 27 18]); %x_width=10cm y_width=15cm
exportgraphics(t,fullfile(Folder, 'figures/CutOutFigures/HumboldtCutoutLarvExNew.png'),"Resolution",500)



% 
% unfreezeColors()
% t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
% %Pmin = -0.5; Pmax = 0.5; 
% Pmin = -prctile(HLarvExpDDiffNoMPA,95, "all"); Pmax = prctile(HLarvExpDDiffNoMPA,95, "all"); 
% nexttile
% m_proj('robinson','lon',[210 300], 'lat', [-42 10]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,invStayProb );
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',12);%('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
% %colormap(m_colmap('divergent','step',6));
% colormap(m_colmap('jet','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.String = ('Probability (%)'); % gwB m^-^2
% h.Label.FontSize = 12;
% %title(h,'gwB/m2','fontsize',15);
% title('Movement Index','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% freezeColors;freezeColors(colorbar);
% 
% nexttile
% m_proj('robinson','lon',[210 300], 'lat', [-42 10]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,MpaTest);
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',12);
% cb = colorbar;
% %ylabel(cb,'data rate') 
% caxis([-0.7 1.8]) 
% cb.Ticks = [0 1]; 
% cb.TickLabels = {'No MPA','MPA'}; 
% colormap(gray)%flipud(turbo)) %(parula(2)) %hot pink summer
% %cb.AxisLocation = 'in'
% cb.Label.FontSize = 12;
% title('Cheapest MPAs (Full)','fontsize',12);
% freezeColors; %freezeColors(jicolorbar);
% hold on;
% m_pcolor(LG,LT,HLarvExpDDiffNoMPA);
% colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 12;
% h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
% title('Harvest change difference (no movement vs movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin Pmax])
% 
% %%%%%%%%
% unfreezeColors()
% 
% figure
% ax(1)= subplot(1,2,1);
% %t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
% %Pmin = -0.5; Pmax = 0.5; 
% Pmin = -prctile(HLarvExpDDiffNoMPA,95, "all"); Pmax = prctile(HLarvExpDDiffNoMPA,95, "all"); 
% %nexttile
% m_proj('robinson','lon',[210 300], 'lat', [-42 10]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,invStayProb );
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',12);%('xticklabels',['','','','','',''],'yticklabels',['','','','','',''],'tickdir','out','linewi',1);
% %colormap(m_colmap('divergent','step',6));
% colormap(ax(1),gray)
% %colormap(m_colmap('jet','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.String = ('Probability (%)'); % gwB m^-^2
% h.Label.FontSize = 12;
% %title(h,'gwB/m2','fontsize',15);
% title('Movement Index','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% freezeColors;%freezeColors(colorbar);
% 
% ax(2) = subplot(1,2,2);
% m_proj('robinson','lon',[210 300], 'lat', [-42 10]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,MpaTest);
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',12);
% cb = colorbar;
% %ylabel(cb,'data rate') 
% caxis([-0.7 1.8]) 
% cb.Ticks = [0 1]; 
% cb.TickLabels = {'No MPA','MPA'}; 
% colormap(gray)%flipud(turbo)) %(parula(2)) %hot pink summer
% %cb.AxisLocation = 'in'
% cb.Label.FontSize = 12;
% title('Cheapest MPAs (Full)','fontsize',12);
% freezeColors; %freezeColors(jicolorbar);
% hold on;
% m_pcolor(LG,LT,HLarvExpDDiffNoMPA);
% colormap(ax(2),m_colmap('divergent','step',6))
% %colormap(m_colmap('divergent','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.Label.FontSize = 12;
% h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
% title('Harvest change difference (no movement vs movement)','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin Pmax])
