%This program uses rank-sum to to calculate the probability of a Type II
%error at different damage levels. We will then set an acceptable beta
%level and determine what minimum level of damage must occur for the damage
%to be identified
clear all; close all; clc
[parentdir,name,ext] = fileparts(pwd);
filepath = [parentdir,filesep 'SignatureFile' filesep 'signature_temp.csv'];
basefile = [parentdir,filesep 'SignatureFile' filesep 'signature.csv'];
load(filepath)
load(basefile);
%load
GDFS_EVENT = signature_temp;
GDFS = signature;

%Number of trucks in baseline
num_base=length(GDFS);

%Number of trucks in damage sample
num_dam=round(length(GDFS)/7);

%Number of simulation
num_sim=1;

%Significance level for rank-sum test (2-sided Wilcoxen) --> TYPE I Error
ALPHA=0.05;

%% ----------------------END USER INPUT------------------------------------
%Initialize matrices
DI_sim = zeros(num_sim,1);
replacement=false;

%% For each simulation, draw random sample of (num_base) for baseline.

pval=zeros(num_sim,6,1);
hval=zeros(num_sim,6,1);
for sim=1:num_sim
    
    % Draw random event from all events
    
    rando_nums=randsample(1:length(GDFS),num_base);
    rando_base = 1:num_base;
    
    for f=1:num_base
        GDFS_BASE(f,:)=GDFS(rando_base(f),1:6);
    end
    
    %Damage - Draw random sample from GDFS
    dam_ind=length(GDFS_EVENT):-1:length(GDFS_EVENT)-num_dam+1;
    
    for a=1:num_dam
       GDFS_DAM(a,:) = GDFS_EVENT(dam_ind(a),:);
    end
    
    %% Run simulation for (num_sim) rank-sum tests
    for h=1:6
        [pval(sim,h),hval(sim,h)]=ranksum(GDFS_BASE(:,h),GDFS_DAM(:,h),'alpha',ALPHA);
    end
    DI_sim(sim) = sum(hval(sim,:))/6;
end
DI = mean(DI_sim);

%% save DI value
csvwrite([parentdir,filesep 'DIvalues' filesep 'DI.csv'],DI);









