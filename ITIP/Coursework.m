%Introduction to Image Processing Coursework
%Name: Tan Zhun Xian
%Student ID: 20313854

%The matlab file displays the input images and their corresponding output 
%images in a 3x2 plot.

function Coursework()

    %Preallocating for speed

    %RGB, HSV and YCbCr images
    [inputImage,HSVImage,YCbCrImage] = deal(cell(1,3));

    %RGB, HSV and YCbCr components of the images
    [red,green,blue] = deal(cell(1,3));
    [hue,saturation,value] = deal(cell(1,3));
    [luma,blueRelative,redRelative] = deal(cell(1,3));
     
    %Masks for ROI masking
    [redMask,greenMask,blueMask] = deal(cell(1,3));
    [hueMask,saturationMask,valueMask] = deal(cell(1,3));
    [lumaMask,blueRelativeMask,redRelativeMask] = deal(cell(1,3));
    [specialMask1,specialMask2,specialMask3] = deal(cell(1,3));

    %Applying ROI mask to input image
    [originalMask,removedMask,closedMask,closedrgbImage] = deal(cell(1,3));

    %Unsharp Masking the ROI
    [leaves,enhanced] = deal(cell(1,3));

    %Marker-Based Watershed Segmentation
    [gmag,gmag2] = deal(cell(1,3));
    [I,I2,I3,I4] = deal(cell(1,3));
    [fgm,fgm2,fgm3,fgm4] = deal(cell(1,3));
    [Ie,Iobr,Iobrd,Iobrcbr] = deal(cell(1,3));
    [D,DL,L,Lrgb] = deal(cell(1,3));
    [bw,bgm,labels] = deal(cell(1,3));

    %Getting output image
    [colourMask,whiteMask,finalMask,outputImage] = deal(cell(1,3));

    %Loop through all 3 images
    for i = 1:3

        %Getting the RGB, HSV and YCbCr of the input images
        inputImage{i} = imread("plant00" + i + ".png");
        HSVImage{i} = rgb2hsv(inputImage{i});
        YCbCrImage{i} = rgb2ycbcr(inputImage{i});

        %Separating the RGB, HSV and YCbCr components of the input images
        [red{i},green{i},blue{i}] = imsplit(inputImage{i});
        [hue{i},saturation{i},value{i}] = imsplit(HSVImage{i});
        [luma{i},blueRelative{i},redRelative{i}] = imsplit(YCbCrImage{i});

        %ROI masking

        %RGB masks
        redMask{i} = (red{i} > 70 & red{i} < 140);
        greenMask{i} = (green{i} > 100);
        blueMask{i} = (blue{i} > 30 & blue{i} < 100);

        %HSV masks
        hueMask{i} = (hue{i} >= 0.2 & hue{i} <= 0.35);
        saturationMask{i} = (saturation{i} >= 0.6);
        valueMask{i} = (value{i} >= 0.2 & value{i} <= 0.7);

        %YCbCr masks
        lumaMask{i} = (luma{i} >= 100 & luma{i} <= 150);
        blueRelativeMask{i} = (blueRelative{i} >= 60 & blueRelative{i} <= 121);
        redRelativeMask{i} = (redRelative{i} >= 100 & redRelative{i} <= 125);

        %Special masks
        specialMask1{i} = (green{i} > 1.1 * red{i} & green{i} > 1.1 * blue{i});
        specialMask2{i} = (green{i} > (red{i} + blue{i}) / 1.4);
        specialMask3{i} = (red{i} > 1.5 * blue{i});

        % Combining special mask 1, special mask 2, blue relative mask and red
        % relative mask to produce the original mask
        originalMask{i} = uint8(specialMask1{i} & specialMask2{i} & blueRelativeMask{i} & redRelativeMask{i});

        %Removing connected components with less than 400 pixels in the mask
        removedMask{i} = bwareaopen(originalMask{i},400);

        %Morphologically closing the mask
        closedMask{i} = imclose(removedMask{i},strel('disk',4));

        %Using the mask on original image to produce ROI
        closedrgbImage{i} = bsxfun(@times, inputImage{i}, cast(closedMask{i}, 'like', inputImage{i}));

        %Unsharp masking the ROI
        leaves{i} = rgb2gray(closedrgbImage{i});
        enhanced{i} = imsharpen(leaves{i},'Radius',0.5,'Amount',1.5);
        I{i} = enhanced{i};

        %Calculating gradient magnitude
        gmag{i} = imgradient(I{i});

        %Eroding and reconstructing image
        Ie{i} = imerode(I{i},strel('disk',3));
        Iobr{i} = imreconstruct(Ie{i},I{i});

        %Dilating and reconstructing image
        Iobrd{i} = imdilate(Iobr{i},strel('disk',3));
        Iobrcbr{i} = imreconstruct(imcomplement(Iobrd{i}),imcomplement(Iobr{i}));
        Iobrcbr{i} = imcomplement(Iobrcbr{i});

        %Calculating regional maxima
        fgm{i} = imregionalmax(Iobrcbr{i});

        %Overlay regional maxima on original image
        I2{i} = labeloverlay(I{i},fgm{i});

        %Modifying regional maxima for 1st and 2nd image
        fgm2{i} = imclose(fgm{i},strel('disk',3));
        fgm3{i} = imerode(fgm2{i},strel(ones(2,2)));
        fgm4{i} = bwareaopen(fgm3{i},20);

        %Modifying regional maxima for 3rd image
        if(bwconncomp(fgm4{i}).NumObjects > 12)
            fgm2{i} = imclose(fgm{i},strel('disk',7));
            fgm3{i} = imerode(fgm2{i},strel(ones(2,2)));
            fgm4{i} = bwareaopen(fgm3{i},150);
        end

        %Overlay modified regional maxima on original image
        I3{i} = labeloverlay(I{i},fgm4{i});

        %Calculating background by binarizing image
        bw{i} = imbinarize(Iobrcbr{i});

        %Getting watershed ridge lines
        D{i} = bwdist(bw{i});
        DL{i} = watershed(D{i});
        bgm{i} = (DL{i} == 0);

        %Perform watershed on image
        gmag2{i} = imimposemin(gmag{i}, bgm{i} | fgm4{i});
        L{i} = watershed(gmag2{i});

        %Superimpose markers and boundaries on original image
        labels{i} = imdilate(L{i}==0,ones(3,3)) + 2*bgm{i} + 3*fgm4{i};
        I4{i} = labeloverlay(I{i},labels{i});

        %Coloured label matrix
        Lrgb{i} = label2rgb(L{i},'jet','w','shuffle');

        %Creating final mask for coursework
        colourMask{i} = (enhanced{i} ~= 0);
        whiteMask{i} = ~(Lrgb{i}(:,:,1) == 255 & Lrgb{i}(:,:,2) == 255 & Lrgb{i}(:,:,3) == 255);
        finalMask{i} = colourMask{i} & whiteMask{i};
        finalMask{i} = uint8(bwareaopen(finalMask{i},200));

        %Use final mask on coloured label matrix to produce final image
        outputImage{i} = bsxfun(@times, Lrgb{i}, cast(finalMask{i}, 'like', Lrgb{i}));

    end

    %Storing input images, output images and image tags
    results = {inputImage,outputImage};
    tags = {'plant00','Output'};

    %Displaying final results
    figure('Name','Final Results');
    for i = 1:6
        subplot(3,2,i);
        imshow(results{mod(i-1,2)+1}{ceil(i/2)});
        title(tags{mod(i-1,2)+1} + string(ceil(i/2)));
    end

end