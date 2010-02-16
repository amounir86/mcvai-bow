function [ voc ] = separate_kmeans( points_total,vocabulary_size, color_size )
%SEPARATE_KMEANS Summary of this function goes here
%   Detailed explanation goes here

color = points_total(:,1:3);
sift = points_total(:,4:end);

[index_color,voc_color] = kmeans(color,color_size);
[index_sift,voc_sift] = kmeans(sift,vocabulary_size);

voc = {voc_color,voc_sift};

end

