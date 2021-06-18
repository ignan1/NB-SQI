function [out, extra, new_period] = check_period_length(period, fs, feat)
% Input:
%   period     - ABP signal corresponding to 1 heart cycle (1 x N)
%   fs         - sampling frequency (Hz)
%   feat       - features of the period (1 x 10)
% Output:
%   out        - 1 if the period is too long or too short
%   extra      - extra onset point, if an onset point was missed (WIP)
%   new_period - divide the period, if an onset point was missed (WIP) (1 x M)
%
% ---------------------------------------------------------
%
% Released under MIT license.  
% Copyright (c) 2021 Anna Ignácz, Sándor Földi, Péter Sótonyi, György Cserey
% For any comment or bug report, please send e-mail to: anna.ignacz95@gmail.com
%

    extra = [];
    new_period = [];
    
    t = length(period) / fs;
    
%     if t > feat(1)*1.75
%         extra = new_dia(period, fs);
%         if ~isempty(extra)
%             new_period = period(1:extra-1);
%             period = period(extra:end);
%         end
%         
%         t = length(period) / fs;
%     end
    
    out = t < 0.27 || t > 2.4;
end
