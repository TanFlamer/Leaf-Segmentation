
image1 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant001.png");
image2 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant002.png");
image3 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant003.png");

currentImage = image3;
normalHSV = rgb2hsv(currentImage);
normalYCbCr = rgb2ycbcr(currentImage);

subplot(1,3,1);
imshow(currentImage);
title('Normal RGB');
impixelinfo;

subplot(1,3,2);
imshow(normalHSV);
title('Normal HSV');
impixelinfo;

subplot(1,3,3);
imshow(normalYCbCr);
title('Normal YCbCr');
impixelinfo;

red = currentImage(:,:,1);
green = currentImage(:,:,2);
blue = currentImage(:,:,3);

hue = normalHSV(:,:,1);
saturation = normalHSV(:,:,2);
value = normalHSV(:,:,3);

luma = normalYCbCr(:,:,1);
blueRelative = normalYCbCr(:,:,2);
redRelative = normalYCbCr(:,:,3);

redMask = (red > 70 & red < 140);
greenMask = (green > 100);
blueMask = (blue > 30 & blue < 100);

specialMask = (green > 1.1 * red & green > 1.1 * blue);
specialMask2 = (green > (red + blue) / 1.4);
specialMask3 = (red + blue > green);

hueMask = (hue >= 0.2 & hue <= 0.35);
saturationMask = (saturation >= 0.3 & saturation <= 0.6);
valueMask = (value >= 0.2 & value <= 0.7);

lumaMask = (luma >= 100 & luma <= 150);
blueRelativeMask = (blueRelative >= 60 & blueRelative <= 121);
redRelativeMask = (redRelative >= 100 & redRelative <= 125);

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

% Combine the masks to find where all 3 are "true."
originalMask = uint8(specialMask & specialMask2 & blueRelativeMask & redRelativeMask);

figure();
subplot(3, 2, 1);
imshow(originalMask, []);
title('Original Mask');

maskedrgbImage = uint8(zeros(size(originalMask))); % Initialize
maskedrgbImage(:,:,1) = currentImage(:,:,1) .* originalMask;
maskedrgbImage(:,:,2) = currentImage(:,:,2) .* originalMask;
maskedrgbImage(:,:,3) = currentImage(:,:,3) .* originalMask;

subplot(3, 2, 2);
imshow(maskedrgbImage);
title('Masked Original Image');

removedMask = bwareaopen(originalMask,400);
subplot(3, 2, 3);
imshow(removedMask, []);
title('Removed Mask');

removedrgbImage = uint8(zeros(size(removedMask))); % Initialize
removedrgbImage(:,:,1) = currentImage(:,:,1) .* uint8(removedMask);
removedrgbImage(:,:,2) = currentImage(:,:,2) .* uint8(removedMask);
removedrgbImage(:,:,3) = currentImage(:,:,3) .* uint8(removedMask);

subplot(3, 2, 4);
imshow(removedrgbImage);
title('Removed Original Image');

se = strel('disk',4);
closedMask = imclose(removedMask,se);
subplot(3, 2, 5);
imshow(closedMask, []);
title('Closed Mask');

closedrgbImage = uint8(zeros(size(closedMask))); % Initialize
closedrgbImage(:,:,1) = currentImage(:,:,1) .* uint8(closedMask);
closedrgbImage(:,:,2) = currentImage(:,:,2) .* uint8(closedMask);
closedrgbImage(:,:,3) = currentImage(:,:,3) .* uint8(closedMask);

subplot(3, 2, 6);
imshow(closedrgbImage);
title('Closed Original Image');


leaves = rgb2gray(closedrgbImage);
%enhanced = adapthisteq(leaves);
%enhanced = imsharpen(leaves,'Radius',1.5,'Amount',1.5,'Threshold',0.01);
%enhanced = imadjust(leaves);
enhanced = histeq(leaves);

figure();
I = leaves;

gmag = imgradient(I);
subplot(3,2,1);
imshow(gmag,[])
title('Gradient Magnitude')

se = strel('disk',5);
Io = imopen(I,se);
subplot(3,2,2);
imshow(Io)
title('Opening')

Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
subplot(3,2,3);
imshow(Iobr)
title('Opening-by-Reconstruction')

Ioc = imclose(Io,se);
subplot(3,2,4);
imshow(Ioc)
title('Opening-Closing')

Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
subplot(3,2,5);
imshow(Iobrcbr)
title('Opening-Closing by Reconstruction')

figure();

fgm = imregionalmax(Iobrcbr);
subplot(4,2,1);
imshow(fgm)
title('Regional Maxima of Opening-Closing by Reconstruction')

I2 = labeloverlay(I,fgm);
subplot(4,2,2);
imshow(I2)
title('Regional Maxima Superimposed on Original Image')

%se2 = strel('disk',5);
se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);

fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(I,fgm4);
subplot(4,2,3);
imshow(I3)
title('Modified Regional Maxima Superimposed on Original Image')

bw = imbinarize(Iobrcbr);
subplot(4,2,4);
imshow(bw)
title('Thresholded Opening-Closing by Reconstruction')

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
subplot(4,2,5);
imshow(bgm)
title('Watershed Ridge Lines')

gmag2 = imimposemin(gmag, bgm | fgm4);
L = watershed(gmag2);

labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(I,labels);
subplot(4,2,6);
imshow(I4)
title('Markers and Object Boundaries Superimposed on Original Image')

Lrgb = label2rgb(L,'jet','w','shuffle');
subplot(4,2,7);
imshow(Lrgb)
title('Colored Watershed Label Matrix')

subplot(4,2,8);
imshow(I)
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.3;
title('Colored Labels Superimposed Transparently on Original Image')
