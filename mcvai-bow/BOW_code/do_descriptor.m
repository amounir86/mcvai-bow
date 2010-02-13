function []=do_descriptor(opts,descriptor_opts)
% function computes for all images in data set (opts) the descriptos for the features points detected with 'descriptor_opts.detector_name'
% input:
%           opts           : contains information about data set
%           descriptor_opts: contains information about descriptor to use, and detector settings 

% if no settings available use default settings 
if ~isfield(descriptor_opts,'type');                   descriptor_opts.function='rgb';                         end
if ~isfield(descriptor_opts,'detector_name');          descriptor_opts.detector_name='Unknown';                end
if ~isfield(descriptor_opts,'name');                   descriptor_opts.name=strcat(descriptor_opts.function,descriptor_opts.detector_name); end

descriptor_flag=1;

%% check if the detector used remains the same
try
    descriptor_opts.detector_settings=getfield(load([opts.globaldatapath,'/',descriptor_opts.detector_name,'_settings']),'detector_opts');
catch
    descriptor_opts.detector_settings='Unknown';
end

%% check if the descriptor settings remain the same
try
    descriptor_opts2=getfield(load([opts.globaldatapath,'/',descriptor_opts.name,'_settings']),'descriptor_opts');
    if(isequal(descriptor_opts,descriptor_opts2))
        descriptor_flag=0;
        display('descriptor has already been computed for this settings');
    else
        display('Overwriting descriptor with same name, but other descriptor settings !!!!!!!!!!');
    end
end

%% compute descriptor for all images
if(descriptor_flag)
    display('Computing descriptor');
    load(opts.image_names);
    nimages=opts.nimages;
    h = waitbar(0,'Please wait...');
    for ii=1:nimages
        switch descriptor_opts.type         % select descriptor   
            case 'rgb'
                RGB_descriptor(opts,descriptor_opts,ii);
            case 'sift'
                SIFT_descriptor(opts,descriptor_opts,ii);
            case 'rgbsift'
                RGB_SIFT_descriptor(opts,descriptor_opts,ii);
            otherwise
                display('A non existing descriptor is selected !!!!!');                
        end
        waitbar(ii/nimages,h);
    end
    close(h);
    save ([opts.globaldatapath,'/',descriptor_opts.name,'_settings'],'descriptor_opts');      % save the settings of descriptor in opts.globaldatapath
end