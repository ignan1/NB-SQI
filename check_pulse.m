function [out, dia] = check_pulse(signal, fs)
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
    out = length(signal) < fs;
    if out
        dia = [];
    else
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
    end
    dia = unique(dia);
end