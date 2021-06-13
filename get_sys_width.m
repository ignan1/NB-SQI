function [SW, DW] = get_sys_width(period,points,fs)

a = period(1);
b = period(points(1));
if ~isnan(points(2))
    c = period(points(2));
else
    c = NaN;
end

hp = (a+b)/2;
hs = (a+c)/2;

[~, p1] = min(abs(period(1:points(1)) - hp)); 

j = points(1);
h = 1; 
SW = NaN;
while h
    if j == length(period)
        SW = NaN;
        h = 0;
        disp('SW not found');
    else
        if period(j)-hp >= 0 && period(j+1)-hp < 0
            p2 = j;
            SW = (p2-p1+1)/fs;
            h = 0;
        end
    end
    j = j+1;
end

if ~isnan(points(2))
    [~, p3] = min(abs(period(points(2):end) - hs)); 
else
    p3 = NaN;
end


DW = (2*p3)/fs;

end

