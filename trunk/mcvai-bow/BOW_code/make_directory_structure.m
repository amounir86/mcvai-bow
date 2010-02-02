function []=make_directory_structure(opts)
% makes a directory in 'opts.datapath' descriptors containing 
% a directory for all images in the dataset

mkdir(opts.datapath,'local')
mkdir(opts.datapath,'global')

for ii=1:opts.nimages
     mkdir(sprintf('%s/local',opts.datapath),num2string(ii,3));     
end
        