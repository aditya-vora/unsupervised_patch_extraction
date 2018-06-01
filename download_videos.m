%clc; clear; close all;

addpath(genpath('external/toolbox/')); 
addpath('external/edges/');
addpath('external/OpticalFlow/mex');
addpath('src/');
run('external/vlfeat-0.9.20/toolbox/vl_setup.m')
params;

%load('list.mat');

%select = randperm(length(list),10000);
%curr_list = list(select);

for fileidx = 857:length(curr_list)
  
    url = curr_list{fileidx};
    [~, filename, ~] = fileparts(url);
    
    %system(['wget ',url,' --no-check-certificate -P ',saveinfo.video_path]);
    
    if ~exist(fullfile(saveinfo.video_path,filename))
        system(['wget ',url,' --no-check-certificate -P ',saveinfo.video_path]);
    end
    
    if length(dir(saveinfo.video_path)) > 2
        mkdir(fullfile(saveinfo.frames_path, filename));
        system(['ffmpeg -i ',fullfile(saveinfo.video_path,filename), ' ',fullfile(saveinfo.frames_path,filename,[filename,'_frame%05d.jpg']), ' -hide_banner']);        
    end
    
    if length(dir(saveinfo.video_path)) > 2
        image_list = dir([fullfile(saveinfo.frames_path, filename), '/', '*.jpg']);
        I = imread([fullfile(saveinfo.frames_path, filename), '/', image_list(1).name]);
        H = size(I,1);
        W = size(I,2);
        if (H == 720 && W == 1280) || (H == 1080 && W == 1920)
            %system(['sudo rm -r ',fullfile(saveinfo.frames_path,filename,'*')]);
            system(['sudo rm -r ',fullfile(saveinfo.video_path,'*')]);
            continue;
        else
            system(['sudo rm -r ',fullfile(saveinfo.frames_path,filename)]);
        end
        system(['sudo rm -r ',fullfile(saveinfo.video_path,'*')]);
    end
    
end

list(select) = [];
save('list.mat','list');