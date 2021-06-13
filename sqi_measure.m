function [sqi, dia, P, feat] = sqi_measure(signal, fs)
% Input:
%   signal - ABP signal (1 x N)
%   fs     - sampling frequency (Hz)
% Output:
%   sqi    - sqi of every periods (1 x p-1)
%   dia    - location of onset points (1 x p)
%   P      - location of characteristic points (11 x p-1)
%   feat   - extracted features of every periods (31 x p-1)
%
% Author: Anna Ignácz 2020
% anna.ignacz95@gmail.com
%

if size(signal, 1) > 1, signal = signal'; end

featnum = 30;
[out, dia] = check_pulse(signal, fs);
if out
    sqi = 0;%featnum;%"No pulse found";
    P = [];
    feat = zeros(1,featnum);
    if isempty(dia), dia = 1; end
    return
end

% check every period
feat = []; sqi = []; dia_new = [];
P = []; prev_feat = [];
for i = 1:length(dia)-1
    period = signal(dia(i):dia(i+1)-1);
    [sqi_p, prev_feat, extra, points] = sqi_period(period, fs, prev_feat);
    feat = [feat, prev_feat'];
    if ~isempty(extra)
        d = dia(i);
        for j = 1:length(extra)
            d = d+extra-1;
            dia_new = [dia_new; d];
        end
    end
    sqi = [sqi, sqi_p]; 
    points(points > 0) = dia(i)+points(points > 0)-1;
    P = [P; dia(i), points];
end
P = P';

if ~isempty(dia_new)
    dia = [dia, dia_new];
    dia = sort(dia,'asc');
    % P-t és feat-et javítani
end

end
