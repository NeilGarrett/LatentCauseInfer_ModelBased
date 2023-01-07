function [s1, tran_binary, a1, a2, s1log, s2log, alog] = start_states(exp_phase)

s1 = NaN;
a1 = NaN;
a2 = NaN;

s1log = [];
s2log = [];
alog = [];

tran_binary = [1, 1, 0, 1, 0, 0];
                        
    %if in acquisition of lever test phase start in s1
    if ((exp_phase==1) || (exp_phase==4))
                
        s1 = 1;
        n_trans = 2;
    %if in devaluation (injection) or consumption test phase, start in s2
    elseif ((exp_phase==2) || (exp_phase==5))

        s1 = 2;
        n_trans = 1;

    %if in devaluation (context exposure) start in s4
    elseif (exp_phase==3)

        s1 = 4; 
        n_trans = 1;

    end

end