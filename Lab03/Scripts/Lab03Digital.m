% Lab 03 Digital

%% Initialise path

path.storage = genpath("..");
addpath(path.storage)

%% Load identified model data

load("identified_model_data.mat");
run1lab3=load("log_5_2024-5-22-17-26-58_2dd.mat");

%% L_theta and F_theta t.f.

wci=w_nPID/5;
mu_q=dcgain(F);
Kpo=wci/mu_q;

% L_theta
s = tf('s');
L_theta = (Kpo/s)*F;
figure
margin(L_theta)
L_int = (Kpo/s*mu_q);
figure
margin(L_int)
F_theta = feedback(L_theta,1);
step(F_theta)
stepinfo(F_theta)

%% Plot pitch data to identify approximate times of doublets

figure
plot(run1lab3.theta0.timestamp, run1lab3.theta0.value)
grid on
title("Run 1: Attitude setpoint data")

%% Simulation data
% N.B. PROBLEM WITH THIS SECTION!!!
% THE CODE DOESN'T RUN [sim1.theta.value, sim1.theta.timestamp] = lsim(F_theta,...

% Run 1
sim1.T_doublet=2;
sim1.A=deg2rad(-10);
sim1.N=1;
sim1.dt=1e-3;
% Identify Tinit
run1lab3.identDoublet = identifyDoublet(6, 14, run1lab3.theta0, sim1.A);

sim1.Tinit = round(run1lab3.identDoublet.time_commands(1), 3);
F_theta = feedback(L_theta,1);

%% Simulations

% Generate doublets
T_pause=2;
sim1.theta0 = generateDoubletTrain(sim1.T_doublet, T_pause , sim1.Tinit, sim1.Tend, ...
    sim1.A, sim1.N, sim1.dt);

% Simulate
[sim1.theta.value, sim1.theta.timestamp] = ...
    lsim(F_theta, sim1.theta0.value, sim1.theta0.timestamp);

%% Simulations plots

figure
plot(sim1.theta0.timestamp, sim1.theta0.value, sim1.theta.timestamp, sim1.theta.value)
title("Sim 1")
legend("Setpoint", "Pitch rate")
grid on

%% Compare to real data

% Identify Tinit
run1lab3.identDoublet = identifyDoublet(6, 14, run1lab3.theta0, sim1.A);


sim1.Tinit = round(run1lab3.identDoublet.time_commands(1), 3);


figure
plot(sim1.theta0.timestamp, sim1.theta0.value, sim1.theta.timestamp, sim1.theta.value, ...
    run1lab3.theta.timestamp, run1lab3.theta.value)
title("Comparison 1")
legend("Setpoint", "Simulated pitch rate", "Actual pitch rate")
xlim([550, 580])
grid on