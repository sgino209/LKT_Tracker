function out = markROI(frame,points)

out = frame;

[~,ind] = min(points(:,1)); minX = round(points(ind,1));
[~,ind] = max(points(:,1)); maxX = round(points(ind,1));
[~,ind] = min(points(:,2)); minY = round(points(ind,2));
[~,ind] = max(points(:,2)); maxY = round(points(ind,2));

out(minY-3:minY+3, minX-5:maxX+5, 1) = 1; 
out(maxY-3:maxY+3, minX-5:maxX+5, 1) = 1; 
out(minY-5:maxY+5, minX-3:minX+3, 1) = 1; 
out(minY-5:maxY+5, maxX-3:maxX+3, 1) = 1; 