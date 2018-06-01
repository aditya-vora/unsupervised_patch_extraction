function frame_props = compute_proposals(frame_pairs, frame_flows, propModel, propOpts)

% Function to compute object proposals on all the images and the
% corresponding optical flow frames.
%
% INPUT: 
% frame_pairs - Cell array containing structs of frames with curr_frame and next_frame fields
% frame_flows - Cell array containing optical flow magnitude frames.
% propModel - model params to compute object proposals.
% propOpts - params to compute object proposals
%
% OUTPUT: 
% frame_props - returns a cell array containing both proposals on frame and proposals on flow image.



for i=1:length(frame_pairs)
    
    % Get the curr frame
    im = frame_pairs{i}.curr_frame;
    
    % Get the corresponding flow image
    flowimg = frame_flows{i};
    
    % Compute proposals on both flow magnitude frame and RGB frame
    [I_bbs, I_E, I_O, I_o] = edgeBoxes(im,propModel,propOpts);
    [F_bbs, F_E, F_O, F_o] = edgeBoxes(flowimg,propModel,propOpts);
    
    % Get the scores
    apscore = edgeBoxesEvalMex(I_E,I_O,I_o.alpha,I_o.beta,I_o.eta,I_o.minScore,I_o.maxBoxes,...
      I_o.edgeMinMag,I_o.edgeMergeThr,I_o.clusterMinMag,...
      I_o.maxAspectRatio,I_o.minBoxArea,I_o.gamma,I_o.kappa,F_bbs(:,1:4));
    
    if size(I_bbs,1) < 100
        frame_props = {};
        return
    end
        
    % Append the scores
    F_bbs = [F_bbs(:,1:4) apscore F_bbs(:,5)];
    
    % Get the flow scores of the proposals obtained from the image
    flowscore = edgeBoxesEvalMex(F_E,F_O,F_o.alpha,F_o.beta,F_o.eta,F_o.minScore,F_o.maxBoxes,...
      F_o.edgeMinMag,F_o.edgeMergeThr,F_o.clusterMinMag,...
      F_o.maxAspectRatio,F_o.minBoxArea,F_o.gamma,F_o.kappa,I_bbs(:,1:4));
    
    % Append the scores
    I_bbs = [I_bbs flowscore];
    
    
    frame_props{i} = [I_bbs;F_bbs];
end

end

