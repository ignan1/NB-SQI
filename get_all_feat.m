function feat = get_all_feat(period, points, fs, categ)
% Input:
%   period - ABP signal corresponding to 1 heart cycle (1 x N)
%   points - Characteristic points (1 x 9)
%   fs     - sampling frequency (Hz)
%   categ  - Type of the waveform (1 peak, 2 peak, 3 peak, or refl before sys)
% Output:
%   feat   - All calculated feature (32 x 1)
%
% ---------------------------------------------------------
% MIT License 
% Copyright (c) 2021 Anna Ign�cz anna.ignacz95@gmail.com
%

    period = (period - min(period))/max(period - min(period));
    %[2, 4, 5, 7, 10, 11, 12, 13, 17, 18, 20, 21, 28]
    %[1 3 6 8 9 14 15 16 19 22 23 24 25 26 27 29 30 31 32
    %% Time domain
    feat_td = zeros(1,11);
    % time between dia and infl / T
    % time between dia and 0th peak / T
    % time between dia and sis / T
    % time between dia and 1st peak / T
    % time between dia and 2nd peak / T
    % time between sis and 2nd peak / T
    
    %points = [infl1 p0 infl2 sis o1 s1 p1 o2 s2 p2];
    feat_td(1:4) = points([1 4 7 10]) / length(period);% infl p0 sis p1 p2 2nd peak points([1 2 4 6 7]) / length(period);
    if points(2) > 0, feat_td(3) = points(2) / length(period);
        feat_td(4) = max(points(7), points(10))/ length(period); end
    if points(6) > 0, feat_td(3) = points(6) / length(period); end
    if points(9) > 0, feat_td(4) = points(9) / length(period); end
    
    feat_td(5) = (points(10) - points(4)) / length(period);
    
    % width of sis
    % width of 2nd peak
    sis = points(4); if sis == 0, sis = NaN; end
    p2 = points(10); if p2 == 0, p2 = NaN; end
        
    [SW, DW] = get_sys_width(period,[sis p2],fs);
    feat_td([6 7]) = [SW DW];
    
    % amplitude of infl
    % amplitude of 0th peak
    % amplitude of sis
    % amplitude of 1st peak
    % amplitude of 2nd peak
    period = [0 period];
    feat_td(8:11) = period(points([1 4 7 10])+1);
    if points(2) > 0, feat_td(10) = period(points(2)+1);
        feat_td(11) = period(max(points(7), points(10))+1); end
    if points(6) > 0, feat_td(10) = period(points(6)+1); end
    if points(9) > 0, feat_td(11) = period(points(9)+1); end
    period = period(2:end);

    
    feat_td(feat_td == 0) = NaN;
    
    %% Wavelet domain
    % 8 wavelet energy band
    if fs == 1000, period = period(1:10:length(period)); end
    period = (period-min(period))/max(period-min(period));

    [c,l] = wavedec(period,7,'db6');
    b = 1; Ew = zeros(1,length(l)-1);
    for j = 1:length(l)-1
        Ew(j) = sum(power(c(b:b+l(j)-1),2));
        b = b+l(j);
    end
    feat_wave = Ew/(length(period));

    %% Statistical features
    feat_stat = [mean(period) median(period) std(period) iqr(period) sqrt(mean(period.^2)) ...
                   skewness(period) kurtosis(period) wentropy(period,'shannon')];
    
    %% Egy�b featureok
    noise = sum(abs(diff(period)))/length(period);
    d = abs(period(1)-period(end));
    if fs == 1000, fs = 100; end
    integ = trapz((1:length(period))/fs, period);

    %% All feature
    feat = [feat_td, feat_wave, feat_stat, noise, d, integ, categ];

end
