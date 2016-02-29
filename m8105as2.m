clear;close all;
%Part (a)
%read Image
I = imread('histopath.jpg');
%get red channel
Ir = I(:,:,1);
%display
figure(),
title('Red Channel'),
imshow(Ir);

%Part (b)
%calculate the global treshold
t = graythresh(Ir);

%Part (c)
%generate binary image
BW = im2bw(Ir,t);
%display the image
figure();
imshow(BW);

%Part (d)
%generate a complement of BW
BWC = imcomplement(BW);
figure,
imshow(BWC);

%Part (e)
%remove small noise components with morphological opening
%create a disk-shape
se = strel('disk',5);
moBWC = imopen(BWC,se);
figure,imshow(moBWC);

%Part (f)
%remove area < 200 pixels
cc = bwconncomp(moBWC);
area = regionprops(cc,'Area');
L = labelmatrix(cc);
reBWC = ismember(L,find([area.Area]>=200));
figure,imshow(reBWC);

%Part (g)
%compute the area,centroid and perimeters of connected regions
cc = bwconncomp(reBWC);
L = labelmatrix(cc);
stats = regionprops('table',reBWC,'Area',...
    'Centroid','Perimeter');

%Part (e)
data = regionprops(reBWC,'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid','PixelList');

elli = zeros(1,length(data));
elliarea = elli;
for k = 1:length(data)
   
    %get major and minor axis length
    a = data(k).MajorAxisLength/2;
    b = data(k).MinorAxisLength/2;
    %ellipse area
    AreaEllipse = pi * a * b;
    
    xbar = data(k).Centroid(1);
    ybar = data(k).Centroid(2);
    theta = pi*(data(k).Orientation)/180;
    
    %for loop region points
    points = data(k).PixelList;
    %counter for points inside the ellipse
    count = 0;
    for i = 1 : length(points)
        X = (points(i,1) - xbar)*cos(theta) + (points(i,2) - ybar)*sin(theta);
        Y = -(points(i,1) - xbar)*sin(theta) + (points(i,2) - ybar)*cos(theta);
        %check the if the points in ellipse
        if (X^2/a^2+Y^2/b^2) <= 1 
            count = count + 1;
        end
    end
    elli(k) = count/AreaEllipse;
end
stats.Ellipticity = elli';
disp(stats);
