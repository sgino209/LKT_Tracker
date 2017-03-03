% Created by Shahar Gino, at Feb-2015
function points = get_points_from_user(frame,cornerDetector)

%% Get user's DOI selection:
h=helpdlg('Please select a target ROI to be tracked');
uiwait(h);
h=figure; imshow(frame); 
ROI=round(getPosition(imrect));
close(h);

%% Detect interest points in the object region
release(cornerDetector);
points = double( step(cornerDetector, rgb2gray(imcrop(frame, ROI))) );

%% Translate the coordinates of the detected points so they are relative to the full video frame, not the ROI.
points(:, 1) = points(:, 1) + ROI(1);
points(:, 2) = points(:, 2) + ROI(2);