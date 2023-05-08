warning on MATLAB:divideByZero
warning off MATLAB:divideByZero

testHm1reg1 = Hm1reg1;
testHm1reg1(find(Hm1reg1 == 0)) = nan;
testHm1reg1(find(isnan(testHm1reg1))) = 999999;

testHm0reg1 = Hm0reg1;
testHm0reg1(find(Hm0reg1 == 0)) = nan;
testHm0reg1(find(isnan(testHm0reg1))) = 999999;

cheapestFullMPAs = MPAMatrix(:,:, 3);
MpaTest1 = cheapestFullMPAs(16:165,:);
MpaTest = MpaTest1;
MpaTest(find(MpaTest1 < 1)) = nan;

Hm1reg1NoMPA = Hm1reg1 ;
Hm1reg1NoMPA(find(MpaTest1 == 1)) = nan;

Hm0reg1NoMPA = Hm0reg1 ;
Hm0reg1NoMPA(find(MpaTest1 == 1)) = nan;

testPerc = (Hm1reg1NoMPA-Hm0reg1NoMPA) ./ Hm0reg1NoMPA;
%testPerc(find(testPerc == 1)) = 0;

t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
Pmin = -prctile(testPerc,95, "all"); Pmax = prctile(testPerc,95, "all"); %prctile(HDiffMapm1,5, "all")
%Pmin = -5e-11; Pmax = 5e-11;
nexttile
m_proj('robinson','lon',[0 360], 'lat', [-75 75]); %to get cutout of map give smaller window in [ ]
m_pcolor(LG,LT,testPerc);
m_coast('patch',[.8 .8 .8],'edgecolor','black');
m_grid('tickdir','out','fontsize',12);
colormap(m_colmap('divergent','step',6));
h=colorbar('eastoutside');%,'Ticks');
h.Label.FontSize = 12;
h.Label.String = ('Harvest (twB m^-^2 y^-^1)');
title('A. Harvest change without movement','fontsize',12, 'Position', [0 1.6 0]); % ' (' num2str(round(Biom07_2010*1e-15,0)) ' Gt)'
% set(h,'tickdir','out')
caxis([Pmin Pmax])
