function sift_detection(opts,detector_opts,imIndex)
% compute a corners feature detector.
% input:
%           opts                    : contains information about data set
%           detector_opts           : contains information about detector to use, and detector settings 
%           detector_opts.min_scale : minimum scale detected        
%           detector_opts.max_scale : maximum scale detected
%           imIndex                 : index to image in data set described by 'opts'

image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(imIndex,3));    % where detector is saved

im=read_image_db(opts,imIndex);

im = rgb2gray(ind2gray(im, gray(256)));
points = vl_sift(single(im));
points = points';


% save the detector results in image_dir
% the detector is saved in the following format
% [x y scale]      % Be aware that matlab codes coordinates first y and than x !

save ([image_dir,'/',detector_opts.name], 'points');