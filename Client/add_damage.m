% this program will add damage to the eventss
% damage 0 --- No damage
% damage 1 --- interior girder fracture
% damage 2 --- fascia girder correosion
% damage 3 --- diaphragm fractures
% damage 4 --- deck delamination
clear;close;clc


%Define change (+/-) in GDF (1-6) due to damage. 
damage0=[0 0 0 0 0 0];
% damage1=[   -0.0929    0.0548    0.0236    0.0111    0.0035         0]; %G1
damage1=[0.060446373	-0.154520485	0.064442259	0.020966131	0.008665722	3.87542E-13];%G2
damage2=[   -0.0325    0.0273    0.0068         0   -0.0016         0];
damage3=[-0.0104	0.0112	0.0081	-0.0055	-0.0034	0.0000];
damage4=[-0.0099    0.0098    0.0084   -0.0029   -0.0053     0];


% import orignal file
Original = load('Event_original.csv');

% choose damage
damage = damage4;
Event = zeros(size(Original));

for i= 1:size(Original,1)
    Event(i,:) = Original(i,:) + damage;
end

csvwrite('Event_yellow.csv',Event);

