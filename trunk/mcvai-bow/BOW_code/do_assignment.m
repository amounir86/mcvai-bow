function []=do_assignment(opts,assignment_opts)
% assign feature points to visual vocabulary
% input:
%           opts                            : contains information about data set
%           assignment_opts                 : contains information about assignment method
%           assignment_opts.type            : the asssignment method which is used
%           assignment_opts.descriptor_name : name of vocabulary  (voc)
%           assignment_opts.vocabulary_name : name of descriptors (input)

% if no settings available use default settings 
if ~isfield(assignment_opts,'type');               assignment_opts.type='1nn';                     end
if ~isfield(assignment_opts,'vocabulary_name');    assignment_opts.vocabulary_name='Unknown';      end
if ~isfield(assignment_opts,'descriptor_name');    assignment_opts.descriptor_name='Unknown';      end
if ~isfield(assignment_opts,'name');               assignment_opts.name=strcat(assignment_opts.type,assignment_opts.vocabulary_name); end

%% check if assignment already exists
try
    assignment_opts2=getfield(load([opts.globaldatapath,'/',assignment_opts.name,'_settings']),'assignment_opts');
    if(isequal(assignment_opts,assignment_opts2))
        display('Recomputing assignments for this settings');
    else
        display('Overwriting assignment with same name, but other Assignment settings !!!!!!!!!!');
    end
end

%% load data set information and vocabulary
load(opts.image_names);
nimages=opts.nimages;
vocabulary=getfield(load([opts.globaldatapath,'/',assignment_opts.vocabulary_name]),'voc');
vocabulary_size=size(vocabulary,1);

%% apply assignment method to data set
BOW=[];
h = waitbar(0,'Please wait...');
for ii=1:nimages
      image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(ii,3));                    % location where detector is saved          
      points=getfield(load([image_dir,assignment_opts.descriptor_name]),'descriptors');                      
      switch assignment_opts.type                                                         % select assignment method
            case '1nn'
                [minz index]=min(distance(points,vocabulary),[],2);
                BOW(:,ii)=hist(index,(1:vocabulary_size));
            case 'pyramid'
                assignment_opts.level = 3;
                BOW=do_assignment_pyramids_lazebnik(opts,assignment_opts);
                break;
            otherwise
                display('A non existing assignment method is selected !!!!!');
      end
      waitbar(ii/nimages,h);
end
close(h);

BOW=normalize(BOW,1);                                                                      % normalize the BOW histograms to sum-up to one.
save ([opts.globaldatapath,'/',assignment_opts.name],'BOW');                               % save the BOW representation in opts.globaldatapath
save ([opts.globaldatapath,'/',assignment_opts.name,'_settings'],'assignment_opts');