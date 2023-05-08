%%%%%%%%%% Script to prepare MPA implementation %%%%%%%
%%% from Boats_VB1_reg0_mvmt0_monthly250_h.mat: maximum fishing in year 193 (=1995) 
%%% create a 5D file (lat, lon, nfish, nensemble, time)
%%% Here: time = 0:250; (0:193 no MPAs; 193:223 current MPAs; 223:228 half MPAs; 228:250: all MPAs)

%either run addCurrentMPAsToTop30.m or addCurrentMPAsToCheapest.m before 

simulationLength = 250;
MaxFishing = 193;
CurrentFishing = 30;
HalfFishing = 5;

load("MPAMatrixWaldronInclCurrent.mat")

noMPAs = MPAMatrix(:,:,1);
none = find(noMPAs>0);
noMPAs(none) = 0;

currentMPAs = MPAMatrix(:,:,1);
selectedHalfMPAs = MPAMatrix(:,:,4); %2 if cheapest, 4 if top 30
selectedFullMPAs = MPAMatrix(:,:,5); %3 if cheapest, 5 if top 30

effNone = noMPAs;
effNone(find(effNone == 0)) = 100;
%effNone(find(effNone == 100)) = 1;

effCurrent = currentMPAs;
effCurrent(find(effCurrent == 0)) = 100;
effCurrent(find(effCurrent == 1)) = 0;
%effCurrent(find(effCurrent == 100)) = 1;

effHalf = selectedHalfMPAs;
effHalf(find(effHalf == 0)) = 100;
effHalf(find(effHalf == 1)) = 0;
%effHalf(find(effHalf == 100)) = 1;

effFull = selectedFullMPAs;
effFull(find(effFull == 0)) = 100;
effFull(find(effFull == 1)) = 0;
%effFull(find(effFull == 100)) = 1;

EffNone = repmat(effNone,1,1,MaxFishing);%*timestep);
EffCurrent = repmat(effCurrent,1,1,CurrentFishing);%*timestep);
EffHalf = repmat(effHalf,1,1,HalfFishing);%*timestep);
EffFull = repmat(effFull,1,1,(simulationLength-MaxFishing-CurrentFishing-HalfFishing));%*timestep);
%EffFull = repmat(effFull,1,1,simulationLength*timestep);
%EffFull = repmat(EffFull,1,1,1,3);

effEtarget = permute([permute(EffNone, [3 1 2]); permute(EffCurrent, [3 1 2]); permute(EffHalf, [3 1 2]); permute(EffFull, [3 1 2]) ], [2 3 1]);
effEtarget = repmat(effEtarget,1,1,1,3); %all groups treated the same way, no ensemble so far

effEtarg = repmat(effEtarget,1,1,1,1,5);
%monthly: for each of the 250 years, create 12 identical matrices

%%% societal enforcement
socNone = noMPAs;

socCurrent = currentMPAs;
socCurrent(find(socCurrent == 1)) = 100;

socHalf = selectedHalfMPAs;
socHalf(find(socHalf == 1)) = 100;

socFull= selectedFullMPAs;
socFull(find(socFull == 1)) = 100;

SocNone = repmat(socNone,1,1,MaxFishing);%*timestep);
SocCurrent = repmat(socCurrent,1,1,CurrentFishing);%*timestep);
SocHalf = repmat(socHalf,1,1,HalfFishing);%*timestep);
SocFull = repmat(socFull,1,1,(simulationLength-MaxFishing-CurrentFishing-HalfFishing));%*timestep);
%SocFull = repmat(socFull,1,1,simulationLength*timestep);

societenf = permute([permute(SocNone, [3 1 2]); permute(SocCurrent, [3 1 2]); permute(SocHalf, [3 1 2]); permute(SocFull, [3 1 2]) ], [2 3 1]);
%societenf  = repmat(effEtarget,1,1,1,3); %all groups treated the same way, no ensemble so far
save('C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\input\relabeledForcings\societenfT.mat','societenf','-v7.3') 
save('C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\input\relabeledForcings\effEtargT.mat','effEtarg','-v7.3') 

%save('societenf.mat','societenf','-v7.3') %in input/relabeledForcings
%save('effEtarg.mat','effEtarg','-v7.3')

% load("Economical.mat")
% Economical.effEtarg = repmat(effEtarget,1,1,1,1,5);%effEtarget;
% Economical.societenf = societenf;
% save('Economical.mat','Economical','-v7.3')