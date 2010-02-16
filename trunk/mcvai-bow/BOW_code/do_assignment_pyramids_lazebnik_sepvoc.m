function BOW=do_assignment_pyramids_lazebnik_sepvoc(opts,assignment_opts,iIndex)
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
pyramid_all = [];

for v=1:2
    vocabulary = vocabularyMerged{v};
    vocabulary_size=size(vocabulary,1);dictionarySize=vocabulary_size;

    %% Parameters (levels starts with L1)
    pyramidLevels=assignment_opts.level;
    Levels=pyramidLevels;
    maxBins = 2^(Levels-1);binsHigh=maxBins;
    BOW=[];

    %% Apply assignment method to data set and build pyramid     
%     h = waitbar(0,'Calculating pyramid. Please wait...');
    
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
    pyramid_cell{1} = zeros(binsHigh, binsHigh, dictionarySize);

    for i=1:binsHigh
        for j=1:binsHigh

            % find the coordinates of the current bin
            x_lo = floor(wid/binsHigh * (i-1));
            x_hi = floor(wid/binsHigh * i);
            y_lo = floor(hgt/binsHigh * (j-1));
            y_hi = floor(hgt/binsHigh * j);
            
            texton_patch = texton_ind.data( (texton_ind.x > x_lo) & (texton_ind.x <= x_hi) & ...
                                            (texton_ind.y > y_lo) & (texton_ind.y <= y_hi));
            
            % make histogram of features in bin
            pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:dictionarySize)./length(texton_ind.data);
        end
    end

    %% compute histograms at the coarser levels
    num_bins = binsHigh/2;
    for l = 2:pyramidLevels
        pyramid_cell{l} = zeros(num_bins, num_bins, dictionarySize);
        for i=1:num_bins
            for j=1:num_bins
                pyramid_cell{l}(i,j,:) = ...
                pyramid_cell{l-1}(2*i-1,2*j-1,:) + pyramid_cell{l-1}(2*i,2*j-1,:) + ...
                pyramid_cell{l-1}(2*i-1,2*j,:) + pyramid_cell{l-1}(2*i,2*j,:);
            end
        end
        num_bins = num_bins/2;
    end
    
    %% stack all the histograms with appropriate weights
    pyramid = [];
    for l = 1:pyramidLevels-1
        pyramid = [pyramid pyramid_cell{l}(:)' .* 2^(-l)];
    end
    pyramid = [pyramid pyramid_cell{pyramidLevels}(:)' .* 2^(1-pyramidLevels)];
    pyramid_all = [pyramid_all, pyramid];
%     waitbar(iIndex/nimages,h);
end

BOW =pyramid_all';
% close(h);

% save the BOW representation in opts.globaldatapath                                                                
save ([opts.globaldatapath ,'/',assignment_opts.name,'L',num2str(assignment_opts.level)],'BOW');
save ([opts.globaldatapath ,'/',assignment_opts.name,'L',num2str(assignment_opts.level),'_settings'],'assignment_opts');
save ([opts.globaldatapath,'/',assignment_opts.name,'L',num2str(assignment_opts.level),'_hybrid_index'],'index_list');
