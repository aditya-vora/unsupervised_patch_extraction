function propDisplay(img, topBboxs)
    imshow(img);
    hold on;
    for i=1:size(topBboxs,1)
        rectangle('Position', topBboxs(i,1:4), 'EdgeColor', 'r');
        pause(1);
    end
end