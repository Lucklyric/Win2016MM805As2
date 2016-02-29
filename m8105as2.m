clear;close;
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
stats = regionprops('table',reBWC,'Area',...
    'Centroid','Perimeter');

%Part (e)