image1 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant001.png");
image2 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant002.png");
image3 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant003.png");

currentImage = image1;
sharpImage = imsharpen(currentImage,'Radius',1.5,'Amount',1.5,'Threshold',0.01);
normalYCbCr = rgb2ycbcr(currentImage);
sharpYCbCr = rgb2ycbcr(sharpImage);

subplot(2,2,1);
imshow(currentImage);
title('Normal Image');
impixelinfo;

subplot(2,2,2);
imshow(sharpImage);
title('Sharp Image');
impixelinfo;

subplot(2,2,3);
imshow(normalYCbCr);
title('Normal YCbCr');
impixelinfo;

subplot(2,2,4);
imshow(sharpYCbCr);
title('Sharp YCbCr');
impixelinfo;

luma = sharpYCbCr(:,:,1);
blueRelative = sharpYCbCr(:,:,2);
redRelative = sharpYCbCr(:,:,3);

figure();
subplot(2,2,1);
imshow(luma);
impixelinfo;

lumaMask = (luma >= 100 & luma <= 150);
subplot(2,2,2);
imshow(lumaMask, []);
impixelinfo;

blueRelativeMask = (blueRelative >= 60 & blueRelative <= 120);
subplot(2,2,3);
imshow(blueRelativeMask, []);
impixelinfo;

redRelativeMask = (redRelative >= 100 & redRelative <= 125);
subplot(2,2,4);
imshow(redRelativeMask, []);
impixelinfo;
