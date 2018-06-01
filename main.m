%% Main script to extract foreground and background patches from the video frames.
% Script extracts a url from the yfcc video dataset url list and then
% downloads the video, preprocess the frames to extract appropriate shots
% from the video and then processes each shot seperately to extract the foreground and
% background patches from each frame, in a fully unsupervised fashion.

clc; clear; close all; 

% addpath of neccessary libraries
addpath(genpath('external/toolbox/')); 
addpath('external/edges/');
addpath('external/OpticalFlow/mex');
addpath('src/');
run('external/vlfeat-0.9.20/toolbox/vl_setup.m')
addpath('/home/aditya-tyco/caffe/matlab');

%caffe.set_mode_gpu();
%gpu_id = 0; 
%caffe.set_device(gpu_id);
%net_weights = ['./external/models/VGG_ILSVRC_16_layers.caffemodel'];
%net_model = ['./external/models/VGG_ILSVRC_16_layers_deploy.prototxt'];
%net = caffe.Net(net_model, net_weights, 'test');

% set the params
params;

total_videos = dir(saveinfo.frames_path);
%%
for fileidx = 0:length(total_videos)
    fprintf('Index: %d\n',fileidx);
    tic;
    video_path = fullfile(saveinfo.frames_path,total_videos(fileidx).name);
    [~,fid,~] = fileparts(video_path);
    
    fprintf('Processing video id: %s\n', fid);
    
    [frame_pairs,frame_paths] = select_frames(video_path, extObjOpts, frameSelOpts);
    
    fprintf('Number of frames selected: %d\n', numel(frame_pairs));
       
    if ~isempty(frame_pairs)
      fprintf('Computing optical flow frames...\n');
      frame_flows = compute_optical_flow(frame_pairs, flowOpts);

      fprintf('Computing object proposals for all frames...\n');
      frame_props = compute_proposals(frame_pairs, frame_flows, propModel, propOpts);

      if isempty(frame_props)
        continue;
      end
      
      
      
      fprintf('Extracting fg and bg patches from all the frames...\n');
      [fg_patches, bg_patches] = extract_fg_bg_patches(frame_pairs, frame_props, frame_paths, net, extObjOpts, saveinfo);
    end
   %system(['sudo rm -r ',video_path]);
   toc;
end























% for fileidx = 1:length(curr_list)
%     tic;
%     url = curr_list{fileidx};
%     [~, filename, ~] = fileparts(url);
%     
%     if ~exist(fullfile(saveinfo.video_path,filename))
%         system(['wget ',url,' --no-check-certificate -P ',saveinfo.video_path]);
%     end
%     
%     if length(dir(saveinfo.video_path)) > 2
%         if isempty(dir(fullfile(saveinfo.frames_path,'*.jpg')))
%             system(['ffmpeg -i ',fullfile(saveinfo.video_path,filename), ' ',fullfile(saveinfo.frames_path, [filename,'_frame%05d.jpg']), ' -hide_banner']);
%         end
%         
%         fprintf('Creating shots from video...\n');
%         create_shots(saveinfo.frames_path, saveinfo.shots_path, shotOpts);
%         
%         shots_path_list = dir(saveinfo.shots_path);
%         if length(shots_path_list)>2
%             fprintf('Extracting fg and bg patches...\n');
%             for i=3:length(shots_path_list)
%                 shot_path = fullfile(saveinfo.shots_path,shots_path_list(i).name);
%                 shot_frames = dir([shot_path,'/','*.jpg']);
%                 extract_fg_bg_patches(shot_path, shot_frames, propModel, propOpts, flowOpts, extObjOpts, saveinfo);
%             end
% 
%             if ~isempty(saveinfo.shots_path)
%                 system(['sudo rm -r ',fullfile(saveinfo.shots_path,'*')]);
%             end
%         end
%         
%         if ~isempty(saveinfo.frames_path)
%             system(['sudo rm -r ',fullfile(saveinfo.frames_path,'*')]);
%         end
% 
%         if ~isempty(saveinfo.video_path)
%             system(['sudo rm -r ',fullfile(saveinfo.video_path,'*')]);
%         end
%         
%     end
%     toc;
% end



