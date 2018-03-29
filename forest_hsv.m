function [change, greenlayer1, greenlayer2]= forest_hsv(I0,I1, n, m)
close all;
I0_orig = I0;
I1_orig = I1;
figure(1);
subplot(1,2,1);
imshow(I0); title('Old image');
subplot(1,2,2);
imshow(I1); title('New image');

hsv_image_1 = rgb2hsv(I0);
hsv_image_2 = rgb2hsv(I1);

figure(2);
subplot(1,2,1);
imshow(hsv_image_1); title('HSV for first image');
subplot(1,2,2);
imshow(hsv_image_2); title('HSV for second image');

hueLow = 93/360;
hueHigh = 190/360;
satLow = 0.61;
satHigh = 1;
valLow = 0.36;
valHigh = 0.80;

hue_1 = hsv_image_1(:, :, 1);
sat_1 = hsv_image_1(:,:,2);
val_1 = hsv_image_1(:,:,3);
green_1 = zeros(984,1651,3);
        hue_mask1 = hue_1>hueLow & hue_1<hueHigh;
        sat_mask1 = sat_1>satLow & sat_1<satHigh;
        val_mask1 = val_1>valLow & val_1<valHigh;

hue_2 = hsv_image_2(:, :, 1);
sat_2 = hsv_image_2(:,:,2);
val_2 = hsv_image_2(:,:,3);
green_2 = zeros(984,1651,3);
        hue_mask2 = hue_2>hueLow & hue_2<hueHigh;
        sat_mask2 = sat_2>satLow & sat_2<satHigh;
        val_mask2 = val_2>valLow & val_2<valHigh;

for k=1:3        
    I0(:,:,k) = double(I0(:,:,k)).*hue_mask1;  %non green elements are multiplied by zero
end
% greenlayer1 = zeros(984, 1651, 3);
% greenlayer1(:,:,2) = green1;
greenlayer1 = uint8(I0);

for k=1:3
    I1(:,:,k) = double(I1(:,:,k)).*hue_mask2;
end
% greenlayer2 = zeros(984, 1651, 3);
% greenlayer2(:,:,2) = green2;
greenlayer2 = uint8(I1);

figure(3);
subplot(2,2,1);
imshow(hue_mask1); title('Hue Mask for first image');
subplot(2,2,2);
imshow(hue_mask2); title('Hue Mask for second image');
subplot(2,2,3);
imshow(greenlayer1); title('Green Hue Mask for first image');
subplot(2,2,4);
imshow(greenlayer2); title('Green Hue Mask for second image');


%negative values indicate green has decreased - red
neg_change = zeros(n,m,3);
%positive values indicate green has increased - green
pos_change = zeros(n,m,3);
%no change - blue
no_change = zeros(n,m,3);


change = hue_mask2-hue_mask1;

for i = 1:984
    for j=1:1651
       if(change(i, j)<0)
            neg_change(i,j, 1)=255;
        elseif(change(i,j)>0)
            pos_change(i,j, 2)=255;
        elseif(abs(change(i,j))==0)
            no_change(i,j, 3)=255;
        end
    end
end

pos = uint8(pos_change);
neg = uint8(neg_change);
none = uint8(no_change);


figure(4);
subplot(2,2,1);
imshow(pos); title('Increase in forest area');
subplot(2,2,2);
imshow(neg); title('Decrease in forest area');
subplot(2,2,3);
imshow(none); title('No change in forest area');

figure(5);
imshow(imadd(I0_orig, pos)); title('+ve change added to original image');
figure(6);
imshow(imadd(I0_orig, neg)); title('-ve change from original image');
figure(7);
imshow(imadd(imadd(pos, neg),none)); title('All changes');


%subplot(1,2,1);imshow(I);title('Before separating out green by hue and intensity');
%subplot(1,2,2);imshow(green_1);title('After separating out green by hue and intensity')







