% Amarachi Akunna Onyekachi
% akunna1@live.unc.edu
% 06/15/2020
% PA8Part2.m
%
% Records video of LEDs on moving joints and calculates their centroid

clc
clear
close all

warning('off')

%% Declarations
% Video information
vidFile = 'Akunna_AmaraLED.mp4'; % with extension
filenameString1 = 'centroid_joints_akunnaPart2.avi'; % Output video name
filenameString2 = 'joined_joints_akunnaPart2.avi'; % Output video name
desiredFrameRate = 30;

% Load video
vid = VideoReader(vidFile);    % reads in .mp4 file
frameRate = vid.FrameRate;
vid_duration = vid.Duration;
total_frames = frameRate * vid_duration;
vid_width = vid.Width;
vid_height = vid.Height;
vid_bits = vid.BitsPerPixel;
frameStart = floor(3.316*frameRate);
frameStop = floor(8.241*frameRate);

% Cropping rectangle dimension
crop_x_start = 250; % x-coordinate to begin cropping image
crop_y_start = 290; % y-coordinate to begin cropping image
crop_x_size = 1670; % shifts crop_x_start by crop_x_size along x-axis
crop_y_size = 500; % shifts crop_y_start by crop_y_size along y-axis

% Threshold
rLED_Th_range = [120,255;0,82;50,160]; % LED color red threshold range
gLED_Th_range = [0,90;90,255;90,200]; % LED color green threshold range
bLED_Th_range = [0,61;15,210;200,255]; % LED color blue threshold range


%% Threshold Video
n = 1; % place holder for centroid index
vidObj = VideoWriter(filenameString1); % include extension in string
vidObj.FrameRate = desiredFrameRate; % set frame rate (e.g., 20)
open(vidObj) % opens video for recording 
% Step through each frame 
for k = frameStart:frameStop
    frameSlice = read(vid,k); % loads current frame into frameSlice
    
    % Crop image
    frameSlice_crop = imcrop(frameSlice,...
        [crop_x_start,crop_y_start,crop_x_size,crop_y_size]);
    
    % Creates separate binary(black & white) image array for each LED color
    % using different RGB color ranges for the colors we want to select
    % and later combines them to one array using logical or
    img_arr_bw_r = (frameSlice_crop(:,:,1) > rLED_Th_range(1,1) &...
       frameSlice_crop(:,:,1) < rLED_Th_range(1,2) &...
       frameSlice_crop(:,:,2) > rLED_Th_range(2,1) &...
       frameSlice_crop(:,:,2) < rLED_Th_range(2,2) &...
       frameSlice_crop(:,:,3) > rLED_Th_range(3,1) &...
       frameSlice_crop(:,:,3) < rLED_Th_range(3,2));
    
    img_arr_bw_g = (frameSlice_crop(:,:,1) > gLED_Th_range(1,1) &...
       frameSlice_crop(:,:,1) < gLED_Th_range(1,2) &...
       frameSlice_crop(:,:,2) > gLED_Th_range(2,1) &...
       frameSlice_crop(:,:,2) < gLED_Th_range(2,2) &...
       frameSlice_crop(:,:,3) > gLED_Th_range(3,1) &...
       frameSlice_crop(:,:,3) < gLED_Th_range(3,2));
    
    img_arr_bw_b = (frameSlice_crop(:,:,1) > bLED_Th_range(1,1) &...
       frameSlice_crop(:,:,1) < bLED_Th_range(1,2) &...
       frameSlice_crop(:,:,2) > bLED_Th_range(2,1) &...
       frameSlice_crop(:,:,2) < bLED_Th_range(2,2) &...
       frameSlice_crop(:,:,3) > bLED_Th_range(3,1) &...
       frameSlice_crop(:,:,3) < bLED_Th_range(3,2));
    
    
    % Combines arrays showing the position of each LED color into one
    img_arr_bw = img_arr_bw_r | img_arr_bw_g | img_arr_bw_b;
    
    % Uses custom function centroid to return row and col of centroid
    % of each black and white image array
    [cent_r(2,n),cent_r(1,n)] = Centroid(img_arr_bw_r);
    [cent_g(2,n),cent_g(1,n)] = Centroid(img_arr_bw_g);
    [cent_b(2,n),cent_b(1,n)] = Centroid(img_arr_bw_b);
    
    
    % Display the thresholded image and plot centroid movement dynamically
    % Make sure image and plot are same size, and no change in axes from
    % plot to plot
    centroid_plot_Xmin = 0;
    centroid_plot_Xmax = crop_x_size;
    centroid_plot_Ymin = 0;
    centroid_plot_Ymax = crop_y_size;
    
    figure(1)
    img_reg = subplot(3,1,1);
    imshow(frameSlice_crop)
    title('Color Cropped Image')
    
    img_sp = subplot(3,1,2); % binary image subplot
    imshow(img_arr_bw)
    title('Combined Threshold Image')
    
    % had to include this if function because the red LED was not  bright 
    % enough in some frames, so the if function assigns the previous 
    % calculated centroid as the new one
    if cent_r(1,n) == 0
        cent_r(1,n) = cent_r(1,n-1);
    end
    
    if cent_r(2,n) == 0
        cent_r(2,n) = cent_r(2,n-1);
    end
    
    
    cent_sp = subplot(3,1,3); % centroid subplot
    plot(cent_r(1,:),cent_r(2,:),'r','LineWidth',1.5)
    hold on
    plot(cent_g(1,:),cent_g(2,:),'g','LineWidth',1.5)
    hold on
    plot(cent_b(1,:),cent_b(2,:),'cy','LineWidth',1.5)
    hold on
    plot(cent_r(1,n),cent_r(2,n),'x','MarkerFaceColor','red',...
        'LineWidth',2,"Color",'r');
    hold on
    plot(cent_g(1,n),cent_g(2,n),'x','MarkerFaceColor','green',...
        'LineWidth',2,"Color",'g');
    hold on
    plot(cent_b(1,n),cent_b(2,n),'x','MarkerFaceColor','cyan',...
        'LineWidth',2,"Color",'cy');
    hold off
    title('Joint Centroids')
    axis([centroid_plot_Xmin centroid_plot_Xmax...
        centroid_plot_Ymin centroid_plot_Ymax])
    pbaspect([crop_x_size crop_y_size 1])
    set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse')
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    drawnow
    
    currentFrame = getframe(gcf); % saves plot in variable
    writeVideo(vidObj,currentFrame); % writes frame to video 
    
    n = n + 1;
end
close(vidObj);


vidObj = VideoWriter(filenameString2); % include extension in string
vidObj.FrameRate = desiredFrameRate; % set frame rate (e.g., 20)
open(vidObj) % opens video for recording 

n = 1; % resets place holder for centroid index to 1
for k = frameStart:frameStop
    frameSlice = read(vid,k); % loads current frame into frameSlice
    
    % Crop image
    frameSlice_crop = imcrop(frameSlice,...
        [crop_x_start,crop_y_start,crop_x_size,crop_y_size]);
    
    % The centroids do not have to be calculated again because we have them 
    % saved to different centroid variables, so we can loop through them
    % using the reset index n
    
    
    % Display the thresholded image and plot centroid movement dynamically
    % Make sure image and plot are same size, and no change in axes from
    % plot to plot
    centroid_plot_Xmin = 0;
    centroid_plot_Xmax = crop_x_size;
    centroid_plot_Ymin = 0;
    centroid_plot_Ymax = crop_y_size;
    
    figure(2)
    img_reg = subplot(2,1,1);
    imshow(frameSlice_crop)
    title('Color Cropped Image')
    
    cent_sp = subplot(2,1,2); % centroid joined subplot    
    plot([cent_r(1,n) cent_b(1,n)], [cent_r(2,n) cent_b(2,n)],'Color','r')
    hold on
    plot([cent_b(1,n) cent_g(1,n)], [cent_b(2,n) cent_g(2,n)],'Color','g')
    hold on
    plot(cent_r(1,n),cent_r(2,n),'ro','MarkerFaceColor','red');
    hold on
    plot(cent_b(1,n),cent_b(2,n),'cyo','MarkerFaceColor','cyan');
    hold on
    plot(cent_g(1,n),cent_g(2,n),'go','MarkerFaceColor','green');
    hold off
    title('Joined Joint Centroids')
    axis([centroid_plot_Xmin centroid_plot_Xmax...
        centroid_plot_Ymin centroid_plot_Ymax])
    pbaspect([crop_x_size crop_y_size 1])
    set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse')
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    drawnow
    
    currentFrame = getframe(gcf); % saves plot in variable
    writeVideo(vidObj,currentFrame); % writes frame to video 
    
    n = n + 1;
end

close(vidObj) % closes video 