clear; clc; close all

%% IMU data
% IMU reading and settings
run1_imu = cell2mat(struct2cell(load('recon_run1.mat')));
run2_imu = cell2mat(struct2cell(load('recon_run2.mat')));

% Sampling rate
typr = cell2mat(struct2cell(load('typr.mat')));
rate = mean(diff(typr(:,1)));

% Plot IMU data
t = 0:rate:rate * length(run1_imu);
t = linspace(0,100,length(run1_imu));
plot(t,run1_imu(:,1),t,run1_imu(:,2),t,run1_imu(:,3))
legend('Yaw','Pitch','Roll')
xlabel('t (s)')
ylabel('Degrees (\circ)')

%% Video data
% Load video
dir = '/Users/Shion/Dropbox/MQP-US Media/12-11 test w imu';  % Shion's directory
vid_name = 'recon_run2.mp4';

v = VideoReader(strcat(dir,'/',vid_name));
% noFrames = v.NumberOfFrames;    % number of frames
vDuration = v.Duration;

% Read frames
frames = {};
i = 1;
rect = [30, 87, 510, 250];

while hasFrame(v)
    frames{i} = imcrop(rgb2gray(readFrame(v)),rect);
%     imshow(frame, 'Parent', currAxes);
%     currAxes.Visible = 'off';
%     pause(0.01);
    i = i + 1;
end

%% Synchrnoize IMU and video



%% Orient frame in 3D
% Cropped frame size
[height,width] = size(frames{1});

% Initialize 3D matrix of zeros;
vol = zeros(height,width,width);

% Orient individual frames in 3D
for i = 1:length(frames)
    % Template
    temp = zeros(height,width,width);
    temp(:,:,round(width/2)) = temp(:,:,round(width/2)) + double(frames{i});
    
    % Orient frame
    
    
    % Add to global 
end

% Scatter in 3D
figure; hold on
[ii,jj] = find(frames{i});
scatter3(ii,jj,1)


