function corner_detection(opts,detector_opts,imIndex)
% compute a corners feature detector.
% input:
%           opts                    : contains information about data set
%           detector_opts           : contains information about detector to use, and detector settings 
%           detector_opts.min_scale : minimum scale detected        
%           detector_opts.max_scale : maximum scale detected
%           imIndex                 : index to image in data set described by 'opts'

image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(imIndex,3));    % where detector is saved

im=read_image_db(opts,imIndex);

im = ind2gray(im, gray(256));
[cout, imRes] = corner(im);

points=rand(detector_opts.npoints,3);

cornersLen = min(size(cout, 1), detector_opts.npoints);

points(1:cornersLen, 1) = cout(1:cornersLen, 1);

points(cornersLen:detector_opts.npoints,1)=ceil(points(cornersLen:detector_opts.npoints,1)*size(im,2));
points(cornersLen:detector_opts.npoints,2)=ceil(points(cornersLen:detector_opts.npoints,2)*size(im,1));
points(cornersLen:detector_opts.npoints,3)=ceil(points(cornersLen:detector_opts.npoints,3)*(detector_opts.max_scale-detector_opts.min_scale)+detector_opts.min_scale);

% save the detector results in image_dir
% the detector is saved in the following format
% [x y scale]      % Be aware that matlab codes coordinates first y and than x !

save ([image_dir,'/',detector_opts.name], 'points');