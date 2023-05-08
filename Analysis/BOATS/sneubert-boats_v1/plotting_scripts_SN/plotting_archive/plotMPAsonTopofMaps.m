% t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
% Pmin = 0; Pmax = prctile(Hm1reg1 ,95, "all");
% nexttile
% m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,Hm1reg1);
% m_coast('patch',[.8 .8 .8],'edgecolor','black');
% m_grid('tickdir','out','fontsize',10);
% colormap(m_colmap('blues','step',6));
% h=colorbar('eastoutside');%,'Ticks');
% h.FontSize = 14;
% h.Label.FontSize = 14;
% h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
% title('(Harvest (MPAs without movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% % set(h,'tickdir','out')
% caxis([Pmin Pmax])
% %set(h,'Position',[0.87 0.07 0.03 0.08]) % a(1)+dx a(2)+dy w h]
% freezeColors; freezeColors(jicolorbar(('hshort'))); %cant plot title
% hold on
% %m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
% m_pcolor(LG,LT,MpaTest);
% cb = colorbar;
% %ylabel(cb,'data rate') 
% caxis([-0.5 1.5]) 
% cb.Ticks = [0 1]; 
% cb.TickLabels = {'No MPA','MPA'}; 
% colormap(parula(2))
% %cb.AxisLocation = 'in'
% cb.Label.FontSize = 12;
% title('Cheapest MPAs (Full)','fontsize',14);
% a=get(cb); %gets properties of colorbar
% a =  a.Position;
% set(cb,'Position',[0.87 0.07 0.03 0.08]) % a(1)+dx a(2)+dy w h]


cheapestFullMPAs = MPAMatrix(:,:, 3);
MpaTest1 = cheapestFullMPAs(16:165,:);
MpaTest = MpaTest1;
MpaTest(find(MpaTest1 < 1)) = nan;

Hm1reg1NoMPA = Hm1reg1 ;
Hm1reg1NoMPA(find(MpaTest1 == 1)) = nan;

t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
Pmin = 0; Pmax = prctile(Hm1reg1NoMPA,95, "all");
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
title('Cheapest MPAs (Full)','fontsize',14);
%a=get(cb); %gets properties of colorbar
%a =  a.Position;
%set(cb,'Position',[0.87 0.07 0.03 0.08]) % a(1)+dx a(2)+dy w h]
freezeColors; %freezeColors(jicolorbar);
hold on
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,Hm1reg1NoMPA);
%m_coast('patch',[.8 .8 .8],'edgecolor','black');
%m_grid('tickdir','out','fontsize',10);
colormap(m_colmap('blues','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.FontSize = 14;
h.Label.FontSize = 14;
h.Label.String = ('Harvest (twB m^-^2 yr^-^1)');
title('(Harvest (MPAs without movement)','fontsize',14, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
%set(h,'Position',[0.87 0.07 0.03 0.08]) % a(1)+dx a(2)+dy w h]
%freezeColors; freezeColors(jicolorbar(('hshort'))); %cant plot title
exportgraphics(t,'figures/HMovementComparison/Hm0reg199thPercMPAs.png',"Resolution",500) % of not working set resolution higher


figure
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,MpaTest);
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


figure
surf(peaks); colormap parula; freezeColors; freezeColors(jicolorbar); hold on
surf(peaks+20); caxis([14 28]); colormap gray; freezeColors; freezeColors(colorbar);
surf(peaks+40); caxis(caxis+20); colormap hot; freezeColors; freezeColors(jicolorbar('horiz'));
axis auto; shading interp; caxis([14 28]); view([-27 14]); set(gca,'color',[.8 .8 .8])