function [ output_args ] = SIFT_descriptor( opts, descriptor_opts, imIndex )
%SIFT_DESCRIPTOR Summary of this function goes here
%   Detailed explanation goes here

image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(imIndex,3));             % location detector

points=getfield(load(sprintf('%s/%s',image_dir,descriptor_opts.detector_name)),'points');
points=points';

% If we don't have information on the orientation of the patches, just use
% 0
if (size(points,1)==3)
    points(4,:) = 0;
end

I = read_image_db(opts,imIndex);
I = rgb2gray(ind2gray(I,gray(256)));
% I_ = vl_imsmooth(im2double(I), sqrt(points(3,1)^2 - 0.5^2));
[Ix, Iy] = vl_grad(I);
mod = sqrt(Ix.^2 + Iy.^2);
ang = atan2(Iy,Ix);
grd = shiftdim(cat(3,mod,ang),2);
grd = single(grd);

descriptors = vl_siftdescriptor(grd, points);
descriptors = double(descriptors');

% save the descriptor results in image_dir
% the descriptor is saved in a p x n matrix, with p the number of descriptors and n the length of the feature vector (i.e. 3 for RGB)
image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(imIndex,3)); % location descriptor
save ([image_dir,'/',descriptor_opts.name], 'descriptors');           % save the descriptors


end

