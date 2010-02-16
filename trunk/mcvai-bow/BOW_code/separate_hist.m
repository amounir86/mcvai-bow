function [ BOW ] = separate_hist( points, voc)
%SEPARATE_HIST Summary of this function goes here
%   Detailed explanation goes here
color_voc = voc{1};
sift_voc = voc{2};

color_points = points(:,1:3);
sift_points = points(:,4:end);

[minz index]=min(distance(color_points,color_voc),[],2);
BOW_color=hist(index,(1:size(color_voc,1)));

[minz index]=min(distance(sift_points,sift_voc),[],2);
BOW_sift=hist(index,(1:size(sift_voc,1)));

BOW = [BOW_color,BOW_sift];

end

