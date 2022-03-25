image1 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant001.png");
image2 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant002.png");
image3 = imread("C:\Important\Uni\Coursework\ITIP\Images\plant003.png");

subplot(2,2,1);
imshow(image1);

sharp = imsharpen(image1,'Radius',1.5,'Amount',1.5,'Threshold',0.01);
subplot(2,2,2);
imshow(sharp);

sensitivity = 0.2;
leaves = rgb2gray(sharp);
edges_canny = edge(leaves,'Canny',sensitivity);

subplot(2,2,3);
imshow(edges_canny);

level = graythresh(leaves);
BW = imbinarize(leaves,level);

subplot(2,2,4);
imshow(BW);