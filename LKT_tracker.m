% Created by Shahar Gino, at Feb-2015
function [points, status] = LKT_tracker(frame, pointsInit, control)

persistent pointTracker

DistanceTHR = control(1);
InitTracker = control(2);
SetTracker = control(3);
ReleaseTracker = control(4);

points = pointsInit;
status = 0;

%% Initialize tracker:
if InitTracker
    pointTracker = vision.PointTracker('MaxBidirectionalError', 1);
    initialize(pointTracker, pointsInit, frame);

%% Release tracker:
elseif SetTracker
    setPoints(pointTracker, pointsInit);
    
%% Release tracker:
elseif ReleaseTracker
    release(pointTracker);
    
%% Track the ROI:
else
    [points, validity, ~] = step(pointTracker, frame);
    if sum(validity) < DistanceTHR
        status = -1;
    end
    points = points(validity, :);
end