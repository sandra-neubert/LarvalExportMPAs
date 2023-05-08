
plot(boats.output.annual.fish_gi_g.* 1e-15) %to tonnes
saveas(gcf, 'C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\figures\Boats_VB1_reg0_mvmt0_m250_relabledForcLockedInBoth_h_biomass', 'jpeg');

plot(boats.output.annual.harvest_gi_g .* 3.154e+7 .* 1e-12) %from seconds to year and then from g to Mt
saveas(gcf, 'C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\figures\Boats_VB1_reg0_mvmt0_m250_relabledForcLockedInBoth_h_harvest', 'jpeg');

plot(boats.output.annual.effort_gi_g)
saveas(gcf, 'C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\figures\Boats_VB1_reg0_mvmt0_m250_relabledForcLockedInBoth_h_effort', 'jpeg');