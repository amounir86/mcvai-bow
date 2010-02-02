function RGB_descriptor(opts,descriptor_opts,imIndex)
% compute a RGB feature descriptor. 
% input:
%           opts                          : contains information about data set
%           descriptor_opts               : contains information about the descriptor used
%           imIndex                       : index to image in data set described by 'opts'

% extract normalized patches from image
[patches]=normalize_features(opts,descriptor_opts.detector_name,imIndex,descriptor_opts.patch_size);

[yy,xx]=ndgrid((1:descriptor_opts.patch_size)-((descriptor_opts.patch_size+1)/2),(1:descriptor_opts.patch_size)-((descriptor_opts.patch_size+1)/2));

spatial_weights=normalize(reshape(exp(-.5*(xx.^2+yy.^2)/(2*(descriptor_opts.patch_size/4)^2)),descriptor_opts.patch_size*descriptor_opts.patch_size,1));
descriptors=[patches(:,:,1)*spatial_weights,patches(:,:,2)*spatial_weights ,patches(:,:,3)*spatial_weights];              %squeeze(mean(patches,2));

% save the descriptor results in image_dir
% the descriptor is saved in a p x n matrix, with p the number of descriptors and n the length of the feature vector (i.e. 3 for RGB)
image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(imIndex,3)); % location descriptor
save ([image_dir,'/',descriptor_opts.name], 'descriptors');           % save the descriptors
