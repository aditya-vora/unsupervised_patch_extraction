function [rectsLTRB] = RectLTWH2LTRB(rectsLTWH)
rectsLTRB = [rectsLTWH(:,1), rectsLTWH(:,2), rectsLTWH(:,1)+rectsLTWH(:,3)-1, rectsLTWH(:,2)+rectsLTWH(:,4)-1];
end

