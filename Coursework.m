%function Coursework()

image1 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant001.png");
image2 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant002.png");
image3 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant003.png");

subplot(1,2,1);
imshow(image1);

sharp1 = imsharpen(image1,'Radius',1.5,'Amount',1.5,'Threshold',0.01);
subplot(1,2,2);
imshow(sharp1);

sensitivity = 0.085;

leaves = rgb2gray(sharp1);
edges_canny = edge(leaves,'Canny',0.2);
edges_prewitt = edge(leaves,'Prewitt',0.06);
edges_roberts = edge(leaves,'Roberts',0.08);
edges_sobel = edge(leaves,'Sobel',0.07);
edges_log = edge(leaves,'log',0.005);

%figure();
%subplot(1,2,1);
%imshow(edges_log);

connected_log = bwmorph(edges_log,'clean');
filled_log = imfill(connected_log,'holes');
%subplot(1,2,2)
%imshow(connected_log);

level = graythresh(leaves);
BW = imbinarize(leaves,0.43);

se = strel('disk',1);
closeBW = imclose(BW,se);

%figure();
%imshowpair(BW,closeBW,'montage');

%{
figure();
D = bwdist(~closeBW);
imshow(D,[]);
title('Distance Transform of Binary Image');

figure();
D = -D;
imshow(D,[]);
title('Complement of Distance Transform');

L = watershed(D);
L(~closeBW) = 0;

figure();
rgb = label2rgb(L,'jet',[.5 .5 .5]);
imshow(rgb);
title('Watershed Transform');
%}

figure();
subplot(2,3,1);
imshow(edges_canny);
title("Canny");

subplot(2,3,2);
imshow(edges_prewitt);
title("Prewitt");

subplot(2,3,3);
imshow(edges_roberts);
title("Roberts");

subplot(2,3,4);
imshow(edges_sobel);
title("Sobel");

subplot(2,3,5);
imshow(edges_log);
title("log");

figure();
se = strel('line',3,45);
disk = strel('disk',2);
subplot(1,3,1)
clean_canny = imclose(edges_roberts,disk);
imshow(clean_canny);

subplot(1,3,2)
bridge_canny = bwmorph(clean_canny,'bridge');
imshow(bridge_canny);

subplot(1,3,3)
filled_canny = imfill(bridge_canny,'holes');
imshow(filled_canny);


%{
filled_canny = imfill(edges_canny,'holes');
filled_prewitt = imfill(edges_prewitt,'holes');
filled_roberts = imfill(edges_roberts,'holes');
filled_sobel = imfill(edges_sobel,'holes');

figure();
subplot(2,2,1);
imshow(filled_canny);
title("Canny");

subplot(2,2,2);
imshow(filled_prewitt);
title("Prewitt");

subplot(2,2,3);
imshow(filled_roberts);
title("Roberts");

subplot(2,2,4);
imshow(filled_sobel);
title("Sobel");
%}

%{
I = rgb2gray(image3);
imshow(I);

gmag = imgradient(I);
imshow(gmag,[]);
title('Gradient Magnitude');

se = strel('disk',20);
Io = imopen(I,se);
imshow(Io);
title('Opening');

Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
imshow(Iobr);
title('Opening-by-Reconstruction');

Ioc = imclose(Io,se);
imshow(Ioc);
title('Opening-Closing');

Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
imshow(Iobrcbr);
title('Opening-Closing by Reconstruction');

fgm = imregionalmax(Iobrcbr);
imshow(fgm);
title('Regional Maxima of Opening-Closing by Reconstruction');

I2 = labeloverlay(I,fgm);
imshow(I2);
title('Regional Maxima Superimposed on Original Image');

se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);

fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(I,fgm4);
imshow(I3);
title('Modified Regional Maxima Superimposed on Original Image');

bw = imbinarize(Iobrcbr);
imshow(bw);
title('Thresholded Opening-Closing by Reconstruction');

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
imshow(bgm);
title('Watershed Ridge Lines');

gmag2 = imimposemin(gmag, bgm | fgm4);

L = watershed(gmag2);

labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(I,labels);
imshow(I4);
title('Markers and Object Boundaries Superimposed on Original Image');

Lrgb = label2rgb(L,'jet','w','shuffle');
imshow(Lrgb);
title('Colored Watershed Label Matrix');

figure();
imshow(I);
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.3;
title('Colored Labels Superimposed Transparently on Original Image');
%}

