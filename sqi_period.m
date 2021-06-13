function [sqi, feat, extra, points] = sqi_period(period, fs, prev_feat)
    
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
        %categ = max([4*(points(2) > 0) sum([points(4) > 0 (points(6) > 0 || points(7) > 0) (points(9) > 0 || points(10) > 0)])]);
        categ = max([4*(points(2) > 0) sum([points(4) > 0 (points(7) > 0) (points(9) > 0 || points(10) > 0)])]);
        out = check_period_quick(period, points, fs);
        if sum(out) > 0
            sqi = 1;%max(0,5-sum(out));%string(num2str(20*sum(out)));
            feat = [zeros(1,featnum) categ];
        else
            %feat = get_features_period(period, points, fs, categ);
            %out = check_features_period(feat, points(2));
            feat = get_all_feat_ever(period, points, fs, categ);
            if sum(out) > 0, sqi = max(5-sum(out),0); else %string(num2str(sum(out))); else
                feat = get_all_feat(period, points, fs, categ);
                sqi = get_dist_from_avr_feat_period(feat);                
            end
        end
        
%         if out
%             sqi = "Bad char points";
%             feat = prev_feat;
%         else            
%             % Check the features
%             feat = get_features_period(period, points, fs);
%             out = check_features_period(feat);
%             if out
%                 sqi = "Bad features";
%                 feat = prev_feat;
%             else
%     
%             sqi = "Seems good";
%             
%             end
%         end
    end

    if ~isempty(extra)
        [sqi_new, feat, extra_new] = sqi_period(new_period, fs, feat);
        sqi = [sqi, sqi_new];
        extra = [extra, extra_new];
        % featet is megcsinálni
    end
    
end