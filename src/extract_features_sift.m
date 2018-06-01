function features = extract_features_sift(im, fg_candidates)

% Extract SIFT features from each of the selected proposal region of the
% image.
%
% USAGE
%   features = extract_features(im, bboxes) 
%
% INPUTS
%   im - input image 
%   bboxes - topmost selected proposal regions. 
%
% OUTPUTS
%   features - features of all the proposals [size(bboxes,1), 10000]

    % load the codebook
	load('./external/data/dsift_dict.mat');
    
    % compute the sift feature points and descriptor.
    [f, d] = dsift_wrapper(im);
    
    d = double(d);
    d = d ./ (repmat(sum(d,1), size(d,1), 1) + eps); % L1 NORM
    d = d ./ (repmat(sqrt(sum(d.^2,1)), size(d,1), 1) + eps); % L2 NORM
    [~, quant_d] = min(pdist2(d', centers'), [], 2);
    d_location = f;
    d_words = quant_d';

    % compute SPM features
    features = zeros(size(fg_candidates,1), 10000);
    im_maxsize = max(d_location, [], 2);

    % loop through boxes
    for j = 1:size(features,1)
        box = fg_candidates(j,:);
        box = RectLTWH2LTRB(box);
        box = round(box);
        % generate image mask
        im_mask = zeros(im_maxsize(1), im_maxsize(2), 'uint8');
        im_mask_gridx = floor(linspace(box(1), box(3), 4));
        im_mask_gridy = floor(linspace(box(2), box(4), 4));
        im_mask_gridind = 1;
        for mx = 1:3
            for my = 1:3
                im_mask(im_mask_gridx(mx):im_mask_gridx(mx+1), im_mask_gridy(my):im_mask_gridy(my+1)) = im_mask_gridind;
                im_mask_gridind = im_mask_gridind + 1;
            end
        end
        
        % compute histogram representation
        box_sifthist = zeros(10, 1000);
        for k = 1:numel(d_words)
            loc_temp = d_location(:,k);
            if im_mask(loc_temp(1), loc_temp(2)) > 0
                box_sifthist(im_mask(loc_temp(1), loc_temp(2)), d_words(k)) = box_sifthist(im_mask(loc_temp(1), loc_temp(2)), d_words(k)) + 1;
                box_sifthist(10, d_words(k)) = box_sifthist(10, d_words(k)) + 1;
            end
        end
        features(j,:) = box_sifthist(:)';
    end

    % normalize histogram
    features = features ./ repmat(sum(features,2) + eps, 1, size(features,2));
end

function [f,d] = dsift_wrapper(im)

	% read in image
	grayim = single(rgb2gray(im));

	% run feat
	binSize = 8;
	magnif = 3;
	Is = vl_imsmooth(grayim, sqrt((binSize/magnif)^2 - .25));
	[f,d] = vl_dsift(grayim, 'size', binSize, 'step', 4);

end


