%% Acquire IMU data and US images simultaneously
% This script contains two functions that were written in an attempt to
% acquire ultrasound images and IMU positioning data in parallel. These
% functions are called collect_imu and collect_us, respectively.

clear; close all; clc

%% Idea 1: Open another MATLAB instance
% % Evaluate terminal command through MATLAB
% mr = matlabroot;            % location of MATLAB in directory
% sr = which('gyroviz.m');    % path to gyroviz.m
% 
% % Windows - evaluate command in bash
% eval(strcat('!matlab -nodesktop -nosplash -r'," ", '"run(', "'", sr, "'",')"'))
% % eval('!matlab -nodesktop -nosplash -r "gyroviz.m" &')
% 
% % Allow communication between scripts (need TCP/UDP/IP Toolbox 2.0.6)
% 
% 
% % Wait for IMU to stabilize

%% Idea 2: Parallel MATLAB workers

% IMU info
baudrate = 115200;
port = 'COM5';   % Arduino UNO
%port = 'COM6';   % Arduino Nano
n = 1000;        % number of IMU measurements

% US info
noframes = 100;

%if pre-existing parpool, delete this instance
delete(gcp('nocreate'))

%create two parallel instances
parpool(2)

%frame name
fname = 'trial1' + '%d.mat';

% Collect IMU and US data in parallel
parfor idx = 1:2
    if idx == 1
        %IMU data acquisition
        imu_data = collect_imu(baudrate,port,n); %specify baudrate, port name, and set timer
    elseif idx == 2
        %ultrasound image acquisition
        us_data = collect_us(noframes); %specify number of frames & save frames
    end
    
    % Save variables
    parsave(sprintf(fname,idx),x,y);
end

parfor ii = 1:4
    x = rand(10,10);
    y = ones(1,3);
    parsave(sprintf('output%d.mat', ii), x, y);
end
