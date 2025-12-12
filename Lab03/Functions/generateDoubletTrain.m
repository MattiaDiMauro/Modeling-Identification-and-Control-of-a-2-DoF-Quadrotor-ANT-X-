function s = generateDoubletTrain(T_doublet, T_pause, T_init, T_end, ...
    A, N, dt)

% GENERATEDOUBLETTRAIN Generate a time-stamped train of parameterized 
% doublets.
%   S = generateDoubletTrain(T_doublet, T_pause, T_init, T_end, A, N, dt)
%   returns a struct S with fields:
%     - S.timestamp : column vector of increasing time samples (s)
%     - S.value     : column vector of signal values at the corresponding 
%                     times
%
%   The function constructs N doublets. Each doublet consists of:
%     1) a positive pulse of amplitude A lasting T_doublet seconds,
%     2) a zero interval of length T_pause seconds,
%     3) a negative pulse of amplitude -A lasting T_doublet seconds,
%     4) a trailing zero interval (length depends on whether the doublet is
%        the last one; see Notes).
%
%   Syntax
%     s = generateDoubletTrain(T_doublet, T_pause, T_init, T_end, A, N, dt)
%
%   Input Arguments
%     T_doublet  — Duration of each positive/negative pulse (scalar, s)
%     T_pause    — Inter-pulse zero gap between the positive and negative
%                  parts of a doublet (scalar, s)
%     T_init     — Time before the first doublet starts; output contains
%                  zeros from t = 0 to t = T_init - dt (scalar, s)
%     T_end      — Trailing zero interval added after the final doublet
%                  (scalar, s)
%     A          — Peak amplitude of the positive pulse (scalar)
%     N          — Number of doublets to generate (positive integer)
%     dt         — Time step / sampling interval (scalar, s)
%
%   Output Arguments
%     s          — Struct with fields:
%                    timestamp : (M×1) column time vector (seconds)
%                    value     : (M×1) column vector of amplitude samples
%
%   Behavior Notes
%     - The time base starts at 0 and contains samples in steps of dt.
%     - The function appends an initial waiting segment of zeros from 0 to
%       T_init-dt (inclusive), then generates N doublets consecutively.
%     - For each non-final doublet the trailing zero interval equals 
%       T_pause; for the final doublet the code uses T_end 
%       (see implementation).
%     - Output vectors are column vectors; length M depends on N and the
%       durations provided.
%
%   Example
%     % Generate 3 doublets with 10 ms pulses, 20 ms inter-pulse pause,
%     % start delay 0.1 s, end padding 0.2 s, amplitude 1, sample at 1 kHz.
%     s = generateDoubletTrain(0.01, 0.02, 0.1, 0.2, 1, 3, 1/1000);
%     plot(s.timestamp, s.value);
%     xlabel('Time (s)'); ylabel('Amplitude'); ylim([-1.2 1.2]);

    % Parametrised simple doublet
    simpleDoublet = @(t, t0, tf) ...
        A * (t >= t0 & t < (t0+T_doublet)) + ...
        0 * (t >= (t0+T_doublet) & t < (t0+T_doublet+T_pause)) + ...
        -A * (t >= (t0+T_doublet+T_pause) & ...
        t < (t0+T_pause+2*T_doublet)) + ...
        0 * (t >= (t0+T_pause+2*T_doublet) & ...
        t < (t0+T_pause+2*T_doublet+tf));
    
    % Waiting for doublet
    s.timestamp = (0 : dt : (T_init-dt))';
    s.value = zeros(size(s.timestamp));

    % Doublet train generation
    t0 = T_init;
    for k = 1 : N
        
        if k == N
            tf = T_end+dt;
        else
            tf = T_pause;
        end

        % Simple doublet
        time = (t0 : dt : (t0 + 2*T_doublet + T_pause + tf - dt))';
        y = simpleDoublet(time, t0, tf);
        
        % Updating signal
        s.timestamp = [s.timestamp; time];
        s.value = [s.value; y];
        
        % Initializing t0
        t0 = time(end) + dt;

    end

end