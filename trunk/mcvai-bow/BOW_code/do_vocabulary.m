function []=do_vocabulary(opts,vocabulary_opts)
% function computes a visual vocabulary based on the training image of the data set 'opts'
% input:
%           opts                            : contains information about data set
%           vocabulary_opts                 : contains information about vocabulary
%           vocabulary_opts.size            : number of visual words in vocabulary
%           vocabulary_opts.sample_rate     : number of points sampled from each image on which to apply vocabulary method
%           vocabulary_opts.force           : force==1 forces the vocabulary to be recomputed even when it already exists
%           vocabulary_opts.descriptor_name : name of descriptors (input)

% set default settings
if ~isfield(vocabulary_opts,'descriptor_name');    vocabulary_opts.descriptor_name='Unknown';       end
if ~isfield(vocabulary_opts,'type');               vocabulary_opts.type='rand';                     end
if ~isfield(vocabulary_opts,'size');               vocabulary_opts.size='Unknown';                  end
if ~isfield(vocabulary_opts,'sample_rate');        vocabulary_opts.sample_rate='Unknown';           end
if ~isfield(vocabulary_opts,'force');              vocabulary_opts.force=0;                         end
if ~isfield(vocabulary_opts,'name');               vocabulary_opts.name=strcat(vocabulary_opts.type,vocabulary_opts.descriptor_name,num2str(vocabulary_opts.size)); end

vocabulary_flag=1;

%% check if voicabulary already exists
try
    vocabulary_opts2=getfield(load([opts.globaldatapath,'/',vocabulary_opts.name,'_settings']),'vocabulary_opts');
    if(isequal(vocabulary_opts,vocabulary_opts2))
        if(vocabulary_opts.force)           % if force==1 then recompute the vocabulary
            display('vocabulary is recomputed');
        else
            display('vocabulary has already been computed (check if all settings remained the same)');
            vocabulary_flag=0;
        end
    else
        display('Overwriting vocabulary with same name, but other vocabulary settings !!!!!!!!!!');
    end
end

%% compute the visual vocabulary
if(vocabulary_flag)
    display('Computing vocabulary');
    load(opts.image_names);
    nimages=opts.nimages;
    load(opts.trainset)
    points_total=[];
    
    h = waitbar(0,'Reading descriptors...');    
    
    for ii=1:nimages
        if(trainset(ii)==1)                                                        % only sample points from the training data
            image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(ii,3));       % location where detectors have been saved          
            points=getfield(load([image_dir,vocabulary_opts.descriptor_name]),'descriptors');            
            sample_step=ceil(size(points,1)/vocabulary_opts.sample_rate);
            points=points(1:sample_step:size(points,1),:);
            points_total=[points_total;points];
        end
        waitbar(ii/nimages,h);
    end    
    
    switch vocabulary_opts.type     % select vocabulary
            case 'rand'
                voc=points_total(ceil(rand(vocabulary_opts.size,1)*size(points_total,1)),:);
            otherwise
                display('A non existing vocabulary-method is selected !!!!!');    
    end
    
    save ([opts.globaldatapath,'/',vocabulary_opts.name],'voc');                                 % save vocabulary and vocabulary settings in opts.globaldatapath
    save ([opts.globaldatapath,'/',vocabulary_opts.name,'_settings'],'vocabulary_opts');        
    close(h);
end