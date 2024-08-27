function [A] = markovchain_sparse(n,p,f,c)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
one_to_zero = (1-c)*(1-f); %(1-f) for uncorrelated patterns
zero_to_one = (1-c)*f;
%T = [1-zero_to_one, zero_to_one; one_to_zero, 1-one_to_zero];

a_s=(randperm(n,round(n*f)))'; %keep track of current active units
p_s=ones(size(a_s));
a_list=a_s;
p_list=p_s;
for i=2:p
    a_p=(randperm(n-length(a_s),binornd(n-length(a_s),zero_to_one,1))); %select random neurons to be made active
    %Note: the above line chooses the neuron to be active from the list
    %of neurons excluding currently active neurons

    a_m=randperm(length(a_s),binornd(length(a_s),one_to_zero,1)); %select random neurons to be made inactive
    
    %This bit of code finds the a_pth inactive neuron index given that we
    %are excluding the neurons indexed by a_s
    %e.g. if a_p=[1 2 3]', a_s=[1 2 5]', this code gives r = [3 4 6]'
    dr=ones(size(a_p'));
    r=a_p';
    while sum(dr>0)
        rt=r;
        r=a_p'+sum(a_s'<=r,2);
        dr=r-rt;
    end


    a_s(a_m)=[];
    a_s=[a_s; r];
    p_s=i*ones(size(a_s));
    a_list=[a_list; a_s];
    p_list=[p_list; p_s];
end
A=sparse(a_list,p_list,1,n,p);

end