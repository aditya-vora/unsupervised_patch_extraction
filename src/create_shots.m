function shots = create_shots(video_path, shotOpts)

% Detect shots in the video based on the scene transitions.
%
% USAGE
% shots_path = create_shots( frames_path, ShotOpts )
%
% INPUTS
%  frames_path - path where frames are stored.
%  ShotOpts    - options for creating shots.
%                1) MeanUpLimit = upper threshold of mean of an image.
%                2) MeanDownLimit = lower threshold of mean of an image.
%                3) corrThresh = correlation threshold. 
% OUTPUTS
%  shots_path - list of paths where the shot frames are stored.

% get the list of all frames.
frames_list = dir(fullfile(video_path,'*.jpg'));

counter = 0;
sel_frames_list = struct;

% remove frames that do not obey the shot condition
for frameidx = 1:length(frames_list)
    curr_frame_path = fullfile(video_path, frames_list(frameidx).name);
    %next_frame_path = fullfile(frames_path, frames_list(frameidx+1).name);

    curr_frame = imread(curr_frame_path);
    %next_frame = imread(next_frame_path);

    mean_curr_frame = mean(curr_frame(:)); 
    %corr_curr_next_frame = corr2(rgb2gray(curr_frame), rgb2gray(next_frame));
 
    if mean_curr_frame > shotOpts.MeanDownLimit && mean_curr_frame < shotOpts.MeanUpLimit %&& corr_curr_next_frame > shotOpts.corrThresh
        counter = counter + 1;
        %sel_frames_list(counter).name = frames_list(frameidx).name;
        sel_frame_idxs(counter) = frameidx;
    end
end

shot_len_thresh = floor(shotOpts.shotlenThresh*length(frames_list)); % should be a function of number of frames in the video.
if counter > 0
    shotsidxs = splitvec(sel_frame_idxs,'consecutive');
    idx = 0;

    for i = 1:length(shotsidxs)
        shot_vec = shotsidxs{i};    
        if length(shot_vec)>shot_len_thresh
            idx = idx + 1;
            shot_path = fullfile(shots_path, ['shot:', num2str(idx)]);
            mkdir(shot_path);
            shot_path_list(idx).path = shot_path;
            for j = 1:length(shot_vec)
                framename = frames_list(shot_vec(j)).name; 
                system(['sudo mv ',fullfile(frames_path, framename), ' ', shot_path]);
            end
        end
    end

end


end