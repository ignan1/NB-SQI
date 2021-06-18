function points = find_dsnp_period(period, fs)
% Input:
%   period - ABP signal corresponding to 1 heart cycle (1 x N)
%   fs     - sampling frequency (Hz)
% Output:
%   points - characteristic points (1 x 10)
%
% ---------------------------------------------------------
%
% Released under MIT license.  
% Copyright (c) 2021 Anna Ignácz, Sándor Földi, Péter Sótonyi, György Cserey
% For any comment or bug report, please send e-mail to: anna.ignacz95@gmail.com
%

    period = (period-min(period))/max(period-min(period));
    d = movmean(diff(period),0.05*fs,'Endpoints','shrink');
    
% find sistolic peak
    peaks = find(d(1:end-1) > 0 & d(2:end) <= 0) + 1;
    if ~isempty(peaks)
        [~, h] = max(period(max(peaks(1)-floor(5*fs/100),1):min(peaks(1)+floor(5*fs/100),length(period))));
        sis = max(peaks(1)-floor(5*fs/100),1)+h-1;
    else
        [~, sis] = max(period(1:floor(2*length(period)/3)));
    end

% find inflection point of sistolic slope
    d2 = movmean(diff(d),fs/50);
    peaks = find(d2(1:min(sis,length(d))-1) > 0 & d2(2:min(sis,length(d))) <= 0) + 1;
    if ~isempty(peaks)
        [~, h] = max(d(max(1,peaks(1)-floor(1*fs/100)):min(peaks(1)+floor(1*fs/100),length(d))));
        infl1 = max(1,peaks(1)-floor(1*fs/100))+h-1;
    else
        [~, infl1] = max(d(1:sis));
    end
    
% find if there is a peak before systolic peak
    if length(peaks) > 1
        [~, h] = max(d(max(1,peaks(2)-floor(1*fs/100)):min(peaks(2)+floor(1*fs/100),length(d))));
        infl2 = max(1,peaks(2)-floor(1*fs/100))+h-1;
        [~, h] = min(d(peaks(1):peaks(2)));
        p0 = peaks(1)+h-1;
    else
        d2 = (diff(d));%movmean(diff(d(sis:floor(length(period)*0.7))),fs/50);
        shos = find(d2(infl1:sis-1) > 0 & d2(infl1+1:sis) <= 0)+infl1;
        if ~isempty(shos)
            infl2 = shos(1);
            [~, h] = min(d2(infl1:infl2));
            p0 = infl1 + h - 1;
            if p0 == infl1 || p0 == infl2
                infl2 = 0;
                p0 = 0;
            end
        else
            infl2 = 0;
            p0 = 0;
        end
    end

% find 2nd wave
    peaks = find(d(sis+2:end-1) > 0 & d(sis+3:end) <= 0)+sis+2;
    cut = max(length(period)*0.8, 0.6*fs);
    peaks = peaks((peaks <= cut & period(peaks) > 0.2) & peaks > sis);
    
    p1 = 0; o1 = 0; s1 = 0;
    p2 = 0; o2 = 0; s2 = 0;
    
    if length(peaks) == 1 
        if period(peaks) < 0.8
            [~, h] = max(period(max(1,peaks(1)-floor(2*fs/100)):min(peaks(1)+floor(2*fs/100),length(period))));
            p2 = max(1,peaks(1)-floor(2*fs/100))+h-1;
        else
            [~, h] = max(period(max(1,peaks(1)-floor(2*fs/100)):min(peaks(1)+floor(2*fs/100),length(period))));
            p1 = max(1,peaks(1)-floor(2*fs/100))+h-1;
        end
    else
        if length(peaks) == 2
            [~, h] = max(period(max(1,peaks(1)-floor(2*fs/100)):min(peaks(1)+floor(2*fs/100),length(period))));
            p1 = max(1,peaks(1)-floor(2*fs/100))+h-1;
            [~, h] = max(period(max(1,peaks(2)-floor(2*fs/100)):min(peaks(2)+floor(2*fs/100),length(period))));
            p2 = max(1,peaks(2)-floor(2*fs/100))+h-1;
            if period(p1) < 0.5, p2 = p1; p1 = 0; end 
            if p1 == sis, p1 = 0; end
            if period(p2) < 0.3, p2 = p1; p1 = 0; end
        else
            if length(peaks) > 2                               
                [~, h] = max(period(max(1,peaks(1)-floor(5*fs/100)):min([peaks(1)+floor(5*fs/100),length(period) max(1,peaks(2)-floor(2*fs/100))])));
                pa = max(1,peaks(1)-floor(5*fs/100))+h-1;
                [~, h] = max(period(max(1,peaks(2)-floor(2*fs/100)):min([peaks(2)+floor(2*fs/100),length(period) max(1,peaks(3)-floor(2*fs/100))])));
                pb = max(1,peaks(2)-floor(2*fs/100))+h-1;    
                [~, h] = max(period(max(1,peaks(3)-floor(2*fs/100)):min(peaks(3)+floor(2*fs/100),length(period))));
                pc = max(1,peaks(3)-floor(2*fs/100))+h-1;    
                
                if pa == sis, p1 = pb; p2 = pc; else
                    if pa ~= pb, p1 = pa; p2 = pb; else
                        if pb~= pc, p1 = pb; p2 = pc; else
                            p2 = pc; end
                    end
                end
            end
        end
    end
    
    a = sis;
    if p1 > 0, [~, h] = min(period(a:p1));
        o1 = a+h-1; a = p1; end
    if p2 > 0, [~, h] = min(period(a:p2));
        o2 = a+h-1; end
    
    if p2 > 0 && p1 == 0
        d2 = movmean(diff(d(sis:o2)),0.05*fs);
        shos = find(d2(1:end-1) > 0 & d2(2:end) <= 0)+sis;
        if ~isempty(shos)
            s1 = shos(1);
        end
    end
    
    if p1 > 0 && p2 == 0
        d2 = movmean(diff(d(p1:floor(length(period)*0.7))),0.05*fs);
        shos = find(d2(1:end-1) > 0 & d2(2:end) <= 0)+sis;
        if ~isempty(shos)
            s2 = shos(1);
        end
    end
    
    
    
    
    if p1 == 0 && p2 == 0
        d2 = movmean(diff(d(sis:floor(length(period)*0.7))),fs/50);
        shos = find(d2(1:end-1) > 0 & d2(2:end) <= 0)+sis;
        shos = shos(period(shos) > 0.3);
        if ~isempty(shos)
            
            if length(shos) > 1
                [~, h] = max(period(shos(1):shos(1)+floor(0.02*fs)));
                s1 = shos(1)+h-1;
                [~, h] = max(period(shos(2):shos(2)+floor(0.02*fs)));
                s2 = shos(2)+h-1;
            else
                [~, h] = max(period(shos(1):shos(1)+floor(0.02*fs)));
                s2 = shos(1)+h-1;
            end
            
            if s1 > 0
                [~, h] = min(period(max(1,s1-floor(0.05*fs)):s1));
                if h < length(period(max(1,s1-floor(0.05*fs)):s1))-2
                    o1 = s1-floor(10*fs/100) + h;
                    [~, h] = max(period(o1:s1+floor(0.05*fs)));
                    p1 = o1+h-1;
                    s1 = 0;
                end
            end
            
            if s2 > 0
                [~, h] = min(period(s2-floor(0.05*fs):s2));
                if h < length(period(s2-floor(0.05*fs):s2))-2
                    o2 = s2-floor(0.05*fs) + h;
                    [~, h] = max(period(o2:s2+floor(0.05*fs)));
                    p2 = o2+h-1;
                    s2 = 0;
                end
            end
        end
    end        
    
    if p0 > 0 && p1 > 0
        p2 = p1; p1 = 0;
        o2 = o1; o1 = 0;
        s2 = 0;
    end
    if p0 > 0 && s1 > 0
        p2 = 0; o2 = o1;
        s2 = s1; s1 = 0;
    end
    
    points = [infl1 p0 infl2 sis o1 s1 p1 o2 s2 p2];
    
end