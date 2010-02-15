%% Script to perform BOW-based image classification
% code credit: Fahad Shabaz Khan inspired on VOC-challenge code of Mark Everingham.

%% initialize the settings
display('*********** start BOW *********')

EVENTinit
detect_opts=[];descriptor_opts=[];vocabulary_opts=[];assignment_opts=[];


%% detector
detect_opts.type='grid';                    % name detector
detect_opts.min_scale=10;                    % minimal scale of feature points
detect_opts.max_scale=50;                   % maximal scale of feature points
detect_opts.npoints=600;                    % number of feature points
detect_opts.name=['DET400p3',detect_opts.type];  % name which is used to save the detector information

do_detect(eventopts,detect_opts);

%% descriptor
descriptor_opts.type='rgb';                                                      % name descriptor
descriptor_opts.detector_name=detect_opts.name;                                  % name detector (input)
descriptor_opts.name=['DES',descriptor_opts.type,descriptor_opts.detector_name]; % output name (combines detector and descrtiptor name)
descriptor_opts.patch_size=11;                                                   % normalized patch size
do_descriptor(eventopts,descriptor_opts);

%% vocabulary
vocabulary_opts.type='kmeans';                          % name vocabulary method
vocabulary_opts.force=1;                                % force=1 forces the vocabulary to be recomputed even when it already exists
vocabulary_opts.size=400;                               % number of visual words in vocabulary
vocabulary_opts.sample_rate=10;                         % number of points sampled from each image on which to apply vocabulary method
vocabulary_opts.descriptor_name=descriptor_opts.name;   % name of descriptors (input)
vocabulary_opts.name=['VOC',vocabulary_opts.type,descriptor_opts.name,num2str(vocabulary_opts.size)];  % output name

do_vocabulary(eventopts,vocabulary_opts);

%% assignment
assignment_opts.type='pyramid';                                 % name of assignment method
assignment_opts.descriptor_name=descriptor_opts.name;       % name of descriptor (input)
assignment_opts.vocabulary_name=vocabulary_opts.name;       % name of vocabulary (voc)
assignment_opts.name=['BOW_1',descriptor_opts.type];         % name of assignment output
assignment_opts.detector_name = detect_opts.name; % Name of detector

do_assignment(eventopts,assignment_opts);

%% Classification

do_classification_script

%% Average precision graphs

averagePerc = 1:eventopts.nclasses;
figure(1), hold on
for cl=1:eventopts.nclasses
    [rec,prec,averagePerc(cl)] = do_eval(eventopts,cl,dec_values(:,cl));
end
hold off

%% Show results

figure(2), hold on;
show_results_script                                        % comment if not needed
hold off
