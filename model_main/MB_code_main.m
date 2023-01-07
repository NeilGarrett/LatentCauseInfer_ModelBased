%% Simulation code for Context Devlaution (using Latent Cause Inference to infer and update state transition knowledge)
%% NGARETTT (July, 2022)

% This MATLAB script simulates choices over 4 phases of devaluation experiment. 
% Phases are as follows: 
% (1) Acquisition: learn pressing lever leads to food in context A [30 trials]
% (2a, 2b) Devaluation: food is devalued - leads to illness - (without presence of the lever, can be
% in context A or B) [30 trials]. note this is divided into two parts - devaluation and devaluation context exposure 
% (3) Lever Test: context A, lever present but unreinforced [1 trial]
% (4) Consumption Test: context A, no lever present [1 trial]

% Core idea is to show that context of the devluation phase (i.e. whether
% phase (2) occurs in context A/B) impacts lever pressing in (3) as shown
% by Bouton et el, 2021:

% Bouton ME, Allan SM, Tavakkoli A, Steinfeld MR, Thrailkill EA. 2021. 
% doi:10.1037/xan0000295

% The model should replicate 2 core findings:
% i) Lever pressing in (3) should be high when (2a/2b) occurs in context B and low
% when (2) occurs in A.
% ii) Consuption in (4) should be low both when (2a/2b) occurs in context B and
% when (2) occurs in A, i.e. direct aversion to the food is
% retained.

% outputs a csv file which can then be analysed (e.g., in R)

%% key for states and actions %%
%(see also diagram of MDP in the folder)

%s1 = lever press state (actions = (1)press lever (2) no press)
%s2 = having pressed lever, approach/consume state  (actions = (1)consume (2) no consume)
%s3 = no reward state (no actions)
%s4 = 
    %paired condition:  context exposure state (obligatory action leading to no reward)
    %unpaired condition:  unpaired injection (obligatory action leading to disgust)

%s5 = happy reward state (no actions)
%s6 = disgust state (no actions)
 
%a1 = press lever (from s1)
%a2 = ~press lever (from s1)
%a3 = approach/consume (from s2)
%a4 = ~approach/consume (from s2)
%a5 = obligatory action to go to: 
    % paired condition: no reward state (from s4)
    % unpaired condition: illness state (from s4)

%results are coded so that 
%a1 is always whether pressed lever or not on each trial (even if it's
%irrelevant such as in devaluation)
%a2 is always whether consumed state or not on each trial 
%a3 is obligatory action
 
%s1 is always start state
%s2 is always state after lever press
%s3 is always state after pel delivery

%% initalisation %%

clear all; close all; clc; %clear/close everything
rng('shuffle'); %randomise seed

%folder where scripts/functions and any data files are (input and output) -
%set to current folder
input_folder = pwd;

output_folder = input_folder; %output folder (where output is saved) same as input folder

cd(input_folder); %cd to here

%% specify parameters for the model %%

%% specify input for the model
paired_condition = [0, 1]; % (0) unpaired / (1) paired
training_length_ALL = [0, 1]; %1=devaluation occurs for 60 trials (double the acquisition length); 0=devaluation occurs for 30 trials (same as the acquisition length)
deval_ctxt_ALL = [0, 1]; %1=devaluation occurs in same context as acquisition; 0=devaluation occurs in alternate context as acquisition

%%%%%%%%%%%%%%%%%%%%%%
 %% SIMULATE MODEL %%
%%%%%%%%%%%%%%%%%%%%%%
nsims = 20; % number of simulations to run
nagents = 4; % number of agents per simulation

dat_tab_ALL = [];

results_counter = 0;

%% loop over simulations %%
for p = 1:length(paired_condition)
    
    for tl = 1:length(training_length_ALL)

        for dc = 1:length(deval_ctxt_ALL)

            results_counter = results_counter+1;

            paired = paired_condition(p);
            training_length = training_length_ALL(tl);
            deval_ctxt = deval_ctxt_ALL(dc);

            %print whether running paired/unpaired conditions
            disp(['Unpaired(0)/Paired(1): ', num2str(paired)]);

            %print training duration condition
            disp(['Training Duration: ', num2str(training_length)]);

            %print aversion conditioning context condition
            disp(['Aversion Context: ', num2str(deval_ctxt)]);

            %runs main simulation code
            [results_comp] = devaluation_simulate(nsims, nagents, training_length, deval_ctxt, paired);

            results_ALL{results_counter} = results_comp;

            %% compile into trial by trial table to save results
            [dat_tab] = csv_compile(nsims, nagents, results_comp);

            if (results_counter==1)
                dat_tab_ALL = dat_tab;
            else
                dat_tab_ALL = [dat_tab_ALL; dat_tab];            
            end

        end

    end

end

%% save results %%            
save('LCI_habits_simulation_results.mat', 'results_ALL');
writetable(dat_tab_ALL, 'LCI_habits_simulation_results.csv');
