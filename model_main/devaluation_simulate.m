function [results_comp] = devaluation_simulate(nsims, nagents, training_length, deval_ctxt, paired)

    opts = LCM_opts([], paired); %load in options (function: LCM_opts), defaults loaded in if no arguments are specfied 

    M = opts.M; a = opts.a; b = opts.b; alpha = opts.alpha; K = opts.K;

    %parameters for the MDP and value iteration
    beta_mean = opts.beta_mean;
    beta_sd = opts.beta_sd;
    n_states = opts.n_states; %number of seperate states in the MDP
    n_actions = opts.n_actions; %number of actions available over the MDP
    Rewards = opts.Rewards; %rewards - these are set by hand (not learnt)
    smat = opts.smat;
    amat = opts.amat;
    
    %options for value iteration
    MAX_N_ITERS = opts.MAX_N_ITERS; CONV_TOL = opts.CONV_TOL; iterCnt = opts.iterCnt; delta = opts.delta;
    
    %% loop over simulations %%
    for sims = 1:nsims

        %print which simulation code is at
        disp(['Simulation ', num2str(sims)]);

        %% loop over agents %%
        for agent = 1:nagents
            
            %initalise/wipe this at the start of each new agent simulation
            results = [];
            
            %print which animal in the simulation code is at
            disp(['Agent ', num2str(agent)]);

            [X, phase, exp_phase, n_trials_training, n_trials_deval, n_trials_lever, n_trials_cons, results] = LCM_modelinput(training_length, deval_ctxt, paired);

            [T, D] = size(X);

            ntrials = T; % nrows in X
            
            results.opts = opts; %store these parameters again
            results.simulation_n = sims;
            results.agent_n = agent;

            %generate inverse temp for this run 
            beta  = beta_sd.*randn(1,1) + beta_mean;
            results.beta = beta;

            %initalise counts
            [Nk, Nstart, Na1, Na2, Na3, Na4, Na5, N, B] = counts_initalise(M, K, D, n_states);

            results.c_assign(1:ntrials, 1:K, 1:3) = NaN;
            
            %% loop over trials %%
            for t = 1:ntrials

                tran_counter = 1;
                log_counter = 1;
                
                %start state
                [s1, tran_binary, a1, a2, s1log, s2log, alog] = start_states(exp_phase(t));
        
                results.startstate(t) = s1;
            
                %calculate likelihood of start state and features
                %features
                lik = N;
                lik(:, :, X(t, :)==0) = B(:, :, X(t, :)==0);
                lik = bsxfun(@rdivide, lik+a, Nk+a+b);

                %start state
                lik_start = bsxfun(@rdivide, Nstart(:, :, s1), sum(Nstart, 3));

                %multiply together
                lik_start = lik_start.*squeeze(prod(lik(:, :, :), 3));

                %calculate CRP prior
                prior = Nk;

                for m = 1:M
                    prior(m, find(prior(m, :)==0, 1)) = alpha; %probability of a new latent cause (set to alpha)
                end
                
                prior = bsxfun(@rdivide, prior, sum(prior, 2));

                post_store = prior.*lik_start;

                %posterior conditional based on prior, start state and features
                [results.c_assign(t, 1:K, tran_counter), posts1b] = post_calc(post_store);
                
                tran_counter = tran_counter + 1;

                %while loop whilst in non terminal state
                while tran_binary(s1)>0

                        %SAS prediction for each action
                        [lik_sprime, preds] = SAS_prediction(Na1, Na2, Na3, Na4, Na5, n_states, n_actions, M, K, posts1b);

                        %value iteration
                        [V] = valueit(Rewards, delta, CONV_TOL, iterCnt, MAX_N_ITERS, preds);

                        if (s1==4)

                            action=1;

                        else

                            Va1 = sum(preds(amat(s1, 1), :).*V); %value of action1 from s1
                            Va2 = sum(preds(amat(s1, 2), :).*V); %value of action2 from s1

                            %probability of each action
                            [prob] = softmax_func([Va1, Va2], beta);

                            %determine choice in softmax
                            action = abs((prob(1) > rand()) - 2);

                        end

                        %state transitioned to
                        s2 = smat(s1, action, exp_phase(t));

                        %log actions, start and end states
                        alog(log_counter) = action;
                        s1log(log_counter) = s1;
                        s2log(log_counter) = s2;

                        %posterior
                        post_store = post_store.*lik_sprime(:, :, amat(s1, action), s2);
                        [results.c_assign(t, 1:K, tran_counter), posts1b] = post_calc(post_store);

                        s1 = s2;  

                        tran_counter = tran_counter + 1;
                        log_counter = log_counter + 1;

                end

                results.c_assign_prepartfilter(t, 1:K) = results.c_assign(t, 1:K, tran_counter-1);
                
                %particle filter (don't run for test as no transitions)
                x1 = X(t, :)==1; x0 = X(t, :)==0;
                [Nk, Nstart, Na1, Na2, Na3, Na4, Na5, N, B] = particle_filter(x1, x0, Nk, Nstart, Na1, Na2, Na3, Na4, Na5, N, B, M, posts1b, s1log, alog, smat(:, :, exp_phase(t)), amat);
    
                %store this 
                results.actions(t, s1log) = alog;
                results.startstates(t, 1:length(s1log)) = s1log;
                results.endstates(t, 1:length(s2log)) = s2log';
                results.rewards(t, 1) = Rewards(s2);

                end %end of trial loop

            %compile results from this run
            results_comp(sims, agent) = results;

            end %end of agent loop
        
        end %end of sim loop

end %function end