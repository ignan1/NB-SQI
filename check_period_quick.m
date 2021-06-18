function out = check_period_quick(period, points, fs)
% Input:
%   period - ABP signal corresponding to 1 heart cycle (1 x N)
%   points - Characteristic points (1 x 10)
%   fs     - sampling frequency (Hz)
% Output:
%   out    - result of the fast checks (1 x 10)
%
% ---------------------------------------------------------
%
% Released under MIT license.  
% Copyright (c) 2021 Anna Ignácz, Sándor Földi, Péter Sótonyi, György Cserey
% For any comment or bug report, please send e-mail to: anna.ignacz95@gmail.com
%

    %points = [infl1 p0 infl2 sis o1 s1 p1 o2 s2 p2];

    period_norm = (period-min(period))/max(period-min(period));
    
    out = zeros(1,10);
    last = max(points([4, 6, 7, 9, 10]));
    
    % Rise time of systolic wave
    drs = points(4)/fs;
    out(1) = drs < 0.08 || drs > 0.49;
    
    % Systolic / diastolic duration
    dd = length(period(points(4)+1:end))/fs;
    out(2) = drs/dd > 1.1;
    
    % # of diastolic waves
    d = movmean(diff(movmean(period(last:end),5*fs/100)),0.01*fs,'Endpoints','shrink');
    %if fs > 300, d = movmean(d,0.07*fs);end
    out(3) = sum(d(1:end-1) > 0 & d(2:end) <= 0) > 2;
    
    % Peak in late diastole
    out(4) = max(period(last:end)) > period(last); 
    
    % Systolic phase is not monotonically increasing
    d = movmean(diff(period(1:max(points(4),2))),3);
    min_peaks = find(d(1:end-1) <= 0 & d(2:end) > 0)+1;
    out(5) = (points(2) > 0 && period(points(3)) < period(points(2))) || (points(2) == 0 && sum((period_norm(min_peaks)-period_norm(1)) > 0.1) > 0 );
    
    % Negative valley in diastole
    m = min(period(1),period(end));
    neg = find(period(last:end-floor(0.1*length(period(last:end)))) < m)+last-1;
    out(6) = ~isempty(neg) && sum(abs(period_norm(end)-period_norm(neg)) > 0.02) > 1*fs/100;
    
    % 3rd peak is way bigger than 2nd -> inserted into out(8)
    out(7) = 0;%(points(10) > 0 && points(7) > 0) && (period(points(10)) > period(points(7)));
    
    % There is greater peak than sis, or if the 3rd peak is as big as the sys
    out(8) = period_norm(points(4)) < 0.8 || (points(10) > 0 && period(points(10)) >= period(points(4))-0.05);
    
    % If p0's inlf point is too small, or p0 is too small
    out(9) = points(2) > 0 && ((period_norm(points(2)) < 0.4) || ((period_norm(points(2))-period_norm(points(3))) > 0.1)); 
    
    % If 2nd peak is with the same hight as sys, but it's onset is too low
    out(10) = points(7) > 0 && (abs(period_norm(points(7))-period_norm(points(4)))< 0.1 && abs(period_norm(points(5))- period_norm(points(7))) > 0.2);

end