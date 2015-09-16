%Plot surfaces representing bridge signature envelope and damaged signature
%AJR 08-23-2013

clear all; close all; clc

% get file location
[parentdir,name,ext] = fileparts(pwd);
filepath = [parentdir,filesep 'SignatureFile' filesep 'signature_temp.csv'];
basefile = [parentdir,filesep 'SignatureFile' filesep 'signature.csv'];
load(basefile);
load(filepath);

GDFS = signature;
GDFS_EVENT = signature_temp;

%Define number of truck events to consider in baseline envelope
num_trucks_base=75;

%Define number of truck events to consider in check set
num_trucks_check=150;

%Define number of truck events to consider
num_trucks_all=length(GDFS);

%Define number of bootstrap curves
num_curves=1000;

%Confidence interval (percent) on each side
conf=2.5;

%Textplot
textplot=9;


%% -----------------END USER INPUT----------------------------------------

%Set number of trucks
if num_trucks_base>length(GDFS)
    num_trucks_base=length(GDFS);
end

replacement=true;

%Define bootstrap matrix. May be extra zeros if user input smaller # trucks
boot_mat=zeros(6*num_trucks_base,num_curves);
damage_mat0=zeros(num_trucks_check,6);

a=1;
dd=1;
ee=num_trucks_base;

%Take random sample. Keep row index consistent, ie girder 1 values
%are from same events as girder 2, etc
rando_nums = randi(length(GDFS),num_trucks_all,1);
sample_mat=zeros(num_trucks_all,6);
for aaa=1:num_trucks_all
    sample_mat(aaa,1:6)=GDFS(rando_nums(aaa),(1:6));
end

%To resample sample_mat data num_curves times, generate rand matrix
%size num_trucks x num_curves
rando_nums_boot=zeros(num_trucks_base,num_curves);
for j=1:num_curves
    rando_nums_boot(:,j) = randi(num_trucks_all,num_trucks_base,1);
end

%% Match each random number with corresponding GDF from sample
boot_mat1=zeros(num_trucks_base,num_curves);
boot_mat2=zeros(num_trucks_base,num_curves);
boot_mat3=zeros(num_trucks_base,num_curves);
boot_mat4=zeros(num_trucks_base,num_curves);
boot_mat5=zeros(num_trucks_base,num_curves);
boot_mat6=zeros(num_trucks_base,num_curves);
fff=1;

for ddd=1:num_curves
    for eee=1:num_trucks_base
        boot_mat1(eee,ddd)=sample_mat(rando_nums_boot(eee,ddd),1);
        boot_mat2(eee,ddd)=sample_mat(rando_nums_boot(eee,ddd),2);
        boot_mat3(eee,ddd)=sample_mat(rando_nums_boot(eee,ddd),3);
        boot_mat4(eee,ddd)=sample_mat(rando_nums_boot(eee,ddd),4);
        boot_mat5(eee,ddd)=sample_mat(rando_nums_boot(eee,ddd),5);
        boot_mat6(eee,ddd)=sample_mat(rando_nums_boot(eee,ddd),6);
    end
end

% Sort values in bootstrap matrices
boot_sort1=zeros(num_trucks_base,num_curves);
boot_sort2=zeros(num_trucks_base,num_curves);
boot_sort3=zeros(num_trucks_base,num_curves);
boot_sort4=zeros(num_trucks_base,num_curves);
boot_sort5=zeros(num_trucks_base,num_curves);
boot_sort6=zeros(num_trucks_base,num_curves);

for fff=1:num_curves
    boot_sort1(:,fff)=sort(boot_mat1(:,fff),'ascend');
    boot_sort2(:,fff)=sort(boot_mat2(:,fff),'ascend');
    boot_sort3(:,fff)=sort(boot_mat3(:,fff),'ascend');
    boot_sort4(:,fff)=sort(boot_mat4(:,fff),'ascend');
    boot_sort5(:,fff)=sort(boot_mat5(:,fff),'ascend');
    boot_sort6(:,fff)=sort(boot_mat6(:,fff),'ascend');
end

% Damage matrix
%Create random sample for damage signature. Sample with replacement*
dam_ind=length(GDFS_EVENT):-1:length(GDFS_EVENT)-num_trucks_check+1;


for cc=1:6
    for gg=1:num_trucks_check
        damage_mat0(gg,cc)=GDFS_EVENT(dam_ind(gg),cc);
    end
end

damage_mat0=sort(damage_mat0,'ascend');

%%
%Bootstrap confidence intervals
max_ind=num_curves-(num_curves*conf/100);
min_ind=(num_curves*conf/100)+1;
conf_max=zeros(num_trucks_base,6);
conf_min=zeros(num_trucks_base,6);

for ff=1:num_trucks_base
    %Find max and min value at each rank (each row)
    rank_sort1=sort(boot_sort1(ff,:),'ascend');
    rank_sort2=sort(boot_sort2(ff,:),'ascend');
    rank_sort3=sort(boot_sort3(ff,:),'ascend');
    rank_sort4=sort(boot_sort4(ff,:),'ascend');
    rank_sort5=sort(boot_sort5(ff,:),'ascend');
    rank_sort6=sort(boot_sort6(ff,:),'ascend');
    
    conf_max(ff,1)=(rank_sort1(1,max_ind));
    conf_max(ff,2)=(rank_sort2(1,max_ind));
    conf_max(ff,3)=(rank_sort3(1,max_ind));
    conf_max(ff,4)=(rank_sort4(1,max_ind));
    conf_max(ff,5)=(rank_sort5(1,max_ind));
    conf_max(ff,6)=(rank_sort6(1,max_ind));
    
    conf_min(ff,1)=(rank_sort1(1,min_ind));
    conf_min(ff,2)=(rank_sort2(1,min_ind));
    conf_min(ff,3)=(rank_sort3(1,min_ind));
    conf_min(ff,4)=(rank_sort4(1,min_ind));
    conf_min(ff,5)=(rank_sort5(1,min_ind));
    conf_min(ff,6)=(rank_sort6(1,min_ind));
end

conf_max=conf_max';
conf_min=conf_min';
damage_mat0=damage_mat0';


%% ---------Bridge signature Envelpe------------------

%Create rank vector (x-axis)for baseline signature
xx=1/(num_trucks_base+1);
rank_cdf=xx:xx:(1-xx);
rank_cdf=sort(rank_cdf,'descend');
%Create rank vector for damage signature
xx2=1/(num_trucks_check+1);
rank_cdf2=xx2:xx2:(1-xx2);
rank_cdf2=sort(rank_cdf2,'descend');

for girder_pick=1:6
    max_sort=sort(conf_max(girder_pick,:),'ascend');
    min_sort=sort(conf_min(girder_pick,:),'ascend');
    
    figure
    p1=plot(rank_cdf,max_sort);
    hold on;
    p2=plot(rank_cdf,min_sort);
    
   % ylim([min(min_sort)/2 max(max_sort)*2]);
    p3=plot(rank_cdf2,damage_mat0(girder_pick,:),'r');
    set(p1,'LineWidth',2,'color','g')
    set(p2,'LineWidth',2,'color','g')
    set(p3,'LineWidth',2,'color','r');
    tit=['Girder ', num2str(girder_pick) ' Signature Envelope'];
    title(tit)
    ylabel('GDF');
    xlabel('Probability of Exceedance')
    set (gcf,'Color',[1 1 1])
    legend([p1,p3],'Baseline Envelope','Recent Events');
    export_fig(gcf,[parentdir,filesep 'website' filesep 'signature' filesep tit '.png'],'-nocrop','-painters');
    %close;
end

%% ---------Bridge signature surface plots------------------

%PLOT 0 - Undamaged
figure
SURF_PLOTTER('Bridge Signature',rank_cdf,rank_cdf2,damage_mat0,conf_max,conf_min,textplot)
%Plot 3D plane to close front
FILLER(rank_cdf(1),conf_min(:,1),conf_max(:,1));
tx = text(3.5,12,strcat('Number of Trucks = ',num2str(num_trucks_base)));
set(tx,'fontweight','bold');
set (gcf,'Color',[1 1 1])
export_fig(gcf,[parentdir,filesep 'website' filesep 'signature' filesep 'BridgeSignature.png'],'-nocrop','-painters');
%close;





