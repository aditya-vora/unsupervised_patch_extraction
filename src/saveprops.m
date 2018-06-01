function saveprops(shot_fg_candidates, fg_patches, bg_patches)
    fg_counter = 0; 
    bg_counter = 0; 
    for i=1:length(shot_fg_candidates)
        framepath = shot_fg_candidates(i).framepath;
        I = imread(framepath);
        fg_patch = fg_patches(i,:);
        bg_patch = bg_patches(i,:);
        [~, id, ~] = fileparts(framepath);
        imreg = extract_im_reg(I, fg_patch);
        imreg = imresize(imreg, [227,227]);
        imwrite(imreg, fullfile(saveinfo.unsup_patches_path, 'fg_patches', [id,num2str(fg_counter),'.jpg']));
        fg_counter = fg_counter + 1; 
        imreg = extract_im_reg(I, bg_patch);
        imreg = imresize(imreg, [227,227]);
        imwrite(imreg, fullfile(saveinfo.unsup_patches_path, 'bg_patches', [id, num2str(bg_counter),'.jpg']));
        bg_counter = bg_counter + 1;
        
    end
end

