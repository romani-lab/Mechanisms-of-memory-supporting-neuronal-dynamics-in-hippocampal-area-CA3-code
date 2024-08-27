# BTSP-CA3-modeling
Code related to the modeling component of the publication, "Mechanisms of memory-supporting neuronal dynamics in hippocampal area CA3"

This repository uses Git LFS to manage the .mat files containing simulations of large networks. Please install Git LFS (https://git-lfs.com) before attempting to clone the repository. If issues exist with the .mat files, we recommend cloning the repository directly from the website (https://github.com/romani-lab/BTSP-CA3-modeling/) after installing git-lfs. 

Short version, reproducing paper Figures:

Figure || script to run

    6E || Fig6E.m
    6F || makeScalingFig.m
    7A || PlotConfusionLinePlot.m
    7B || corr_capacity_btsp_hebb_plot.m
    S10DE || FigSF10DE.m
    S10FG || PlotSNR_data_theory.m
    S10HI || PlotConfmHeatmap.m
    S10JK || test_pwdt.m 


Oragnization:
The code is primarily organized into 5 different levels of analysis.
1) Theoretical calculations. These are found in the 'Calculations' subfolder. These are scripts in Mathematica that analyze the stochastic matrices describing synaptic systems with recurrent dynamics.
2) Weight calculations. These take in a sequence of patterns for a population of neurons and give the resulting weight matrix.
3) Attractor analyses. These take as inputs parameters like population size, sparsity fraction, temporal autocorrelation, etc and compute i) the patterns according to the relevant model (see Model terminology below), ii)  the resulting weight matrix, iii) the attractor parameters (e.g. threshold), iv) resulting attractor states when the system is initialized to the patterns.
4) Bootstrap analyses. These run the attractor analyses many times to measure i) signal to noise ratio, ii) decoding accuracy, iii) attractor capacity, iv) attractor pattern confusion.
5) Meta analyses. These compare outputs of lower-level analyses across various parameter sweeps (e.g. across population size, between different model types, etc.)
6) Miscellaneous scripts and helper functions for plotting analysis results.


 Model Terminology:
 These are to help understand the meaning of various commonly used title/variable names in the code.
 
 BTSP - Any of several models with plasticity described by W(t+1)=W(t)+(1-W(t))q_pre(t)*q_post(t) - W(t)(q_pre(t-1)q_post(t) OR q_pre(t)q_post(t-1)) .
 
 Hebbian rule - A traditional Hebbian-like learning rule using a model described in (Amit & Fusi 94) with weight update: W(t+1)=W(t)+(1-W(t))q_pre(t)*q_post(t)-W(t)*q_dep(t)(q_pre(t))(1-q_post(t) OR (1-q_pre(t))q_post(t))
 
 T-corr - (temporal correlations) describes temporally correlated spiking activity in the recurrent network
 
 Independent - models that remove correlations between weights. This is done by producing N pairs of pre- and post-synaptic signals (and so N total weights) instead of a set of N pre- and N post-synaptic signals that have synaptic weights calculated between each (N^2 total). Used to test the theoretical calculations that ignore the effect of correlations between weights.


More detailed discussion of scripts:

1) Theoretical calculations ('Calculations' subfolder):
   -BTSPCalc.nb
   -BTSPCalcTcorr.nb
   -HebbCalcTcorr.nb
2) Weight calculations. These are some of the largest bottlenecks for the simulation runtime due to approximate N^4 scaling (N^2 weights and memory lifetime that scales ~N^2, requiring N^2 patterns to test). We didn't attempt much optimization.
   - btsp_for_loop.m
   - btsp_for_loop_indep.m
   - hebb_for_loop.m
3) Attractor network analyses. An important note about how the attractor states are calculated: 10 timesteps are used with all neurons updating on each timestep. We tested on moderately sized networks that this provided virtually no difference in the resulting states (compared to updating a single neuron at a time) before allowing this simulation technique to be used to scale to larger networks.
   - computeBTSP_indep.m
   - computeBTSPAttractorTcorrSparse.m
   - computeBTSPTcorr_indep.m
   - computeHebbAttractorTcorrSparse.m
4) Bootstrap analyses. These functions return a large number of variables, including two measures of capacity based on i) probability of successful decoding from the attractor ('capacity') and ii) snr crossing a threshold ('cap'), as well as the probability of successful decoding and SNR as functions of time since the last pattern. Additionally, a confusion matrix and the probability matrix of the weight being potentiated conditioned on the time since the presynaptic signal and postsynaptic signal presentation. These are, in relevant cases, returned for all three conditions, presynaptic input including: plateaus and activity ('both' or 'b') or plateaus only ('pl' or 'p'). Note that the reported values in the plots are not taken directly from the values returned by these functions, but by more in-depth analyses on the decoding probability and snr (see calc_SNRthresh.m, corr_capacity_btsp_hebb_plot.m)
   - bootstrapBTSP_indep.m
   - bootstrapBTSPAttractorTcorr.m
   - bootstrapBTSPAttractorTcorr_large.m
   - bootstrapBTSPTcorr_indep.m
   - bootstrapHebbAttractorTcorr.m
5) Meta analyses. These functions were designed to run on a cluster (or locally) and save their output to a folder ('./clusterout/'), allowing simulations to be run and analyzed separately.
   - n_scaling_btsp_cl.m              % look at a bunch of small-scale simulations of varying network size
   - n_scaling_btsp_large_cl.m        % do singular larger simulations
   - corr_capacity_btsp_hebb_cl.m     % look at a many of analyses comparing btsp to Hebb for a variety of values of activity correlation
6) Miscellaneous
   - corr_capacity_btsp_hebb_plot.m   % Plot attractor capacity vs c, as in F7B
   - Fig6E.m                          % Plot F6E
   - FigSF10DE.m                      % Plot SF10DE
   - makeScalingFig.m                 % Plot F6F
   - markovchain_sparse.m             % makes activity patterns with a prescribed sparsity and temporal autocorrelation (for Tcorr analyses)
   - PlotConfmHeatmap.m               % Plots confusion matrices of attractor states and probability of W=1 for different temporal correlations and between the BTSP/Hebb models (SFig10HI)
   - PlotConfusionLinePlot.m          % Plots entries in the confusion matrix to show the relative likelihood of W=1 in adjacent patterns (Fig 7A)
   - PlotSNR_data_theory.m            % Plots the theoretical predictions from the Calculations section for SNR vs those measured in simulations (SFig10FG)
   - test_pwdt.m                      % Plots the probability of W=1, also comparing theory to simulations (SFig10JK)
   - clusterout/makeCompiledNScaling.m  % Combines a group of medium-sized analyses with some larger analyses run on the cluster in preparation for a plotting analyses
   - calc_snrThresh.m                 % Helper function to calculate in a more detailed way a threshold based on the SNR analysis
