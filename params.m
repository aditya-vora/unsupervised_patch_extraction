
%% File contains the parameter settings of all the parameters used by the algorithm at all stages.

% set up proposal model
propModel=load('external/edges/models/forest/modelBsds'); propModel=propModel.model;
propModel.opts.multiscale=0; propModel.opts.sharpen=2; propModel.opts.nThreads=4;

% params for computing object proposals
propOpts = edgeBoxes;
propOpts.alpha = .65;     
propOpts.beta  = .75;     
propOpts.minScore = .01;  
propOpts.maxBoxes = 500;  % set max number of proposals


% params for computing optical flow between two consecutive frames.
flowOpts.alpha = 0.012;
flowOpts.ratio = 0.75;
flowOpts.minWidth = 20;
flowOpts.nOuterFPIterations = 7;
flowOpts.nInnerFPIterations = 1;
flowOpts.nSORIterations = 30;

% params for saving information
saveinfo.video_path = './data/video_dump';
saveinfo.frames_path = './data/frames_dump';
saveinfo.shots_path = './data/shots_dump';
saveinfo.unsup_patches_path = './data/unsup_patches';

% params for dividing video frames into different shots based on scene
% transitions. 
frameSelOpts.MeanUpLimit = 200;
frameSelOpts.MeanDownLimit = 50;
frameSelOpts.corrThresh = 0.1;
frameSelOpts.shotlenThresh = 0.2;


% params for extracting the object candidates.
extObjOpts.numTopRegs = 15; 
extObjOpts.NS = 10;
%extObjOpts.gamma = 1 / sqrt(10000);