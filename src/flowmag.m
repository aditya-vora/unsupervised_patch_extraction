function flowI=flowmag(flowmap)
flowI=sqrt(sum(flowmap.^2,3));
flowIvec=flowI(:);
flowIvec=(flowIvec-min(flowIvec))/(max(flowIvec)-min(flowIvec))*255;
flowI=uint8(repmat(reshape(flowIvec,size(flowI)),[1 1 3]));