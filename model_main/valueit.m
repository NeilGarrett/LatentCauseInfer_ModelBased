function [V] = valueit(Rewards, delta, CONV_TOL, iterCnt, MAX_N_ITERS, pred)

                %value iteration
                V = Rewards;

                while((delta > CONV_TOL) && (iterCnt <= MAX_N_ITERS))

                    delta = 0; 
                    Vold = V;

                    V(1) = max(sum(pred(1, :).*Vold), sum(pred(2, :).*Vold));
                    delta = max([delta, abs(Vold(1) - V(1))]); 

                    V(2) = max(sum(pred(3, :).*Vold), sum(pred(4, :).*Vold));  
                    delta = max([delta, abs(Vold(2) - V(2))]); 
                    
                    V(4) = max(sum(pred(5, :).*Vold));  
                    delta = max([delta, abs(Vold(4) - V(4))]);

                    iterCnt = iterCnt + 1; 

                end
                
end
