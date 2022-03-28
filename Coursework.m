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
specialMask3 = (red > 1.5 * blue);

hueMask = (hue >= 0.2 & hue <= 0.35);
saturationMask = (saturation >= 0.6);
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
subplot(2, 2, 1);
imshow(originalMask, []);
title('Original Mask');

removedMask = bwareaopen(originalMask,400);
subplot(2, 2, 2);
imshow(removedMask, []);
title('Removed Mask');

se = strel('disk',4);
closedMask = imclose(removedMask,se);
subplot(2, 2, 3);
imshow(closedMask, []);
title('Closed Mask');

closedrgbImage = uint8(zeros(size(closedMask))); % Initialize
closedrgbImage(:,:,1) = currentImage(:,:,1) .* uint8(closedMask);
closedrgbImage(:,:,2) = currentImage(:,:,2) .* uint8(closedMask);
closedrgbImage(:,:,3) = currentImage(:,:,3) .* uint8(closedMask);

subplot(2, 2, 4);
imshow(closedrgbImage);
title('Closed Original Image');

leaves = rgb2gray(closedrgbImage);
enhanced = imsharpen(leaves,'Radius',0.5,'Amount',1.5);
I = enhanced;

figure();
subplot(1,3,1);
imshow(leaves);
title('Original Image')

subplot(1,3,2);
imshow(I);
title('Sharpened Image');

gmag = imgradient(I);
subplot(1,3,3);
imshow(gmag,[])
title('Gradient Magnitude')

figure();

se = strel('disk',3);
Io = imopen(I,se);
subplot(2,2,1);
imshow(Io)
title('Opening')

Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
subplot(2,2,2);
imshow(Iobr)
title('Opening-by-Reconstruction')

Ioc = imclose(Io,se);
subplot(2,2,3);
imshow(Ioc)
title('Opening-Closing')

Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
subplot(2,2,4);
imshow(Iobrcbr)
title('Opening-Closing by Reconstruction')

figure();

fgm = imregionalmax(Iobrcbr);
subplot(3,2,1);
imshow(fgm)
title('Regional Maxima of Opening-Closing by Reconstruction')

I2 = labeloverlay(I,fgm);
subplot(3,2,2);
imshow(I2)
title('Regional Maxima Superimposed on Original Image')

se2 = strel('disk',3);
fgm2 = imclose(fgm,se2);

se2 = strel(ones(2,2));
fgm3 = imerode(fgm2,se2);

fgm4 = bwareaopen(fgm3,20);

if(bwconncomp(fgm4).NumObjects > 12)
    se2 = strel('disk',7);
    fgm2 = imclose(fgm,se2);

    se2 = strel(ones(2,2));
    fgm3 = imerode(fgm2,se2);

    fgm4 = bwareaopen(fgm3,150);
end

I3 = labeloverlay(I,fgm4);
subplot(3,2,3);
imshow(I3)
title('Modified Regional Maxima Superimposed on Original Image')

bw = imbinarize(Iobrcbr);
subplot(3,2,4);
imshow(bw)
title('Thresholded Opening-Closing by Reconstruction')

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
subplot(3,2,5);
imshow(bgm)
title('Watershed Ridge Lines')

gmag2 = imimposemin(gmag, bgm | fgm4);
L = watershed(gmag2);

labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(I,labels);
subplot(3,2,6);
imshow(I4)
title('Markers and Object Boundaries Superimposed on Original Image')

figure();

Lrgb = label2rgb(L,'jet','w','shuffle');
subplot(2,2,1);
imshow(Lrgb)
title('Colored Watershed Label Matrix')

subplot(2,2,2);
imshow(I)
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.3;
title('Colored Labels Superimposed Transparently on Original Image')

colourMask = (enhanced ~= 0);
whiteMask = ~(Lrgb(:,:,1) == 255 & Lrgb(:,:,2) == 255 & Lrgb(:,:,3) == 255);
finalMask = colourMask & whiteMask;
finalMask = uint8(bwareaopen(finalMask,200));

subplot(2,2,3);
imshow(finalMask,[]);
title('Final Mask');

bwconncomp(finalMask).NumObjects

finalImage = uint8(zeros(size(finalMask))); % Initialize
finalImage(:,:,1) = Lrgb(:,:,1) .* finalMask;
finalImage(:,:,2) = Lrgb(:,:,2) .* finalMask;
finalImage(:,:,3) = Lrgb(:,:,3) .* finalMask;

subplot(2,2,4);
imshow(finalImage);
title('Final Image');
impixelinfo;