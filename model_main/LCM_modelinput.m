function [X, phase, exp_phase, n_trials_training, n_trials_deval, n_trials_lever, n_trials_cons, results] = LCM_modelinput(training_length, deval_ctxt, paired)

 % Input to the model.
    %
    % USAGE: [X, phase, exp_phase] = LCM_modelinput(deval_ctxt, training_length)
    %
    % INPUTS:
    %   deval_ctxt - whether devaluation (phase 2) occurs in the same (coded 1) or
    %   alternate (coded 0) context
    %    
    %   training_length - duration of training either 30 (coded 0) or 60
    %   (coded 1)
    %       
    % OUTPUTS:
    %   X - trial by feature matrix (binary features). First 3 cols coded for contextual cues. 
    %   Last 3 cols code for presence/absence of the lever
    %   phase - stores in text the phase of the experiment on each trial (useful for compiling)
    %   exp_phase - stores in numbers the phase of the experiment on each trial (1=acquision, 2=devaluation, 3=devaluation context exposure, 4=lever test, 5=consumption test)     
  % Neil Garrett, June 2022, updated Feb 2020

if (training_length==0)
    n_trials_training = 30; % number of acquisition trials
elseif (training_length==1)
    n_trials_training = 60; % number of acquisition trials
end
    
n_trials_deval = 30; % number of devluation trials
n_trials_lever = 1; % number of lever test trials
n_trials_cons = 1; % number of consumption trials

context = [repmat(1, n_trials_training, 1); repmat(deval_ctxt, n_trials_deval, 1); repmat(1, n_trials_lever, 1); repmat(1, n_trials_cons, 1)];          
lever = [repmat(1, n_trials_training, 1); repmat(0, n_trials_deval, 1); repmat(1, n_trials_lever, 1); repmat(0, n_trials_cons, 1)];        
phase = [repmat({'acquisition'}, n_trials_training, 1); repmat({'devaluation'}, n_trials_deval/2, 1); repmat({'devaluation_contextexposure'}, n_trials_deval/2, 1); repmat({ 'lever_test'}, n_trials_lever, 1); repmat({'consumption_test'}, n_trials_cons, 1)];
exp_phase = [repmat(1, n_trials_training, 1); repmat(2, n_trials_deval/2, 1); repmat(3, n_trials_deval/2, 1); repmat(4, n_trials_lever, 1); repmat(5, n_trials_cons, 1)];

%X stores all cues - context and lever - times 3
X = [context, context, context, lever, lever, lever];

results.ntrials.training = n_trials_training;
results.ntrials.devaluation = n_trials_deval;
results.ntrials.levertest = n_trials_lever;
results.ntrials.constest = n_trials_cons;

results.contexts.training = 'chamber';
results.contexts.devaluation = 'chamber';
results.contexts.test = 'chamber';

if(deval_ctxt==1)
    results.devaluation_context = 'chamber';
elseif(deval_ctxt==0)
    results.devaluation_context = 'homecage';
end

if(training_length==0)
    results.acquisition_duration = 'normal';
elseif(training_length==1)
    results.acquisition_duration = 'extended';
end

if(paired==0)
    results.paired_unpaired = 'unpaired';
elseif(paired==1)
    results.paired_unpaired = 'paired';
end

results.phase = phase;
results.phase_coded = exp_phase;
results.context_cues = X;
                
end






