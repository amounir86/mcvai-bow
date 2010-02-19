function BOW=do_assignment_pyramids_3HLevels(opts,assignment_opts, iIndex)
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
vocabularyMerged=getfield(load([opts.globaldatapath,'/',assignment_opts.vocabulary_name]),'voc');

%% Parameters (levels starts with L1)
pyramidLevels = assignment_opts.level;
Levels = pyramidLevels;
BOW=[]; pyramid_all=[];

for v=1:2

    vocabulary = vocabularyMerged{v};
    vocabulary_size=size(vocabulary,1);dictionarySize=vocabulary_size;

    %% Apply assignment method to data set and build pyramid

    % Set where local data is saved.
    image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(iIndex,3));

    % Load detector points
    points = getfield(load([image_dir,'/',assignment_opts.detector_name]),'points');

    % Load descriptors
    descriptors = getfield(load([image_dir,'/',assignment_opts.descriptor_name]),'descriptors');
    
    if v == 1
        descriptors = descriptors(:,1:3);
    elseif v == 2
        descriptors = descriptors(:,4:end);
    end

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
    %% Horizontal levels
    for i=1:3
        % find the coordinates of the current bin
        x_lo = floor(wid * (i-1));
        x_hi = floor(wid * i);
        y_lo = floor(0);
        y_hi = floor(hgt);

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
    pyramid = [pyramid pyramid_cell{1}(:)' .* (3^(-1) * 2.0)];
    pyramid = [pyramid pyramid_cell{2}(:)' .* (3^(-1) * 1.0)];
    
    pyramid_all = [pyramid_all, pyramid];
end

phog_I = read_image_db(opts, iIndex);
phog_bin = 8;
phog_angle = 360;
phog_L=2;
phog_roi = [1;size(phog_I, 1);1;size(phog_I, 2)];
phog = anna_phog(phog_I,phog_bin,phog_angle,phog_L,phog_roi);
phog = phog';

pyramid_all = [pyramid_all, phog];

BOW =pyramid_all';

% save the BOW representation in opts.globaldatapath                                                                
save ([opts.globaldatapath ,'/',assignment_opts.name,'L',num2str(assignment_opts.level)],'BOW');
save ([opts.globaldatapath ,'/',assignment_opts.name,'L',num2str(assignment_opts.level),'_settings'],'assignment_opts');
save ([opts.globaldatapath,'/',assignment_opts.name,'L',num2str(assignment_opts.level),'_hybrid_index'],'index_list');

