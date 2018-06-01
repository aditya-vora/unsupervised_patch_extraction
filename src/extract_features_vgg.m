function feats = extract_features_vgg(I,props)

% Compute discriminative features from the pre-trained VGG-16 ImageNet
% model. All the candidate windows are forward passed to the VGGNet and
% feature descriptor from the final FC Layer is extracted. 

% Requires the mathconvnet library to do this.
% Load the model to compute the features of the segments.

% INPUT: 
% I - Input Image.
% props - Filtered Object Proposals. 

% OUTPUT: 
% feats - VGG features for each of the filtered proposals.

% Code written by Aditya Vora, 2017, IIT Gandhinagar. 


% Load MatConvNet Library
run('./external/matconvnet-1.0-beta25/matlab/vl_setupnn.m');

% Load the VGG model
net = load('./external/imagenet-vgg-verydeep-16.mat');
net = vl_simplenn_tidy(net) ;

% Loop through the proposals and extract the VGG features and normalize it
% with L2 norm.
for j=1:size(props,1)
    prop = props(j,1:4);
    im_reg = extract_im_reg(I,prop);
    im_ = single(im_reg); 
    im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
    avg = net.meta.normalization.averageImage;
    for i=1:3
        im_(:,:,i) = im_(:,:,i) - avg(:,:,i) ;
    end
    res = vl_simplenn(net, im_) ;
    feat = res(33).x;
    feat = squeeze(feat);
    feats(j,:) = feat./norm(feat,2);
end

end