function Coursework()

%Introduction to Image Processing Coursework
%Name: Tan Zhun Xian
%Student ID: 20313854

%The matlab file only displays one image as output. However, the
%intermediate steps and their corresponsing images can be seen by removing
%the brackets on the commented out code.

%Get input image
image = input('Please enter file name: ','s');

%Converting input image to RGB, HSV and YCbCr
currentImage = imread(image);
normalHSV = rgb2hsv(currentImage);
normalYCbCr = rgb2ycbcr(currentImage);

%{
%Showing the input image in RGB, HSV and YCbCr

subplot(1,3,1);
imshow(currentImage);
title('Normal RGB');

subplot(1,3,2);
imshow(normalHSV);
title('Normal HSV');

subplot(1,3,3);
imshow(normalYCbCr);
title('Normal YCbCr');
%}

%Separating the RGB, HSV and YCbCr components of the input image
red = currentImage(:,:,1);
green = currentImage(:,:,2);
blue = currentImage(:,:,3);

hue = normalHSV(:,:,1);
saturation = normalHSV(:,:,2);
value = normalHSV(:,:,3);

luma = normalYCbCr(:,:,1);
blueRelative = normalYCbCr(:,:,2);
redRelative = normalYCbCr(:,:,3);

%ROI masking

%RGB masks
redMask = (red > 70 & red < 140);
greenMask = (green > 100);
blueMask = (blue > 30 & blue < 100);

%Special masks
specialMask = (green > 1.1 * red & green > 1.1 * blue);
specialMask2 = (green > (red + blue) / 1.4);
specialMask3 = (red > 1.5 * blue);

%HSV masks
hueMask = (hue >= 0.2 & hue <= 0.35);
saturationMask = (saturation >= 0.6);
valueMask = (value >= 0.2 & value <= 0.7);

%YCbCr masks
lumaMask = (luma >= 100 & luma <= 150);
blueRelativeMask = (blueRelative >= 60 & blueRelative <= 121);
redRelativeMask = (redRelative >= 100 & redRelative <= 125);

%{
%Displaying all the masks

figure();

subplot(4, 3, 1);
imshow(redMask, []);
title('Red Mask');

subplot(4, 3, 2);
imshow(greenMask, []);
title('Green Mask');

subplot(4, 3, 3);
imshow(blueMask, []);
title('Blue Mask');

subplot(4, 3, 4);
imshow(specialMask, []);
title('Special Mask');

subplot(4, 3, 5);
imshow(specialMask2, []);
title('Special Mask 2');

subplot(4, 3, 6);
imshow(specialMask3, []);
title('Special Mask 3');
impixelinfo;

subplot(4, 3, 7);
imshow(hueMask, []);
title('Hue Mask');

subplot(4, 3, 8);
imshow(saturationMask, []);
title('Saturation Mask');

subplot(4, 3, 9);
imshow(valueMask, []);
title('Value Mask');

subplot(4, 3, 10);
imshow(lumaMask, []);
title('Luma Mask');

subplot(4, 3, 11);
imshow(blueRelativeMask, []);
title('Blue Relative Mask');

subplot(4, 3, 12);
imshow(redRelativeMask, []);
title('Red Relative Mask');
%}

% Combining special mask 1, special mask 2, blue relative mask and red
% relative mask to produce the original mask
originalMask = uint8(specialMask & specialMask2 & blueRelativeMask & redRelativeMask);

%Removing connected components with less than 400 pixels in the mask
removedMask = bwareaopen(originalMask,400);

%Morphologically closing the mask
closedMask = imclose(removedMask,strel('disk',4));

%Using the mask on original image to produce ROI
closedrgbImage = uint8(zeros(size(closedMask))); % Initialize
closedrgbImage(:,:,1) = currentImage(:,:,1) .* uint8(closedMask);
closedrgbImage(:,:,2) = currentImage(:,:,2) .* uint8(closedMask);
closedrgbImage(:,:,3) = currentImage(:,:,3) .* uint8(closedMask);

%{
%Displaying the mask in each step

figure();

subplot(2, 2, 1);
imshow(originalMask, []);
title('Original Mask');

subplot(2, 2, 2);
imshow(removedMask, []);
title('Removed Mask');

subplot(2, 2, 3);
imshow(closedMask, []);
title('Closed Mask');

subplot(2, 2, 4);
imshow(closedrgbImage);
title('Closed Original Image');
%}

%Unsharp masking the ROI
leaves = rgb2gray(closedrgbImage);
enhanced = imsharpen(leaves,'Radius',0.5,'Amount',1.5);
I = enhanced;

%Calculating gradient magnitude
gmag = imgradient(I);

%{
%Displaying original, sharpened image and gradient magnitude

figure();

subplot(1,3,1);
imshow(leaves);
title('Original Image')

subplot(1,3,2);
imshow(I);
title('Sharpened Image');

subplot(1,3,3);
imshow(gmag,[])
title('Gradient Magnitude')
%}


%Eroding and reconstructing image
Ie = imerode(I,strel('disk',3));
Iobr = imreconstruct(Ie,I);

%Dilating and reconstructing image
Iobrd = imdilate(Iobr,strel('disk',3));
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

%{
%Displaying Opening-by-Reconstruction and Opening-Closing by Reconstruction

figure();

subplot(1,2,1);
imshow(Iobr)
title('Opening-by-Reconstruction')

subplot(1,2,2);
imshow(Iobrcbr)
title('Opening-Closing by Reconstruction')
%}

%Calculating regional maxima
fgm = imregionalmax(Iobrcbr);

%Overlay regional maxima on original image
I2 = labeloverlay(I,fgm);

%Modifying regional maxima for 1st and 2nd image
fgm2 = imclose(fgm,strel('disk',3));
fgm3 = imerode(fgm2,strel(ones(2,2)));
fgm4 = bwareaopen(fgm3,20);

%Modifying regional maxima for 3rd image
if(bwconncomp(fgm4).NumObjects > 12)
    fgm2 = imclose(fgm,strel('disk',7));
    fgm3 = imerode(fgm2,strel(ones(2,2)));
    fgm4 = bwareaopen(fgm3,150);
end

%Overlay modified regional maxima on original image
I3 = labeloverlay(I,fgm4);

%Calculating background by binarizing image
bw = imbinarize(Iobrcbr);

%Getting watershed ridge lines
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;

%Perform watershed on image
gmag2 = imimposemin(gmag, bgm | fgm4);
L = watershed(gmag2);

%Superimpose markers and boundaries on original image
labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(I,labels);

%{
%Displaying the steps in Marker-Based Watershed Segmentation

figure();

subplot(3,2,1);
imshow(fgm)
title('Regional Maxima of Opening-Closing by Reconstruction')

subplot(3,2,2);
imshow(I2)
title('Regional Maxima Superimposed on Original Image')

subplot(3,2,3);
imshow(I3)
title('Modified Regional Maxima Superimposed on Original Image')

subplot(3,2,4);
imshow(bw)
title('Thresholded Opening-Closing by Reconstruction')

subplot(3,2,5);
imshow(bgm)
title('Watershed Ridge Lines')

subplot(3,2,6);
imshow(I4)
title('Markers and Object Boundaries Superimposed on Original Image')
%}

%Display coloured label matrix
Lrgb = label2rgb(L,'jet','w','shuffle');

%Creating final mask for coursework
colourMask = (enhanced ~= 0);
whiteMask = ~(Lrgb(:,:,1) == 255 & Lrgb(:,:,2) == 255 & Lrgb(:,:,3) == 255);
finalMask = colourMask & whiteMask;
finalMask = uint8(bwareaopen(finalMask,200));

%Use final mask on coloured label matrix to produce final image
finalImage = uint8(zeros(size(finalMask)));
finalImage(:,:,1) = Lrgb(:,:,1) .* finalMask;
finalImage(:,:,2) = Lrgb(:,:,2) .* finalMask;
finalImage(:,:,3) = Lrgb(:,:,3) .* finalMask;

%{
%Displaying results of watershed, final mask and results

figure();

subplot(2,2,1);
imshow(Lrgb)
title('Colored Watershed Label Matrix')

subplot(2,2,2);
imshow(I)
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.3;
title('Colored Labels Superimposed Transparently on Original Image')

subplot(2,2,3);
imshow(finalMask,[]);
title('Final Mask');

subplot(2,2,4);
imshow(finalImage);
title('Final Image');
%}

%Displaying final results
figure('Name','Final Result');
imshow(finalImage);
title('Final Image');

end