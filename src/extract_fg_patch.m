function fg_props = extract_fg_patch(fg_candidates_info,net)
    
    % Function to ex0tract the actual foreground patches from each frame
    % through clustering
    %
    % INPUTS:
    % fg_candidates_info - cell {Nf,1}
    %
    % OUTPUTS:
    % fg_props - [Nf x 4]

    % Treat the first frame as the seed frame
    
    seed_fg_info = fg_candidates_info{1};
    seed_fg_props = seed_fg_info.fg_cands;  % [numTopRegs x 4]
    seed_fg_feats = seed_fg_info.features;  % [numTopRegs x 2048]             
    
    
    % preallocation of scores and idxs
    seed_to_all_best_ip_scores = zeros(size(seed_fg_props,1), length(fg_candidates_info)-1);    % [numTopRegs x (Nf-1)]
    seed_to_all_best_ip_idxs = zeros(size(seed_fg_props,1), length(fg_candidates_info)-1);      % [numTopRegs x (Nf-1)]
    nframes_bboxs_scores = zeros(size(seed_fg_props,1),length(fg_candidates_info)-1);           % [numTopRegs x (Nf-1)]


    
    for i=1:size(seed_fg_props, 1)
        seed_fg_feat = seed_fg_feats(i,:);
        for j=1:length(fg_candidates_info)-1
            nth_fg_info = fg_candidates_info{j+1};
            nth_fg_scores = nth_fg_info.scores;
            nth_fg_feats = nth_fg_info.features;                           %[numTopRegs x 2048]
            if i==1
                nframes_bboxs_scores(:,j) = nth_fg_scores;
            end
            sim = nth_fg_feats*seed_fg_feat';                              %[numTopRegs x 2048] x [2048 x 1]
            [best_ip_score, best_ip_idx] = max(sim);
            seed_to_all_best_ip_scores(i,j) = best_ip_score;
            seed_to_all_best_ip_idxs(i,j) = best_ip_idx;
        end
    end
    
    
    %[numTopRegs x 1]
    cluster_scores = zeros(1,size(seed_to_all_best_ip_scores,1));

    % Compute cluster scores. 
    for i=1:size(seed_to_all_best_ip_scores,1)
        
        % [1 x (Nf-1)]
        rowidxs = seed_to_all_best_ip_idxs(i,:);
        % [1 x (Nf-1)]
        colidxs = [1:1:size(seed_to_all_best_ip_idxs,2)];
        matidxs = sub2ind(size(seed_to_all_best_ip_idxs), rowidxs, colidxs);
        
        % get the appearance scores [1 x (Nf-1)]
        ap_scores = nframes_bboxs_scores(matidxs);
        % get the inner product scores [1 x (Nf-1)]
        ip_scores = seed_to_all_best_ip_scores(i,:);
        cluster_scores(i) = sum(ap_scores.*ip_scores);
    end
    
    [~, seed_idx] = max(cluster_scores);
    br_idxs = seed_to_all_best_ip_idxs(seed_idx,:);
    
    fg_props = zeros(length(fg_candidates_info),4);
    fg_props(1,:) = seed_fg_props(seed_idx,:);
    
    for i=2:length(fg_candidates_info)
        nth_fg_info = fg_candidates_info{i};
        nth_fg_props = nth_fg_info.fg_cands;
        %props = props_n_scores(:,1:4);
        match_prop = nth_fg_props(br_idxs(i-1),:);
        fg_props(i,:) = match_prop;
    end
    
end
