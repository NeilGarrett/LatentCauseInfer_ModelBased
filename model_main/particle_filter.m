function [Nk, Nstart, Na1, Na2, Na3, Na4, Na5, N, B] = particle_filter(x1, x0, Nk, Nstart, Na1, Na2, Na3, Na4, Na5, N, B, M, post_final, s1log, alog, smat, amat)

        %particle filter
        NkOld = Nk;
        NstartOld = Nstart;
        
        Na1Old = Na1;
        Na2Old = Na2;
        Na3Old = Na3;
        Na4Old = Na4;
        Na5Old = Na5;

        NOld = N;
        BOld = B;

        actions_coded = [];

        for j = 1:length(s1log)

            actions_coded = [actions_coded; amat(s1log(j), alog(j))];

        end
            %loop over particles
            for m = 1:M
                
                %sample particle row - assume you do this over all tallies?
                row = min(find(rand() < cumsum(sum(post_final, 2))));
                                
                Nk(m, :) = NkOld(row, :);
                Nstart(m, :, :) = NstartOld(row, :, :);
                
                Na1(m, :, :, :) = Na1Old(row, :, :, :);
                Na2(m, :, :, :) = Na2Old(row, :, :, :);
                Na3(m, :, :, :) = Na3Old(row, :, :, :);
                Na4(m, :, :, :) = Na4Old(row, :, :, :);
                Na5(m, :, :, :) = Na5Old(row, :, :, :);
               
                N(m, :, :) = NOld(row, :, :);
                B(m, :, :) = BOld(row, :, :);
                
                %sample cause (column) and increment count for this cause
                %for this particle
                col = min(find(rand() < cumsum(post_final(row, :)/sum(post_final(row, :)))));
                
                Nk(m, col) = Nk(m, col) + 1;
                Nstart(m, col, s1log(1)) = Nstart(m, col, s1log(1)) + 1;
                
                N(m, col, x1) = N(m, col, x1) + 1;
                B(m, col, x0) = B(m, col, x0) + 1;
                
                %only increment tallies for SAS combinations you actually observed
                for i = 1:length(actions_coded)
                    
                    if(actions_coded(i)==1)
                        
                        Na1(m, col, s1log(i), smat(s1log(i), alog(i))) = Na1(m, col, s1log(i), smat(s1log(i), alog(i))) + 1;
                        
                    elseif(actions_coded(i)==2)
                        
                        Na2(m, col, s1log(i), smat(s1log(i), alog(i))) = Na2(m, col, s1log(i), smat(s1log(i), alog(i))) + 1;

                    elseif(actions_coded(i)==3)
                       
                        Na3(m, col, s1log(i), smat(s1log(i), alog(i))) = Na3(m, col, s1log(i), smat(s1log(i), alog(i))) + 1;

                    elseif(actions_coded(i)==4)
                        
                        Na4(m, col, s1log(i), smat(s1log(i), alog(i))) = Na4(m, col, s1log(i), smat(s1log(i), alog(i))) + 1;
                       
                    elseif(actions_coded(i)==5)
                        
                        Na5(m, col, s1log(i), smat(s1log(i), alog(i))) = Na5(m, col, s1log(i), smat(s1log(i), alog(i))) + 1;

                    end         
                    
                end
                
            end

end
