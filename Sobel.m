image1 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant001.png");
image2 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant002.png");
image3 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant003.png");

imshow(image1);
impixelinfo;

red = image1(:,:,1);
green = image1(:,:,2);
blue = image1(:,:,3);

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

leafRed = red;
leafGreen = green;
leafBlue = blue;

leafRed(red < 80) = 0;
leafRed(red >= 80) = 255;

figure();
sharp = imsharpen(image1,'Radius',1.5,'Amount',1.5,'Threshold',0.01);
subplot(2,2,1);
imshow(sharp);

ycbcr = rgb2ycbcr(sharp);
subplot(2,2,2);
imshow(ycbcr);

hsv = rgb2hsv(sharp);
%subplot(2,2,2);
%imshow(hsv);

hue = hsv(:,:,1);
saturation = hsv(:,:,2);
value = hsv(:,:,3);

sensitivity = 0.085;
leaves = rgb2gray(sharp);
edges_sobel = edge(leaves,'Sobel',sensitivity);

subplot(2,2,3);
imshow(edges_sobel);

level = graythresh(leaves);
BW = imbinarize(leaves,level);

subplot(2,2,4);
imshow(BW);