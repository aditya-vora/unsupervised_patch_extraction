function flow_images = compute_optical_flow(frame_pairs, flowOpts)

% Function to compute the optical flow from the frame pairs
%
% INPUT: 
% frame_pairs - Cell array containing structs of frames with curr_frame and
% next_frame fields
% flowOpts - options to compute optical flow 
%
% OUTPUT: 
% flow_images - returns a cell array containing flow magnitude images.

% Get the paras
para = [flowOpts.alpha, flowOpts.ratio, flowOpts.minWidth, flowOpts.nOuterFPIterations,flowOpts.nInnerFPIterations,flowOpts.nSORIterations];

% preallocate the flow containers
vx = cell(1,length(frame_pairs));
vy = cell(1,length(frame_pairs));


% Computes optical flow in parallel
parfor i=1:length(frame_pairs)
    frame_pair = frame_pairs{i};
    [vx{i},vy{i},~] = Coarse2FineTwoFrames(frame_pair.curr_frame,frame_pair.next_frame,para);
end

% Compute the flow magnitude images.
flow_images = cell(1,length(frame_pairs));

for i = 1:length(frame_pairs)
    flowimg(:,:,1) = vx{i};
    flowimg(:,:,2) = vy{i};
    flow_images{i} = flowmag(flowimg);
end

end

