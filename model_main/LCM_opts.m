function opts = LCM_opts(opts, paired)
    
    % Set options.
    %
    % USAGE: opts = LCM_opts([opts])
    %
    % INPUTS:
    %   opts (optional) - options structure with a subset of fields
    %       specified. All missing or empty fields will be set to defaults. If
    %       opts = [], then the entire structure is set to defaults.
    %
    % OUTPUTS:
    %   opts - fully specified options structure
    %
    % DEFAULTS:
    %   opts.a = 1              (hyperparameter of beta prior: pseudo-count for feature presence)
    %   opts.b = 1              (hyperparameter of beta prior: pseudo-count for feature absence)
    %   opts.alpha = 0.0000001  (concentration parameter for Chinese restaurant process prior)
    %   opts.K = 10             (maximum number of latent causes)
    %   opts.M = 3000;          (number of particles; 1 = local MAP)
    %   opts.beta = 6;          (number of particles; 1 = local MAP)
    % Sam Gershman, July 2016, updated Feb 2020
    
    def_opts.a = 1;
    def_opts.b = 1;
    %def_opts.alpha = 0.0000001;
    %def_opts.K = 10;
    %def_opts.M = 3000;
    def_opts.alpha = 0.0000001;
    def_opts.K = 10;
    def_opts.M = 3000; 
    %value iteration parameters
    def_opts.beta_mean = 6; %inverse temperature parameter mean
    def_opts.beta_sd = 1; %inverse temperature parameter sd
    def_opts.n_states = 6; %number of states in the MDP
    def_opts.n_actions = 5; %number of possible actions
    def_opts.Rewards = [0 0 0 0 1 -3]; %rewards in each state (1-6)
    def_opts.MAX_N_ITERS = 100; 
    def_opts.CONV_TOL = 1e-3;
    def_opts.iterCnt = 0;
    def_opts.delta = 1e10;
    
    smat(:, :, 1) = [2, 3; 5, 3; NaN, NaN; NaN, NaN; NaN, NaN; NaN, NaN];

    if paired==1

        smat(:, :, 2) = [NaN, NaN; 6, 3; NaN, NaN; NaN, NaN; NaN, NaN; NaN, NaN];

    elseif (paired==0)

        smat(:, :, 2) = [NaN, NaN; 5, 3; NaN, NaN; NaN, NaN; NaN, NaN; NaN, NaN];

    end

    smat(:, :, 3) = [NaN, NaN; NaN, NaN; NaN, NaN; 3, NaN; NaN, NaN; NaN, NaN];
    smat(:, :, 4) = [3, 3; NaN, NaN; NaN, NaN; NaN, NaN; NaN, NaN; NaN, NaN];
    smat(:, :, 5) = [NaN, NaN; 5, 3; NaN, NaN; NaN, NaN; NaN, NaN; NaN, NaN]; %may want to go to disgust here rather than s5

    amat = [1, 2; 3, 4; NaN, NaN; 5, NaN];

    def_opts.smat = smat;
    def_opts.amat = amat;
    
    if nargin < 1 || isempty(opts)
        opts = def_opts;
    else
        F = fieldnames(def_opts);
        for f = 1:length(F)
            if ~isfield(opts,F{f}) || isempty(opts.(F{f}))
                opts.(F{f}) = def_opts.(F{f});
            end
        end
    end
    
    % make sure parameters aren't negative
    opts.a = max(opts.a, 0);
    opts.b = max(opts.b, 0);
    opts.alpha = max(opts.alpha, 0);
