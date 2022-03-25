image1 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant001.png");
image2 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant002.png");
image3 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant003.png");

currentImage = image3;
sharpImage = imsharpen(currentImage);

subplot(1,2,1);
imshow(currentImage);
impixelinfo;

subplot(1,2,2);
imshow(sharpImage);
impixelinfo;

red = sharpImage(:,:,1);
green = sharpImage(:,:,2);
blue = sharpImage(:,:,3);

figure();
subplot(1,3,1);
imshow(red);
impixelinfo;

subplot(1,3,2);
imshow(green);
impixelinfo;

subplot(1,3,3);
imshow(blue);
impixelinfo;

redMask = (red > 70 & red < 140);
greenMask = (green > 100);
blueMask = (blue > 30 & blue < 100);

specialMask = (green > 1.1 * red & green > 1.1 * blue);
specialMask2 = (green > (red + blue) / 1.3);
specialMask3 = ((red/3 + green/3 + blue/3) < 200);

subplot(2, 3, 1);
imshow(redMask, []);
title('Red Mask');
subplot(2, 3, 2);
imshow(greenMask, []);
title('Green Mask');
subplot(2, 3, 3);
imshow(blueMask, []);
title('Blue Mask');
subplot(2, 3, 4);
imshow(specialMask, []);
title('Special Mask');
subplot(2, 3, 5);
imshow(specialMask2, []);
title('Special Mask 2');
subplot(2, 3, 6);
imshow(specialMask3, []);
title('Special Mask 3');

% Combine the masks to find where all 3 are "true."
redObjectsMask = uint8(greenMask & specialMask & specialMask2);
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
