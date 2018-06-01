function [frame_pairs,frame_paths] = select_frames(video_path, extObjOpts, frameSelOpts)

    % Function selects appropriate frames from a video that are above the
    % lower and upper mean limit and which have high corelation.
    %
    % INPUT: 
    % video_path - path where the video frames are stored.
    % extObjOpts - options to extract objects from the frame 
    % shotOpts - options to set the criteria for selecting frames.

    % OUTPUT: 
    % frame_pairs - cell containing all the selected frames from the video
    % and its next frame.
    % frame_path - path of the selected frames.

    % Number of frames to select
    % NS = extObjOpts.NS;
    
    % Get the list of frames
    frames_list = dir(fullfile(video_path,'*.jpg'));
    
    % Get the indexes of the selected frames and the next frames
    % currFrameIdxs = floor(linspace(1, length(frames_list)-1, NS));
    % nextFrameIdxs = currFrameIdxs + 1;
   
    frame_pairs = {};
    frame_paths = {};
    counter = 1;
    
    for i=1:length(frames_list)-1
        curr_frame_path = fullfile(video_path, frames_list(i).name);
        next_frame_path = fullfile(video_path, frames_list(i+1).name);
        curr_frame = imread(curr_frame_path);
        next_frame = imread(next_frame_path);
        mean_curr_frame = mean(curr_frame(:));
        corr_curr_next_frame = corr2(rgb2gray(curr_frame), rgb2gray(next_frame));
        if mean_curr_frame > frameSelOpts.MeanDownLimit && mean_curr_frame < frameSelOpts.MeanUpLimit && corr_curr_next_frame > frameSelOpts.corrThresh
            frame_pair = struct;
            frame_pair.curr_frame = curr_frame;
            frame_pair.next_frame = next_frame;
            frame_pairs{counter} = frame_pair;
            frame_paths{counter} = curr_frame_path;
            counter = counter + 1;
        end
    end
    
    % loop through the frames
%     for i=1:NS
%         
%         % Read the current frame and the next frame
%         curr_frame_path = fullfile(video_path, frames_list(currFrameIdxs(i)).name);
%         next_frame_path = fullfile(video_path, frames_list(nextFrameIdxs(i)).name);
%         curr_frame = imread(curr_frame_path);
%         next_frame = imread(next_frame_path);
%         
%         % Scale the frame appropriately
%         H = size(curr_frame,1);
%         W = size(curr_frame,2);
%         
%         if (H == 720 && W == 1280) 
%             curr_frame = imresize(curr_frame,0.25);
%             next_frame = imresize(next_frame,0.25);
%         else 
%             curr_frame = imresize(curr_frame,1/6);
%             next_frame = imresize(next_frame,1/6);
%         end
%         
%         % Compute the mean and correlation
%         mean_curr_frame = mean(curr_frame(:));
%         corr_curr_next_frame = corr2(rgb2gray(curr_frame), rgb2gray(next_frame));
%         
%         % Check if mean and corelation conditions are satisfied
%         if mean_curr_frame > frameSelOpts.MeanDownLimit && mean_curr_frame < frameSelOpts.MeanUpLimit && corr_curr_next_frame > frameSelOpts.corrThresh
%             frame_pair = struct;
%             frame_pair.curr_frame = curr_frame;
%             frame_pair.next_frame = next_frame;
%             frame_pairs{counter} = frame_pair;
%             frame_paths{counter} = curr_frame_path;
%             counter = counter + 1;
%         end
%     end
    
end