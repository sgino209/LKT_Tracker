% Created by Shahar Gino, at Feb-2015
clear all; close all; clc;
tic

%% User interface:
LastFrameIdx = Inf;
DistanceTHR = 10;

[FileName,PathName] = uigetfile('../Input/*.*');
InputVideo  = fullfile(PathName,FileName);
OutputVideo = fullfile(PathName,'../Output/LKT_result.avi');

%% 1.Create System objects for reading and displaying video and for drawing a bounding box of the object.
videoFileReader = vision.VideoFileReader(InputVideo);
videoFileWriter = vision.VideoFileWriter(OutputVideo,'FrameRate',videoFileReader.info.VideoFrameRate);
videoFileWriter.VideoCompressor = 'MJPEG Compressor';
videoPlayer = vision.VideoPlayer('Position', [100, 100, 680, 520]);
markerInserter = vision.MarkerInserter('Shape','Plus','BorderColor','White');
cornerDetector = vision.CornerDetector('Method','Minimum eigenvalue (Shi & Tomasi)');

%% 2. Get ROI target from user:
frame = step(videoFileReader);
points = get_points_from_user(frame, cornerDetector);

%% 3. Initialize the tracker:
LKT_tracker(frame, points, [DistanceTHR, 1, 0, 0]);  %Init

%% 4. Track and display the points in each video frame:
idx = 0;
while ~isDone(videoFileReader)
  frame = step(videoFileReader);
  [points, TrackingStatus] = LKT_tracker(frame, points, [DistanceTHR, 0, 0, 0]);  %Track
  if TrackingStatus == -1
      points = get_points_from_user(frame, cornerDetector);
      LKT_tracker(frame, points, [DistanceTHR, 0, 1, 0]); %SET
  end
  out_pre = step(markerInserter, frame, points);
  out = markROI(out_pre,points);
  
  %% Prepare for next frame:
  step(videoPlayer, out);
  step(videoFileWriter, out);
  idx = idx+1;
  
  if (idx == LastFrameIdx)
      break;
  end
end

%% 5. Release the video reader and player.
release(videoPlayer);
release(videoFileReader);
release(videoFileWriter);
release(markerInserter);
release(cornerDetector);
LKT_tracker(frame, points, [DistanceTHR, 0, 0, 1]); %Release

fprintf('Completed!\nRuntime = %.02f sec\n', toc);