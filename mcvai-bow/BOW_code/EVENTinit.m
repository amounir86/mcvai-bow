%%%%%%% Event Initialize File %%%%%%%%%
% based on VOC 2008 init
%(run makedirectories to initialize directory structure)

clear eventopts

% change these paths to point to the image, data and label location

eventopts.imgpath=['../events']; % image path
eventopts.datapath=['../data'];
eventopts.labelspath=['../labels'];

% local and global data paths
eventopts.localdatapath=sprintf('%s/local',eventopts.datapath);
eventopts.globaldatapath=sprintf('%s/global',eventopts.datapath);

% initialize the training set
eventopts.trainset=sprintf('%s/trainset.mat',eventopts.labelspath); 

% initialize the test set
eventopts.testset=sprintf('%s/testset.mat',eventopts.labelspath); 

% initialize the labels
eventopts.labels=sprintf('%s/labels.mat',eventopts.labelspath); 

% initialize the image names
eventopts.image_names=sprintf('%s/image_names.mat',eventopts.labelspath);

% Eventclasses

eventopts.classes={...
    'basket'
    'castells'
    'marathon'
    'polo'
    'rowing'
    'sailing'
    'snowboarding'};

eventopts.nclasses=length(eventopts.classes);	

load(sprintf('%s',eventopts.labels));
eventopts.nimages=size(labels,1);
