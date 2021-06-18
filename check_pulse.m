function [out, dia] = check_pulse(signal, fs)
% Input:
%   signal - ABP signal (1 x N)
%   fs     - sampling frequency (Hz)
% Output:
%   out    - 1 if there is no pulse found
%   dia    - location of onset points (1 x p)
%
% ---------------------------------------------------------
%
% Released under MIT license.  
% Copyright (c) 2021 Anna Ignácz, Sándor Földi, Péter Sótonyi, György Cserey
% For any comment or bug report, please send e-mail to: anna.ignacz95@gmail.com
%
    out = length(signal) < fs;
    dia = [];
    if ~out
        signal_nobase = signal-movmean(movmean(movmean(signal,fs),fs),fs);
        dia = find_dia(signal_nobase, fs);
        for i = 1:length(dia)-1
            [~, h] = min(signal(max(1,dia(i)-floor(0.03*fs)):min(dia(i)+floor(0.15*fs),length(signal))));
            dia(i) = max(1,dia(i)-floor(0.03*fs))+h-1;

            d = diff(signal(dia(i):min(dia(i)+floor(0.08*fs),length(signal))));
            
            m = (signal(dia(i):dia(i+1)-1)-signal(dia(i)))/max(signal(dia(i):dia(i+1)-1)-signal(dia(i)));
            ind = find(d(1:end-1) <= 0 & d(2:end) > 0);
            if  ~isempty(ind)
                j = length(ind);
                while j > 0
                    if length(m) > ind(j) && m(ind(j)) < 0.1
                        dia(i) = dia(i) + ind(end);
                        j = 0;
                    else
                        j = j-1;
                    end
                end
            end
        end
        
        out = length(dia) < 2 || length(dia) < (length(signal)/fs)/5 || length(dia) > (length(signal)/fs)*10;
        dia = unique(dia);
    end
end