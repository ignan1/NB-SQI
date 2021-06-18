function dia = find_dia(signal_or, fs)
% Input:
%   signal_or - ABP signal (1 x N)
%   fs        - sampling frequency (Hz)
% Output:
%   dia       - index of diastolic points
%
% ---------------------------------------------------------
%
% Released under MIT license.  
% Copyright (c) 2021 Anna Ignácz, Sándor Földi, Péter Sótonyi, György Cserey
% For any comment or bug report, please send e-mail to: anna.ignacz95@gmail.com
%

    start = 1;
    
    dia = [];
    div_sec = 5; % second - to divide the signal and normalize
    while start < length(signal_or)
        
        signal = signal_or(max(1,start-fs):min(start + div_sec*fs,length(signal_or)));
        signal = (signal-min(signal))/max(signal-min(signal));
        
        diff_signal = diff(signal);
        peaks = find(diff_signal(1:end-1) > 0 & diff_signal(2:end) <= 0) + 1;
        
        sis = peaks(signal(peaks) > 0.6);
                
        if ~isempty(sis)
            [m, h] = min(signal(1:sis(1)));
            if m < 0.3
                dia = [dia, h + max(1,start-fs) - 1];
            end
        
            for j = 2:length(sis)
                [m, h] = min(signal(sis(j)-round(0.3*(sis(j)-sis(j-1))):sis(j)));
                if m < 0.3
                    dia = [dia, h + max(1,start-fs) + sis(j)-round(0.3*(sis(j)-sis(j-1))) - 1];
                end
            end
        end
        
        start = start + 5*fs;
    end
    
    dia_cor = [];
    for j = 1:length(dia)
        [~, h] = min(signal_or(max(1,dia(j)-round(0.1*fs)):min(dia(j)+round(0.1*fs),length(signal_or))));
        dia_cor = [dia_cor, h + max(1,dia(j)-round(0.1*fs)) - 1];
    end
    
    dia = unique(dia_cor);
end