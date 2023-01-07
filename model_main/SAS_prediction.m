function [lik_sprime, preds] = SAS_prediction(Na1, Na2, Na3, Na4, Na5, n_states, n_actions, M, K, postsb)

lik_sprime = [];
preds = [];

                %calculate probability of going to each state given action
                for j = 1:n_states

                    lik_sprime(:, :, 1, j) = bsxfun(@rdivide, Na1(:, :, 1, j), sum(Na1(:, :, 1, :), 4));

                    lik_sprime(:, :, 2, j) = bsxfun(@rdivide, Na2(:, :, 1, j), sum(Na2(:, :, 1, :), 4));

                    lik_sprime(:, :, 3, j) = bsxfun(@rdivide, Na3(:, :, 2, j), sum(Na3(:, :, 2, :), 4));

                    lik_sprime(:, :, 4, j) = bsxfun(@rdivide, Na4(:, :, 2, j), sum(Na4(:, :, 2, :), 4));

                    lik_sprime(:, :, 5, j) = bsxfun(@rdivide, Na5(:, :, 4, j), sum(Na5(:, :, 4, :), 4));
                    
                end

                %posterior predictive mean for SAS's from s1
                %marginalise over particles 
                %(can then use these estimates - along with reward - to predict choice / implement value iteration)

                for jj = 1:n_actions

                    for k = 1:n_states

                        %weighting between particles                        
                        preds(jj, k) = postsb(:)'*reshape(lik_sprime(:, :, jj, k), [M*K, 1]);

                    end

                end
                
end
        