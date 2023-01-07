function [Nk, Nstart, Na1, Na2, Na3, Na4, Na5, N, B] = counts_initalise(M, K, D, n_states)

        N = zeros(M, K, D); % feature-cause co-occurence counts
        B = zeros(M, K, D); % feature-cause co-occurence counts    

        %initalise counts: particle, cause, start state
        Nstart = ones(M, K, n_states); %start state counts

        %set these up as: particle, cause, s, s'
        Na1 = ones(M, K, n_states, n_states); %transitions counts (s1a1=>s2)
        Na2 = ones(M, K, n_states, n_states); %transitions counts (s1a2=>s3)

        Na3 = ones(M, K, n_states, n_states); %transitions counts (s2a1)
        Na4 = ones(M, K, n_states, n_states); %transitions counts (s2a2)

        Na5 = ones(M, K, n_states, n_states); %transitions counts (s4a1)

        Nk = zeros(M, K); %cause counts