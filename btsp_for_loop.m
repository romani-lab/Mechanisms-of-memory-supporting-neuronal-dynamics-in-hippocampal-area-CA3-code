function w = btsp_for_loop(w,pl,pa,n,p)
%This function computes the weights for a btsp learning rule
%w (weights) should be nxn
%pa is presynaptic signal should be nx(p+1) ("pa" = "plateaus or activity")
%pl is postsynaptic signal should be nx(p+1) ("pl" = "plateaus")
%n number of neurons
%p is the number of patterns
%p is used instead of p+1 because btsp uses two time-bins at each update
%step
%We didn't attempt much optimization, and suspect that with bitshifts operations 
% or sparse matrix usage, runtime can be cut down significantly. 

    w0 = false;
    pl0 = false;
    pl1 = false;
    pa0 = false;
    pa1 = false;
    for t = 2:(p+1)
        for i = 1:n
            pl0 = pl(i,t);
            pl1 = pl(i,t-1);
            if (pl0 || pl1)
                for j = 1:n
                    pa0 = pa(j,t);
                    pa1 = pa(j,t-1);
                    if (pa0 || pa1)
                        w0 = w(i,j);
                        if ((pl0 && pa0) && (~w0))
                            w(i,j) = true;
                        end
                        if (((pl1 && pa0) || (pl0 && pa1)) && w0)
                            w(i,j) = false;
                        end
                    end
                end
            end
        end
    end
end