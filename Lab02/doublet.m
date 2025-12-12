clear
close all
clc

%% Load data

load ..\Dati\log_4_2024-5-22-17-28-02_2dd.mat

%% Plot M

% figure
% plot(q0.timestamp, q0.value)

%% Generate doublet

% Doublet parameters
T_doublet = 1; % [s]
A = deg2rad(+35); % [rad/s]
N = 3;
dt = 1e-3;
Tinit = 0.2;
Tend = 0.2;

s = generateDoubletTrain(T_doublet, A, N, dt, Tinit, Tend);

figure
plot(s.timestamp, s.value)
grid on

