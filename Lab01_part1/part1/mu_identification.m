%% Initialise path

% Add used paths to MATLAB search path
path.storage = genpath("..");
addpath(path.storage)

%% Load identified model data
%par = load("mu_identification.mat");
load("log_0_2024-5-22-17-21-28_2dd.mat");

%% Plot of measured M

figure
plot(M.timestamp, M.value)
title("Real moment data")
grid on

%% Extract doublet signal

% Start end end times of doublet
doublet.t_start= 26.9; % [s]
doublet.t_end = 28.4;   % [s]

% Logical indexing of times
temp.logIdx_doublet = M.timestamp > doublet.t_start & ...
    M.timestamp < doublet.t_end;

% Extract doublet signal
doublet.t_data = M.timestamp(temp.logIdx_doublet);
doublet.u_data = M.value(temp.logIdx_doublet);

%% Time of commands

% Doublet amplitude
doublet.amplitude = 0.02;

% Extrapolating time of commands
temp.diff_u = diff(doublet.u_data);
temp.logIdx_diff_u = abs(temp.diff_u) > (doublet.amplitude/2);
temp.idx_diff_u = find(temp.logIdx_diff_u);

% Time of commands
doublet.idx_commands = temp.idx_diff_u + 1;
doublet.time_commands = doublet.t_data(doublet.idx_commands);

%% Doublet data

% Doublet period
temp.diff_time_commands = diff(doublet.time_commands);
doublet.period = 0.3; % [s]

% Doublet Ti and Tf (see slides)
doublet.Ti = round(doublet.time_commands(1) - doublet.t_data(1), 2);
doublet.Tf = round(doublet.t_data(end) - doublet.time_commands(3), 2);

% Initial offset
doublet.offset = doublet.u_data(1);

%% Display

disp(doublet)

%% Generate doublet

% Generate time
Ts = 0.001; % [s],  sampling time
t_doublet = (doublet.t_start : Ts : doublet.t_end)';

% Generate doublet input
doublet.offset = 0;

temp.t1 = doublet.t_start + doublet.Ti;
temp.t2 = temp.t1 + doublet.period;
temp.t3 = temp.t2 + doublet.period;
temp.t4 = temp.t3 + doublet.Tf;
t_commands = [temp.t1 temp.t2 temp.t3 temp.t4]';
doublet_fun = @(t) doublet.offset * (t <= t_commands(1)) + ...
    (doublet.offset + doublet.amplitude) * ...
    (t > t_commands(1) & t <= t_commands(2)) + ...
    (doublet.offset - doublet.amplitude) * ...
    (t > t_commands(2) & t <= t_commands(3)) + ...
    doublet.offset * (t > t_commands(3));

u_doublet = doublet_fun(t_doublet);

% Plot doublet
figure
plot(t_doublet, u_doublet, doublet.t_data, doublet.u_data)
title("Generated doublet")
grid on

%% Generate system with unitary gaun

% G with unitary gain parameters 
omega_n = 2.9499; % [rad/s]
xi = 0.1817;      % [-]

% G with unitary gain
G_unitaryGain = tf([1 0], [1 2*xi*omega_n omega_n^2]);

%% Simulation

y_unitaryGain = lsim(G_unitaryGain, u_doublet, t_doublet);

% Plot y_unitaryGain
figure
plot(t_doublet, y_unitaryGain)
title("System transfer function G(s) with unitary gain and no delay")
grid on

%% Max y_unitaryGain

max_y_unitaryGain = 0.004479;
max_y_real = 1.81344;

mu = max_y_real / max_y_unitaryGain;

%% Plot finale

G_estimated_noDelay = mu * G_unitaryGain;
y_noDelay = lsim(G_estimated_noDelay, u_doublet, t_doublet);

figure
plot(t_doublet, y_noDelay, q.timestamp, q.value)
title("Simulated doublet response with no delay VS real time history")
grid on

%% Cleaning

clear temp
