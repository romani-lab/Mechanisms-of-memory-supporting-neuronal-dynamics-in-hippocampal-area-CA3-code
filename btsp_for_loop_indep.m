function w = btsp_for_loop_indep(w,pl,pa,n,p)
%This function computes the weights for a btsp learning rule with independent pre- and post-synaptic patterns. 
%Each pre- and postsynaptic neuron is paired by its index, and uncorrelated
%with all others.

%w (weights) should be nx1
%pa is presynaptic signal should be nx(p+1) ("pa" = "plateaus or activity")
%pl is postsynaptic signal should be nx(p+1) ("pl" = "plateaus")
%n number of neurons
%p is the number of patterns
%p is used instead of p+1 because btsp uses two time-bins at each update
%step
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
                %for j = 1:n
                %j=i;
                    pa0 = pa(i,t);
                    pa1 = pa(i,t-1);
                    if (pa0 || pa1)
                        w0 = w(i);
                        if ((pl0 && pa0) && (~w0))
                            w(i) = true;
                        end
                        if (((pl1 && pa0) || (pl0 && pa1)) && w0)
                            w(i) = false;
                        end
                    end
                %end
            end
        end
    end
end