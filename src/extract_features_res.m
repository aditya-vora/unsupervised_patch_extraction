function feats = extract_features_res(frame, fg_candidates, net)

% Extract ResNet features from all the proposals 
%
% INPUTS:
% frame - RGB frame of the video
% fg_candidates - selected object proposals [numTopObjs x 4] [x y w h]
%
% OUTPUTS:
% feats - L2 normalized ResNet features from pool5 layer of the CNN [numTopObjs x 2048]

% Set the caffe variables 
%net_weights = ['./external/models/ResNet-50-model.caffemodel'];
%net_model = ['./external/models/ResNet-50-deploy.prototxt'];


d = load('./external/models/ilsvrc_2012_mean.mat');
mean_data = d.mean_data;

%feats = zeros(size(fg_candidates,1),2048);

feats = zeros(size(fg_candidates,1),4096);

% Loop through all the object proposals
for j=1:size(fg_candidates,1)
    fg_cand = fg_candidates(j,:);
    im_reg = extract_im_reg(frame,fg_cand);
    im_reg = permute(im_reg, [2, 1, 3]); 
    im_reg = single(im_reg); 
    im_reg = imresize(im_reg, [256 256], 'bilinear');
    im_reg = im_reg - mean_data;
    im_reg = imresize(im_reg, [224,224]);
    net_ip = {im_reg};
    scores = net.forward(net_ip);
    %output_pool5 = net.blobs('pool5').get_data();
    output_fc7 = net.blobs('fc7').get_data();
    feat = squeeze(output_fc7);
    feats(j,:) = feat / norm(feat);
end

