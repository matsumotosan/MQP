%% File to check working filtering

close all; clear all; clc;

%% Load relevant pose files
load('do_nothing.mat'); %newest no movement file
%load('square_test.mat'); %start and end points are same, square trial
%load('line_test.mat'); %line test
%load('new_signal.mat'); %no movement file
%load('disp_trial.mat'); %had weird data

%% Extract Acc, Gyr, Time
% Nested for double integration
acc = pose(2:end,5:7);      %extract acceleration data
ypr = pose(2:end,2:4)';     %extract gyro data
t = pose(2:end,1)/1000;     %extract time data & convert to ms

%% Calculate displacement (x,y,z)
postDisp = calcDisp(acc,t); %calculate pose data from calcDisp function

%% Plot original data
% Plot displacement in x,y,z
figure; hold on
subplot(3,1,1)  % acceleration plot
plot(t, acc(:,1), t, acc(:,2), t, acc(:,3)); grid on
title('Original Acceleration Plot')
xlabel('Time (s)')
ylabel('Acceleration (mm/s^2)');
legend('a_x','a_y','a_z');

subplot(3,1,2)  % displacement plot
plot(t, postDisp(1,:)', t, postDisp(2,:)', t, postDisp(3,:)'); grid on
title('Original Displacement Plot')
xlabel('Time (s)')
ylabel('Displacement (mm)');
legend('d_x','d_y','d_z');

subplot(3,1,3)  % angular displacement plot
plot(t, ypr(1,:), t, ypr(2,:), t, ypr(3,:)); grid on
title('Original Angular Displacement Plot')
xlabel('Time (s)');
ylabel('Angular Displacement (\circ)');
legend('Yaw', 'Pitch', 'Roll');

%% Calculate Sample Frequency
fs = 1 / mean(diff(t));             % sampling frequency

%% Median Filter
% med_fil = medfilt1(acc,5);        % median filt of acc data over 5 sample window
% acc_fil = lowpass(acc,1,fs);      % conventional low pass filter
% acc_fil = lowpassfilt(acc);       % low pass on median filtered data

%% Butterworth Band-Pass Filtering

%accel_zero = zeros(1,length(acc_fil)); %to compare correct '0' in plot

% order = 2;     %order of the filter
% fcutlow=1;     %low cut frequency in Hz
% fcuthigh=5;   %high cut frequency in Hz
% 
% [b,a]=butter(order,[fcutlow,fcuthigh]/(fs/2),'bandpass');
% acc_fil = filtfilt(b, a, acc);

%% Kalman Filter

% [kest,L,P] = kalman(sys,Qn,Rn,Nn)
% [kest,L,P] = kalman(sys,Qn,Rn,Nn,sensors,known)
% [kest,L,P,M,Z] = kalman(sys,Qn,Rn,...,type)

%% Plot filtered data
figure; hold on
subplot(3,1,1)
plot(t,acc_fil(:,1),'k',t,acc(:,1));
title('Filtered Acceleration (x)')
xlabel('Time (s)');
ylabel('Acceleration (mm/s^2)');
legend('filtered','original');

subplot(3,1,2)
plot(t,acc_fil(:,2),'k',t,acc(:,2));
title('Filtered Acceleration (y)')
xlabel('Time (s)');
ylabel('Acceleration (mm/s^2)');
legend('filtered','original');

subplot(3,1,3)
plot(t,acc_fil(:,3),'k',t,acc(:,3));
title('Filtered Acceleration (z)')
xlabel('Time (s)');
ylabel('Acceleration (mm/s^2)');
legend('filtered','original');
%% Calculate displacement with filtered linear acceleration

disp_fil = calcDisp(acc_fil,t);

% Plot displacement in x,y,z
figure; hold on
subplot(2,1,1)  % acceleration plot
plot(t, acc_fil(:,1), t, acc_fil(:,2), t, acc_fil(:,3)); grid on
title('Filtered Acceleration Plot')
xlabel('Time (s)')
ylabel('Acceleration (mm/s^2)');
legend('a_x','a_y','a_z');

subplot(2,1,2)  % displacement plot
plot(t, disp_fil(1,:)', t, disp_fil(2,:)', t, disp_fil(3,:)'); grid on
title('Filtered Displacement Plot')
xlabel('Time (s)')
ylabel('Displacement (mm)');
legend('d_x','d_y','d_z');
