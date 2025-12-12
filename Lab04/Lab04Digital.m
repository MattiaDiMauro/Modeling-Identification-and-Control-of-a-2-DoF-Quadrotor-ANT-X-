% Lab 04 Digital
clear
close all
clc

%% Position controller inner loop
s = tf('s');
G_v = 2.4/(1.5385*s+1);
%controlSystemDesigner(G_v)
Kp_i=1.46*1.5;
Ki_i=(1/1.5)*Kp_i;
R_i_pos=Kp_i*(s+1/1.5385)/s;

%% Velocity test1
omega_c_o=0.7;
K_pos_out=omega_c_o;

load("log_1_2024-5-22-17-21-22_2dd.mat");

figure;
plot(v.timestamp,v.value);
hold on;
plot(v0.timestamp,v0.value);
legend("Setpoint", "Actual velocity")
xlim([150 160])
grid on;

%% Velocity test2
omega_c_o=0.7;
K_pos_out=omega_c_o;

load("log_3_2024-5-22-17-24-38_2dd.mat");

figure;
plot(v.timestamp,v.value);
hold on;
plot(v0.timestamp,v0.value);
legend("Setpoint", "Actual velocity")
xlim([35 45])
grid on;

figure;
plot(theta.timestamp,theta.value);
hold on;
plot(theta0.timestamp,theta0.value);
legend("Setpoint", "Actual pitch rate")
xlim([35 45])
grid on;


%% Position test
omega_c_o=0.7;
K_pos_out=omega_c_o;

load("log_7_2024-5-22-17-29-46_2dd.mat");

figure;
plot(x.timestamp,x.value);
hold on;
plot(x0.timestamp,x0.value);
legend("Setpoint", "Actual position")
xlim([30 70])
grid on;

figure;
plot(v.timestamp,v.value);
hold on;
plot(v0.timestamp,v0.value);
legend("Setpoint", "Actual velocity")
xlim([30 70])
grid on;

figure;
plot(theta.timestamp,theta.value);
hold on;
plot(theta0.timestamp,theta0.value);
legend("Setpoint", "Actual pitch rate")
xlim([30 70])
grid on;
