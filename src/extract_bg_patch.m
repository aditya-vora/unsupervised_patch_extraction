function bg_patches = extract_bg_patch(frame_props, fg_patches)

    % Extract background patches from the selected frames of the video.
    %
    % INPUTS:
    % frame_props - cell containing proposals. shape cell {Nf x 1}
    % fg_patches - fg_patches [Nf x 4] 
    %
    % OUTPUTS:
    % bg_patches - background patches from each frame. [Nf x 4]   

    bg_patches = zeros(length(frame_props),4);

    for i=1:length(frame_props)
        
        frame_prop_n_scores = frame_props{i};
        
        props = frame_prop_n_scores(:,1:4);
        
        s_app = frame_prop_n_scores(:,5); s_mot = frame_prop_n_scores(:,6);
    
        % Normalize the scores for better selection
        sa_norm = (s_app - min(s_app)) / (max(s_app) - min(s_app));
        sm_norm = (s_mot - min(s_mot)) / (max(s_mot) - min(s_mot));

        scores = sa_norm .* sm_norm;
        
        [~,idx] = sort(scores, 'ascend');

        bg_props = props(idx,:);
        
        bg_cands = bg_props(1:100,:);
        
        areas = bg_cands(:,3) .* bg_cands(:,4);
        
        mean_area = mean(areas);
        
        [rid,~] = find(areas > mean_area);
        
        bg_big_cands = bg_cands(rid,:);
        
        fg_patch = fg_patches(i,:);
        
        overlap = bboxOverlapRatio(fg_patch, bg_big_cands);
        
        [~, idx] = min(overlap);
        
        bg_patch = bg_big_cands(idx,:);
        
        bg_patches(i,:) = bg_patch;

    end

end

