function [dat_tab] = csv_compile(nsims, nagents, results_comp)
    
    dat_tab = [];

    for sim = 1:nsims

        for an = 1:nagents
            
            phase = results_comp(sim, an).phase;
            n_trials = length(results_comp(sim, an).phase);
            acquisition_duration = repmat({results_comp(sim, an).acquisition_duration}, n_trials, 1);
            devaluation_context = repmat({results_comp(sim, an).devaluation_context}, n_trials, 1);
            paired_unpaired = repmat({results_comp(sim, an).paired_unpaired}, n_trials, 1);
                       
            phase_coded = results_comp(sim, an).phase_coded;

            trialn = [1:n_trials]';

            beta = repmat(results_comp(sim, an).beta, length(phase_coded), 1);
            animal = repmat(an, length(phase_coded), 1);
            simulation = repmat(sim, length(phase_coded), 1);

            start_state = results_comp(sim, an).startstate';
            
            press_lever = NaN*ones(n_trials, 1);            
            press_lever(1:results_comp(sim, an).ntrials.training') = results_comp(sim, an).actions(1:results_comp(sim, an).ntrials.training', 1);
            press_lever(end-results_comp(sim, an).ntrials.constest) = results_comp(sim, an).actions(end-results_comp(sim, an).ntrials.constest, 1);
            press_lever = abs(press_lever - 2);

            consume_pellet = results_comp(sim, an).actions(:, 2);         
            consume_pellet(find(consume_pellet==0)) = NaN;
            consume_pellet = abs(consume_pellet - 2);

            post_final_c1 = results_comp(sim, an).c_assign_prepartfilter(:, 1);
            post_final_c2 = results_comp(sim, an).c_assign_prepartfilter(:, 2);
            post_final_c3 = results_comp(sim, an).c_assign_prepartfilter(:, 3);
            post_final_c4 = results_comp(sim, an).c_assign_prepartfilter(:, 4);
            post_final_c5 = results_comp(sim, an).c_assign_prepartfilter(:, 5);
            post_final_c6 = results_comp(sim, an).c_assign_prepartfilter(:, 6);
            post_final_c7 = results_comp(sim, an).c_assign_prepartfilter(:, 7);
            post_final_c8 = results_comp(sim, an).c_assign_prepartfilter(:, 8);
            post_final_c9 = results_comp(sim, an).c_assign_prepartfilter(:, 9);
            post_final_c10 = results_comp(sim, an).c_assign_prepartfilter(:, 10);

            dat_tab_tmp = table(animal, simulation, beta, trialn, phase, phase_coded, paired_unpaired, acquisition_duration, devaluation_context,...
                press_lever, consume_pellet,...
                post_final_c1, post_final_c2, post_final_c3, post_final_c4, post_final_c5,...
                post_final_c6, post_final_c7, post_final_c8, post_final_c9, post_final_c10);

            if ((an==1) & (sim==1))
                dat_tab = dat_tab_tmp;
            else
                dat_tab = [dat_tab; dat_tab_tmp];
            end
        
        end
   
    end
    
end

