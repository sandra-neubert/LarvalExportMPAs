%**************************************************************************
% BOATS PARAMETERS
% Default parameters and tunable variables, paths, of the BOATS model
%**************************************************************************
 

%**************************************************************************
% MAIN TUNABLE PARAMETERS
%**************************************************************************
% Paths *******************************************
%local
boats.param.path.wrkdir = ['C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\'];
boats.param.path.outdir = ['C:\Users\sandr\Documents\Github\ThesisSandra\Analysis\BOATS\sneubert-boats_v1\output\'];
% Server
%boats.param.path.wrkdir = ['/data/project3/sneubert/sneubert-boats_v1/'];
%boats.param.path.outdir = ['/data/project3/sneubert/sneubert-boats_v1/output/'];

% Names and Switches ******************************
 boats.param.main.sim_type     = 'nh';                                     % No Harvest 'nh' or Harvest 'h' simulation 
 boats.param.main.reg_type     = 'oa';                                  % Regulation mode: if not Open Access 'oa' -> target regulation 'omnT' 
 boats.param.main.incl_egg_move = 1;
 boats.param.main.sim_init     = 'PP';                              % Initialisation from 'PP' or else 'restart'
 boats.param.main.sim_name     = 'Boats_ThesisSN_reg0_mvmt1_d250';           % Simulation name (_nuclear for nuclear war simulations); m250 (monthly 250 years; d250: daily for 250 years); reg0C (cheapest waldron), reg0T (Top 30 Waldron)
 boats.param.main.model_version= 'VB1';                                    % Model version
 boats.param.main.save_restart = 1;                                        % Save restart: yes=1 ; no=0
 boats.param.main.save_output  = 1;                                           % Save output: yes=1 ; no=0
% Simulation features *****************************
 boats.param.main.run_length   = 250;                                      % Simulation length in years %210 years burnin, 29 years 150Tg, 16 yr 5-47 Tg, 149 end year for historical baseline
 boats.param.main.dtt          = 1;                                        % days per timestep (og: 30; daily: 1) %ADDED
 boats.param.main.nforcing     = 360;                                       % number of forcing to loop (og: 12; daily: 360)
 boats.param.main.param_ens    = 0;                                        % Use parameters ensembles: yes=1 ; no=0
 boats.param.main.dataset_ens  = 'ensemble_parameters.mat';                % if param_ens=1 name of ensemble parameters
%**************************************************************************
% END MAIN TUNABLE PARAMETERS
%**************************************************************************
 

%**************************************************************************
% CONVERSION FACTORS & EPSILON
%**************************************************************************
 boats.param.conversion.sperd        = 3600*24;                            % seconds per day
 boats.param.conversion.spery        = boats.param.conversion.sperd*360;   % seconds per year
 boats.param.conversion.sperfrc      = boats.param.conversion.sperd...
                                       *boats.param.main.dtt...
                                       *boats.param.main.nforcing;         % seconds per forcing %ADDED
 boats.param.conversion.gC_2_wetB    = 10;                                 % grams of wet fish biomass per gram of fish carbon
 boats.param.conversion.mmolC_2_wetB = (12*boats.param.conversion.gC_2_wetB)/1000; % grams of wet fish biomass per mmol of fish carbon
 boats.param.conversion.C_2_K        = 273.15;                             % deg C to Kelvin
 boats.param.conversion.epsln        = 1e-50;                              % small epsilon
 boats.param.main.dtts               =  boats.param.main.dtt*24*3600;                         % seconds per timestep

 
%**************************************************************************
% PARAMS RELATED TO THE ENVIRONMENT
%**************************************************************************
% Temperature *************************************
 boats.param.environment.E_activation_A = 0.45;                            % Activation energy of metabolism (growth A) (eV) (Savage et al., 2004)
 boats.param.environment.E_activation_m = 0.45;                            % Activation energy of metabolism (mortality) (eV) (Savage et al., 2004)
 boats.param.environment.k_Boltzmann    = 8.617e-05;                       % Boltzmann Constant (eV K-1)
 boats.param.environment.temp_ref_A     = 10 + 273.15;                     % Reference temperature (K) (Andersen and Beyer, 2013, p. 18)
% Primary production ******************************
 boats.param.environment.kappa_eppley = 0.063;                             % Eppley constant (degC-1)
 boats.param.environment.Prod_star    = 0.37;                              % Pivotal primary production (m mol C m-3 d-1)
 boats.param.environment.mc_phy_l     = 5.6234132519e-06;                  % mass of typical large phytoplankton (g)
 boats.param.environment.mc_phy_s     = 5.6234132519e-15;                  % mass of typical small phytoplankton (g)  e-12??
 boats.param.environment.cap_npp      = 10000;                             % limit on npp (m mol C m-2 d-)
 
 
%**************************************************************************
% PARAMS RELATED TO THE ECOLOGICAL MODULE 
%**************************************************************************
% Spectrum ****************************************
 boats.param.ecology.te          = 0.125;                                  % trophic efficiency
 boats.param.ecology.ppmr        = 5000;                                   % predator to prey mass ratio
 boats.param.ecology.tro_sca     = log10(boats.param.ecology.te)/log10(boats.param.ecology.ppmr); % trophic scaling
 boats.param.ecology.b_allo      = 0.66;                                   % allometric scaling
 boats.param.ecology.zeta1       = 0.57;                                   % constant mortality scaling
 boats.param.ecology.h_allo      = 0.5;                                    % mass scaling of mortality
 boats.param.ecology.eff_a       = 0.8;                                    % efficiency of activity (Andersen and Beyer, 2013, p. 4)
 boats.param.ecology.A00         = 4.46;                                   % allometric growth rate (Andersen and Beyer, 2013, p. 4)
 boats.param.ecology.fmass_0 	 = 10;                                     % initial mass class (g)
 boats.param.ecology.fmass_e 	 = 1e5;                                    % final mass class (g)
% Reproduction ************************************
 boats.param.ecology.m_egg       = 5.2e-4;                                 % egg mass (g)
 boats.param.ecology.frac_fem    = 0.5;                                    % fraction of individuals that allocate energy to reproduction (females)
 boats.param.ecology.egg_surv    = 0.01;                                   % egg survival
 boats.param.ecology.rep_slope   = 5;                                      % slope parameter of sigmoidal allocation to reproduction function
 boats.param.ecology.rep_pos     = 1;                                      % position parameter of sigmoidal allocation to reproduction function as fraction of malpha
% Size class **************************************
 boats.param.ecology.nfmass 	 = 50;                                     % number of fish mass classes
 boats.param.ecology.minf        = [0.01*(30/0.95)^3 0.01*(90/0.95)^3 1e5];% asymptotic mass
 boats.param.ecology.eta_alpha   = 0.25;						           % mass at maturity as fraction of asymptotic mass 
 boats.param.ecology.malpha      = boats.param.ecology.eta_alpha*boats.param.ecology.minf; % maturity mass
 boats.param.ecology.nfish       = length(boats.param.ecology.minf);       % number of fish groups
 
% Iron limitation **************************************
 boats.param.ecology.kfe         = 5; % coefficient determining sensitivity of fish biomass to iron (No3) concentration
                                       % set high (1e6) to have no limitation
 
%**************************************************************************
% PARAMS RELATED TO THE ECONOMICAL MODULE 
%**************************************************************************
 boats.param.economy.landedvalue_global = 8.4233e+10;                      % SAUP 1990-2006 average ($)
 boats.param.economy.yield_global       = 7.9963e+13;                      % SAUP 1990-2006 average (g)
 boats.param.economy.price_global       = boats.param.economy.landedvalue_global/boats.param.economy.yield_global;       % Global price ($ g-1)
 boats.param.economy.cost_global        = boats.param.economy.landedvalue_global;    % Global total cost ($) Assume C = R (matches Lam et al., 2011)
 boats.param.economy.effort_global      = 14.6229e9;                       % Global effort (W) (Watson et al. (2012) 1990-2006 average)
 boats.param.economy.cost_effort_0      = boats.param.economy.cost_global/(boats.param.economy.effort_global*boats.param.conversion.spery); % Cost per unit effort ($ W-1 s-1)
 boats.param.economy.k_e                = 1e-6;                            % Fleet dynamic parameter (W $-1 s-1) 1 W of effort per dollar of net revenue per second
 boats.param.economy.sel_pos_1          = 1;                               % Selectivity position shift 1
 boats.param.economy.sel_pos_2          = 0.5;                             % Selectivity position shift 2
 boats.param.economy.sel_pos_3          = 0.25;                            % Selectivity position shift 3
 boats.param.economy.sel_pos_scale      = 1;                               % Selectivity position scale
 boats.param.economy.sel_slope          = 18;                              % Selectivity slope
 boats.param.economy.harvest_start      = 0;                               % Year of starting harvest [y]
 boats.param.economy.qcatch0            = 1e-5 * 1.05^(-50);               % Base catchability
 boats.param.economy.price_0            = boats.param.economy.price_global;% Base price (constant)
 boats.param.economy.rc_q_ini           = 0;                               % Discount rate of catchability to determine initial value
 boats.param.economy.q_discount_y       = 0;                               % Number of years to discount catchability
% Regulation **************************************
 boats.param.economy.reg_timestep       = 'yearly';                       % 'monthly' or 'yearly' depending on assumptions about timeframe for update management advice
 boats.param.economy.reg_threshold      = 0.75;                            % Threshold value for regulation (fraction of maximum catch so far)
 boats.param.economy.times_length       = 10* boats.param.main.nforcing  ;%120;                             % Length of time span from which harvest is saved to determine time of regulation onset, max harvest,
 boats.param.economy.k_s                = 4*1e-8;                          % Regulation dynamics parameter
 boats.param.economy.precaut            = 1;                               % level of precaution if effort target smaller than the estimate E_MSY should be used (E_target = precaut * E_MSY)           
 
%**************************************************************************************************************
% END OF SCRIPT


 
