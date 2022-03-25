image1 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant001.png");
image2 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant002.png");
image3 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant003.png");

%[J,rect] = imcrop(image1);
croppedImage = imcrop(image1,[120 176 204 210]);
croppedImage2 = imcrop(image1,[212 196 27 33]);
imshow(croppedImage2);

I=croppedImage2;
R=imhist(I(:,:,1));
G=imhist(I(:,:,2));
B=imhist(I(:,:,3));
subplot(1,3,1);
figure, plot(R,'r')
hold on, plot(G,'g')
plot(B,'b'), legend(' Red channel','Green channel','Blue channel');
hold off,

%{
figure();

subplot(1,2,1);
imshow(I);
title('Normal Image');
impixelinfo;

subplot(1,2,2);
imshow(I);
title('Sharp Image');
impixelinfo;
%}

sharpImage = image1;

red = sharpImage(:,:,1);
green = sharpImage(:,:,2);
blue = sharpImage(:,:,3);

redMask = (red > 65 & red < 125);
greenMask = (green > 150 & green < 185);
blueMask = (blue < 70);

figure();

subplot(1, 3, 1);
imshow(redMask, []);
title('Red Mask');

subplot(1, 3, 2);
imshow(greenMask, []);
title('Green Mask');

subplot(1, 3, 3);
imshow(blueMask, []);
title('Blue Mask');
