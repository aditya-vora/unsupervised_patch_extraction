function prop_bbs = props(im, flowimg, propModel, propOpts)

% Extract object proposals from the image and score each proposals based on appearance and motion scores.
%
% USAGE
%   prop_bbs = props(im, flowimg, propModel, propOpts) 
%
% INPUTS
%   im - image for which the object proposals are to be computed.
%   flowimg - optical flow image with each pixel representing the flow magnitude.
%   propModel - model to be used while computing proposals.
%   propOpts - params to compute proposals.
%
% OUTPUTS
%   prop_bbs - [x y w h ap_score op_score] 
%              x, y - x and y location of the proposal
%              w, h - w is width and h is height of the proposal
%              ap_score - appearance score of the proposal
%              op_score - optical flow score of the proposal

    % Compute proposals on the image.
    [I_bbs, I_E, I_O, I_o] = edgeBoxes(im,propModel,propOpts);%[x y w h score]
    
    % Compute proposals on the optical flow image.
    [F_bbs, F_E, F_O, F_o] = edgeBoxes(flowimg,propModel,propOpts);%[x y w h score]
    
    % Get the appearance scores of the proposals obtained from the flow
    % image
    apscore = edgeBoxesEvalMex(I_E,I_O,I_o.alpha,I_o.beta,I_o.eta,I_o.minScore,I_o.maxBoxes,...
      I_o.edgeMinMag,I_o.edgeMergeThr,I_o.clusterMinMag,...
      I_o.maxAspectRatio,I_o.minBoxArea,I_o.gamma,I_o.kappa,F_bbs(:,1:4));
    % Append the scores
    F_bbs = [F_bbs(:,1:4) apscore F_bbs(:,5)];
    
    % Get the flow scores of the proposals obtained from the image
    flowscore = edgeBoxesEvalMex(F_E,F_O,F_o.alpha,F_o.beta,F_o.eta,F_o.minScore,F_o.maxBoxes,...
      F_o.edgeMinMag,F_o.edgeMergeThr,F_o.clusterMinMag,...
      F_o.maxAspectRatio,F_o.minBoxArea,F_o.gamma,F_o.kappa,I_bbs(:,1:4));
    % Append the scores
    I_bbs = [I_bbs flowscore];
    
    % Append all the proposals total 2000
    prop_bbs = [I_bbs;F_bbs];
    
    % Sort based on the appearance scores
    % [~, sortidx] = sort(prop_bbs(:,5),'descend');
    % prop_bbs = prop_bbs(sortidx,:);

end