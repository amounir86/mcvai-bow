function BOW=do_assignment_pyramids_3VLevels(opts,assignment_opts)
%% Assign feature points to visual vocabulary
% input:
%           opts            : contains information about data set
%           assignment_opts : contains information about assignment method

%% Check if assignment already exists
try
    assignment_opts2=getfield(load([opts.globaldatapath,'/',assignment_opts.name,'_settings']),'assignment_opts');
    if(isequal(assignment_opts, assignment_opts2))
        display('Recomputing assignments for these settings');
    else
        display('Overwriting assignment with same name, but other Assignment settings!');
    end
end
display('Computing Pyramids!');

%% Load data set information and vocabulary
load(opts.image_names);
nimages=opts.nimages;
vocabulary=getfield(load([opts.globaldatapath,'/',assignment_opts.vocabulary_name]),'voc');
vocabulary_size=size(vocabulary,1);dictionarySize=vocabulary_size;

%% Parameters (levels starts with L1)
pyramidLevels=assignment_opts.level;
Levels=pyramidLevels;
BOW=[];pyramid_all = [];

%% Apply assignment method to data set and build pyramid     
h = waitbar(0,'Calculating pyramid. Please wait...');

for iIndex=1:nimages    
    
    % Set where local data is saved.
    image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(iIndex,3));

    % Load detector points
    points = getfield(load([image_dir,'/',assignment_opts.detector_name]),'points');

    % Load descriptors
    descriptors = getfield(load([image_dir,'/',assignment_opts.descriptor_name]),'descriptors');     

    [minz index] = min(distance(descriptors,vocabulary),[],2);
    index_list{iIndex}=index(:,1);
   
    %% Read the image and get the properties
    img=imread(sprintf('%s/%s',opts.imgpath,image_names{iIndex}));
    [m n p] = size(img);

    %% Get width and height of input image
    texton_ind.x=points(:,1);     
    texton_ind.y=points(:,2);
    texton_ind.data=index;
    hgt=m; wid=n;

    %% compute histogram at the finest level
    pyramid_cell = cell(pyramidLevels,1);
    pyramid_cell{1} = zeros(3, dictionarySize);

    %% Level 1
    %% Vertical levels
    for i=1:3
        % find the coordinates of the current bin
        x_lo = floor(0);
        x_hi = floor(wid);
        y_lo = floor(hgt * (i - 1));
        y_hi = floor(hgt * i);

        texton_patch = texton_ind.data( (texton_ind.x > x_lo) & (texton_ind.x <= x_hi) & ...
                                        (texton_ind.y > y_lo) & (texton_ind.y <= y_hi));

        % make histogram of features in bin
        pyramid_cell{1}(i,:) = hist(texton_patch, 1:dictionarySize)./length(texton_ind.data);
    end

    %% compute histograms at the coarser levels

    %% Level 2
    pyramid_cell{2} = zeros(1, dictionarySize);
    pyramid_cell{2}(1,:) = 0;
    for i=1:3
        pyramid_cell{2}(1,:) = pyramid_cell{2}(1,:) + pyramid_cell{1}(i,:);
    end
    
    %% stack all the histograms with appropriate weights
    pyramid = [];
    pyramid = [pyramid pyramid_cell{1}(:)' .* 2^(-1)];
    pyramid = [pyramid pyramid_cell{2}(:)' .* 2^(-1)];
    pyramid_all = [pyramid_all; pyramid];
    waitbar(iIndex/nimages,h);
end

BOW =pyramid_all';
close(h);

% save the BOW representation in opts.globaldatapath                                                                
save ([opts.globaldatapath ,'/',assignment_opts.name,'L',num2str(assignment_opts.level)],'BOW');
save ([opts.globaldatapath ,'/',assignment_opts.name,'L',num2str(assignment_opts.level),'_settings'],'assignment_opts');
save ([opts.globaldatapath,'/',assignment_opts.name,'L',num2str(assignment_opts.level),'_hybrid_index'],'index_list');

