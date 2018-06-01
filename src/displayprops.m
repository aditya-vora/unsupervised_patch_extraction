function displayprops(shot_fg_candidates, fg_patches, bg_patches)
    for i = 1:length(shot_fg_candidates)
        imgpath = shot_fg_candidates(i).framepath;
        I = imread(imgpath);
        fg_patch = fg_patches(i,:);
        bg_patch = bg_patches(i,:);
        figure; imshow(I); hold on; rectangle('Position', fg_patch, 'EdgeColor','r'); rectangle('Position', bg_patch, 'EdgeColor','g'); 
        pause(1);
    end
end

