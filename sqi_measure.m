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
% ---------------------------------------------------------
% MIT License
% 
% Copyright (c) 2021 Anna Ignácz, Sándor Földi, Péter Sótonyi, György Cserey
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
% For any comment or bug report, please send e-mail to: anna.ignacz95@gmail.com
%

    if size(signal, 1) > 1, signal = signal'; end

    featnum = 30;
    [out, dia] = check_pulse(signal, fs);
    if out
        sqi = 0;                    % "No pulse found";
        P = [];
        feat = zeros(1,featnum);
        if isempty(dia), dia = 1; end
        return
    end

    feat = []; sqi = []; dia_new = [];
    P = []; prev_feat = [];
    for i = 1:length(dia)-1
        period = signal(dia(i):dia(i+1)-1);
        [sqi_p, prev_feat, extra, points] = sqi_period(period, fs);
        feat = [feat, prev_feat'];

        % If there was an extra period (WIP)
        if ~isempty(extra)
            d = dia(i);
            for j = 1:length(extra)
                d = d+extra-1;
                dia_new = [dia_new; d];
            end
        end

        sqi = [sqi, sqi_p];
        points(points > 0) = dia(i) + points(points > 0)-1;
        P = [P; dia(i), points];
    end
    P = P';

    % If there was an extra period (WIP)
    if ~isempty(dia_new)
        dia = [dia, dia_new];
        dia = sort(dia,'asc');
        % Correct P and feat
    end

end
