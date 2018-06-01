function fg_candidates = select_top_props(frame_prop, numTopRegs)
    % Select the best fg_candidate proposals
    %
    % INPUTS:
    % frame_prop - proposals of a frame [x y w h sa sm]
    % numTopRegs - number of fg_candidates to select per frame
    %
    % OUTPUTS:
    % fg_candidates - best proposals for fg extraction [x y w h s]

    s_app = frame_prop(:,5); s_mot = frame_prop(:,6);
    
    % Normalize the scores for better selection
    sa_norm = (s_app - min(s_app)) / (max(s_app) - min(s_app));
    sm_norm = (s_mot - min(s_mot)) / (max(s_mot) - min(s_mot));

    % Get the combined scores
    s = sa_norm.*sm_norm;
    
    
    frame_props_n_scores(:,1:4) = frame_prop(:,1:4);
    frame_props_n_scores(:,5) = s;

    % sort the scores
    [~, sortidx] = sort(frame_props_n_scores(:,5),'descend');
    frame_props_n_scores = frame_props_n_scores(sortidx,:);

    fg_candidates = frame_props_n_scores(1:numTopRegs, :);

end

