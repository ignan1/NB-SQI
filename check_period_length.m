function [out, extra, new_period] = check_period_length(period, fs, feat)
        
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
