% Lab 02 Digital

clear
close all
clc

%% Initialise path

% Add used paths to MATLAB search path
path.storage = genpath("..");
addpath(path.storage)

%% Load identified model data

par = load("identified_model_data.mat");
run1 = load("log_4_2024-5-22-17-25-08_2dd.mat");

%% Plot pitch data to identify approximate times of doublets

figure
plot(run1.q0.timestamp, run1.q0.value)
grid on
title("Run 1: pitch rate setpoint data")


%% G (t.f)

G = tf([par.mu 0], ...
    [1 2*par.xi*par.omega_n par.omega_n^2], 'InputDelay', par.tau);

%% Open Control System Designer to choose the regulator
%controlSystemDesigner(G)

%% Regulator data

% mu-tau formulation
gain=0.35;
pole1=0.01;
%pole2=integrator
zero1=0.026;
zero2=0.17;

% PID formulation
ki=gain
kp=(zero1+zero2)*ki-ki*pole1
kd=(zero1*zero2)*ki-kp*pole1
w_nPID=29.2

%% Simulation data

% Run 1
sim1.T_doublet=1.5;
sim1.A=deg2rad(+30);
sim1.N=3;
sim1.dt=1e-1;
sim1.Tinit=0.2;
sim1.Tend=0.2;

%% Loading of G data

% G with ZOH
G_ZOH = G;
G_ZOH.InputDelay = par.tau + par.ts/2;

% R
s = tf('s');
R = gain * (1 + zero1*s) * (1 + zero2*s) / (s * (1 + pole1*s));

% F (closed loop)
F = feedback(R*G_ZOH, 1);

%% Simulations

% Generate doublets
T_pause=0;
sim1.q0 = generateDoubletTrain(sim1.T_doublet, T_pause , sim1.Tinit, sim1.Tend, ...
    sim1.A, sim1.N, sim1.dt);
% Simulate
[sim1.q.value, sim1.q.timestamp] = ...
    lsim(F, sim1.q0.value, sim1.q0.timestamp);

%% Simulations plots

figure
plot(sim1.q0.timestamp, sim1.q0.value, sim1.q.timestamp, sim1.q.value)
grid on
title("Sim 1")
legend("Setpoint", "Pitch rate")

%% Compare to real data

% Identify Tinit
run1.identDoublet = identifyDoublet(345, 356, run1.q0, sim1.A);

sim1.Tinit = round(run1.identDoublet.time_commands(1), 3);

% Change dt to get more accurate results
sim1.dt = 1e-3;

% Generate doublets
sim1.q0 = generateDoubletTrain(sim1.T_doublet, T_pause , sim1.Tinit, sim1.Tend, ...
    sim1.A, sim1.N, sim1.dt);

% Simulate
[sim1.q.value, sim1.q.timestamp] = ...
    lsim(F, sim1.q0.value, sim1.q0.timestamp);

% Plots
figure
plot(sim1.q0.timestamp, sim1.q0.value, sim1.q.timestamp, sim1.q.value, ...
    run1.q.timestamp, run1.q.value)
title("Comparison 1")
legend("Setpoint", "Simulated pitch rate", "Actual pitch rate")
xlim([345, 355])
grid on


%% Cleaning

rmpath(path.storage)