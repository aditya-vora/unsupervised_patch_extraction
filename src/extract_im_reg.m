function im_reg = extract_im_reg( I, prop )
    
    % Get the image region from the proposal
    
    % prop = LTWH 
    prop = RectLTWH2LTRB(prop);
    im_reg = I(prop(2):prop(4),prop(1):prop(3),:);
end

