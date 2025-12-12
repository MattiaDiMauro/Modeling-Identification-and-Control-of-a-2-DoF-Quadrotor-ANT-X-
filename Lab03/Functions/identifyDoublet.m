function doublet = ...
    identifyDoublet(t_start_approx, t_end_approx, input_signal, ...
    doublet_amplitude)

%% Extract doublet signal

% Logical indexing of times
doublet_approx.logIdx = input_signal.timestamp >= t_start_approx & ...
    input_signal.timestamp <= t_end_approx;

% Extract approximate doublet signal
doublet_approx.timestamp = input_signal.timestamp(doublet_approx.logIdx);
doublet_approx.value = input_signal.value(doublet_approx.logIdx);

% Extrapolating time of commands
doublet_approx.diff = diff(doublet_approx.value);
doublet_approx.diff_logIdx = ...
    abs(doublet_approx.diff) > (doublet_amplitude/2);
doublet_approx.diff_idx = find(doublet_approx.diff_logIdx);

% Time of commands
doublet.idx_commands = doublet_approx.diff_idx + 1;
doublet.time_commands = doublet_approx.timestamp(doublet.idx_commands);

end