function w = hebb_for_loop(w,pl,pa,n,p,ftot)
%This function computes the weights for a hebbian learning rule as
%described in (Amit & Fusi 94)

%w (weights) should be nxn
%pa is presynaptic signal should be nx(p+1) ("pa" = "plateaus or activity")
%pl is postsynaptic signal should be nx(p+1) ("pl" = "plateaus")
%n number of neurons
%p is the number of patterns
%ftot is the 'total effective sparsity', e.g. if plateaus and activity are
%present, ftot=fp+fa-fp*fa, and is equal to the depotentiation probability
%for maximizing the capacity of this network

%Random number generation for stochastic depotentiation is a bottleneck for 
%runtime, making it significantly slower than BTSP, and an opportunity for 
%runtime improvements in addition to bitshift operations and/or sparse matrix usage.
%Memorylessness of the Markov process could also allow the plasticity calculation to start
%at the the last time potentiation occurs.
    w0 = false;
    pl0 = false;
    pa0 = false;
    for t = 2:(p+1)
        for j = 1:n
            pa0 = pa(j,t);
            if (pa0)
                for i = 1:n
                    pl0 = pl(i,t);
                    w0 = w(i,j);
                    w1=w(j,i);
                    if (pl0)
                        w(i,j) = true;
                    else
                        if (w0 && (rand(1)<ftot))
                            w(i,j) = false;
                        end
                        if (w1 && (rand(1)<ftot))
                            w(j,i) = false;
                        end
                    end
                end
            end
        end
    end
end