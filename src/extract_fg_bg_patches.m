function [fg_patches,bg_patches] = extract_fg_bg_patches(frame_pairs, frame_props, frame_paths, net, extObjOpts, saveinfo)

    % Extract foreground and background patches from the selected frames of the video.
    %
    % INPUTS:
    % frame_pairs - selected frames, Nf
    % frame_props - Corresponding object proposals.Each element in frame_props contains [2*propOpts.maxBoxes x 6]
    % frame_paths - Paths where the selected frames are stored
    % extObjOpts - Options to extract objects
    % saveinfo - Options for saving the patches.
    %
    % OUTPUTS:
    % fg_patches - Foreground patches coordinates. [Nf x 4] with [x y w h] format
    % bg_patches - Background patches coordinates. [Nf x 4] with [x y w h] format
    
    
    numTopRegs = extObjOpts.numTopRegs; 
    
    % Container to store the fg patches info.
    fg_candidates_info = cell(1,length(frame_pairs));
 
    % Loop through all the frames
    for i = 1:length(frame_pairs)
        
        % [x y w h sa sm]
        frame_prop = frame_props{i};
        frame = frame_pairs{i}.curr_frame; 
        
        % select the best props for fg extraction [x y w h s] and
        % [numTopRegs x 5]
        fg_candidates_n_scores = select_top_props(frame_prop, numTopRegs);
        
        % Only fg_candidate coordinates [x y w h] and [numTopRegs x 4]
        fg_candidates = fg_candidates_n_scores(:,1:4);
        
        % Only fg_candidate scores [numTopRegs x 1]
        fg_scores = fg_candidates_n_scores(:,5);
        
        % Store the information
        fg_candidate_info.frame = frame;                                            % full RGB frame
        fg_candidate_info.features = extract_features_res(frame, fg_candidates, net);    % [numTopRegs x 2048] 
        fg_candidate_info.fg_cands = fg_candidates;                                 % [numTopRegs x 4]
        fg_candidate_info.scores = fg_scores;                                       % [numTopRegs x 1]
        
        fg_candidates_info{i} = fg_candidate_info;      
    end
    
    % fg_candidate_info.frame
    % fg_candidate_info.features
    % fg_candidate_info.fg_cands
    % fg_candidate_info.scores
    
    % Extract actual patches
    fg_patches = extract_fg_patch(fg_candidates_info);
    bg_patches = extract_bg_patch(frame_props, fg_patches);
    
    for i=1:length(fg_candidates_info)
        fg_patch = fg_patches(i,:);
        bg_patch = bg_patches(i,:);
        fg_candidate_info = fg_candidates_info{i};
        frame = fg_candidate_info.frame;
        frame_path = frame_paths{i};
        fg_reg = extract_im_reg(frame, fg_patch);
        bg_reg = extract_im_reg(frame, bg_patch);
        fg_reg = imresize(fg_reg, [227,227]);
        bg_reg = imresize(bg_reg, [227,227]);
        [~, file_id, ~] = fileparts(frame_path);
        imwrite(fg_reg, fullfile(saveinfo.unsup_patches_path, 'fg_patches', ['fg_patch_',file_id,'_',num2str(i),'.jpg']));
        imwrite(bg_reg, fullfile(saveinfo.unsup_patches_path, 'bg_patches', ['bg_patch_',file_id,'_',num2str(i),'.jpg']));
    end
    
    
end

