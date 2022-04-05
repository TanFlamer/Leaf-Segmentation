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