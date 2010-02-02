function random_detection(opts,detector_opts,imIndex)
% compute a random feature detector. Both the position in the image and the scale are selected random.
% input:
%           opts                    : contains information about data set
%           detector_opts           : contains information about detector to use, and detector settings 
%           detector_opts.min_scale : minimum scale detected        
%           detector_opts.max_scale : maximum scale detected
%           imIndex                 : index to image in data set described by 'opts'

image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(imIndex,3));    % where detector is saved

im=read_image_db(opts,imIndex);

points=rand(detector_opts.npoints,3);
points(:,1)=ceil(points(:,1)*size(im,2));
points(:,2)=ceil(points(:,2)*size(im,1));
points(:,3)=ceil(points(:,3)*(detector_opts.max_scale-detector_opts.min_scale)+detector_opts.min_scale);    

% save the detector results in image_dir
% the detector is saved in the following format
% [x y scale]      % Be aware that matlab codes coordinates first y and than x !

save ([image_dir,'/',detector_opts.name], 'points');