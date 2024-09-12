original = imread('Histogram+Edge.bmp');

% 1) Original histogram, equalized histogram, and the processed image after histogram equalization
figure;
subplot(2,2,1);
imshow(original);
title('Original Image');

[counts, x] = imhist(original);
subplot(2,2,2);
bar(x, counts);
title('Original Histogram');

equalized = histeq(original);

[counts, x] = imhist(equalized);
subplot(2,2,3);
bar(x, counts);
title('Equalized Histogram');

subplot(2,2,4);
imshow(equalized);
title('Processed image');
imwrite(equalized, 'Output_processed_image.bmp');

% 2) Detected edges in the image after edge detection
if size(original,3) == 3
    gray = rgb2gray(original);
    equalized = histeq(gray);
end

edges = edge(equalized, 'Canny');
figure;
imshow(edges);
title('Detected Edges');
imwrite(edges, 'Output_detected_edge.bmp');