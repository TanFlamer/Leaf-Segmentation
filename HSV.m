image1 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant001.png");
image2 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant002.png");
image3 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant003.png");

currentImage = image3;
sharpImage = imsharpen(currentImage);
normalHSV = rgb2hsv(currentImage);
sharpHSV = rgb2hsv(sharpImage);

subplot(2,2,1);
imshow(currentImage);
impixelinfo;

subplot(2,2,2);
imshow(sharpImage);
impixelinfo;

subplot(2,2,3);
imshow(normalHSV);
impixelinfo;

subplot(2,2,4);
imshow(sharpHSV);
impixelinfo;

hue = sharpHSV(:,:,1);
saturation = sharpHSV(:,:,2);
value = sharpHSV(:,:,3);

figure();
subplot(2,2,1);
imshow(hue);
impixelinfo;

hueMask = (hue >= 0.2 & hue <= 0.35);
subplot(2,2,2);
imshow(hueMask, []);
impixelinfo;

saturationMask = (saturation >= 0.3 & saturation <= 0.6);
subplot(2,2,3);
imshow(saturationMask, []);
impixelinfo;

valueMask = (value >= 0.2 & value <= 0.7);
subplot(2,2,4);
imshow(valueMask, []);
impixelinfo;

% Combine the masks to find where all 3 are "true."
redObjectsMask = uint8(hueMask & saturationMask & valueMask);
figure();
subplot(1, 2, 1);
imshow(redObjectsMask, []);
title('Red Objects Mask');
maskedrgbImage = uint8(zeros(size(redObjectsMask))); % Initialize
maskedrgbImage(:,:,1) = sharpImage(:,:,1) .* redObjectsMask;
maskedrgbImage(:,:,2) = sharpImage(:,:,2) .* redObjectsMask;
maskedrgbImage(:,:,3) = sharpImage(:,:,3) .* redObjectsMask;
subplot(1, 2, 2);
imshow(maskedrgbImage);
title('Masked Original Image');