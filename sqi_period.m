function [sqi, feat, extra, points] = sqi_period(period, fs)
% Input:
%   period - ABP signal corresponding to 1 heart cycle (1 x N)
%   fs     - sampling frequency (Hz)
% Output:
%   sqi    - sqi of the period
%   feat   - features of the period (1 x 31)
%   extra  - new period, if this was too long (WIP)
%   points - characteristic points (1 x 10)
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

    if size(period, 1) > 1, period = period'; end

    % Number of evaluated features
    featnum = 30;
    
    % Check the length of the period
    [out, extra, new_period] = check_period_length(period, fs);
            
    if out
        sqi = 0;%4; % "Too long/short period";
        feat = zeros(1,featnum + 1); %prev_feat;
        points = zeros(1,10);
    else
        % Check the characteristic points
        points = find_dsnp_period(period, fs);        
        % Category of the period (1 peak, 2 peak, 3 peak, 2nd peak before sys peak)
        categ = max([4*(points(2) > 0) sum([points(4) > 0 (points(7) > 0) (points(9) > 0 || points(10) > 0)])]);
        out = check_period_quick(period, points, fs);
        if sum(out) > 0
            feat = [zeros(1,featnum) categ];
            sqi = 1;
        else
            feat = get_all_feat(period, points, fs, categ);
            sqi = get_dist_from_avr_feat_period(feat);
        end        
    end

    % If there is an extra period
    if ~isempty(extra)
        [sqi_new, feat, extra_new] = sqi_period(new_period, fs, feat);
        sqi = [sqi, sqi_new];
        extra = [extra, extra_new];
    end
    
end