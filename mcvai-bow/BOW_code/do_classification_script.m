%% classification script using SVM
% The classification is done in a script which makes it a easier to change. However feel free to make it into a function
% as the other stages above.

% load the BOW representations, the labels, and the train and test set
load(eventopts.trainset);
load(eventopts.testset);
load(eventopts.labels);
load([eventopts.globaldatapath,'/',assignment_opts.name])

train_labels    = labels(trainset);          % contains the labels of the trainset
train_data      = BOW(:,trainset)';          % contains the train data
[train_labels,sindex]=sort(train_labels);    % we sort the labels to ensure that the first label is '1', the second '2' etc
train_data=train_data(sindex,:);
test_labels     = labels(testset);           % contains the labels of the testset
test_data       = BOW(:,testset)';           % contains the test data

%% manual cross-validation
max_acc = -1;
max_cc = -1;
max_g = 0.5;
val_max_g = 0.8;
pos_max_g = 1;
vg = [10 20 30 40 50];
for cc=250%1:10:500
    for gc=1:size(vg,2)
        indices = crossvalind('Kfold',test_labels,5);
        meanap = zeros(1,5);
        meang = zeros(size(vg));
        options=sprintf('-t 2 -g %f -c %f -b 1',vg(gc),cc);
        for i=1:5
            test_c = (indices == i);
            test_labels_c = test_labels(test_c);
            test_data_c = test_data(test_c,:);
            train_labels_c = train_labels(~test_c);
            train_data_c = train_data(~test_c,:);
            model = svmtrain(train_labels_c,train_data_c,options);
            [predict_label, accuracy , dec_values] = svmpredict(test_labels_c,test_data_c, model,'-b 1');
            meanap(i) = mean_ap(eventopts,dec_values,test_labels_c);
        end
        meang(gc) = mean(meanap);
        
    disp(['Mean Average Precision: ' num2str(mean(meanap))])
    if (mean(meanap) > max_acc)
        max_acc = mean(meanap);
        max_cc = cc;
        [val_max_g, pos_max_g] = max(meang);
        max_g = vg(pos_max_g);
    end
    end
end

%% here you should of course use crossvalidation !
% % cc=50;
% max_acc = -1;
% max_cc = -1;
% for cc=1:10:100
%     options=sprintf('-t 0 -c %f -v 5 -b 1',cc);
%     model=svmtrain(train_labels,train_data,options);
%     if (model > max_acc)
%         max_acc = model;
%         max_cc = cc;
%     end
% end
max_cc

options=sprintf('-t 2 -g %f -c %f -b 1',max_g,max_cc);
max_g
model=svmtrain(train_labels,train_data,options);
[predict_label, accuracy , dec_values] = svmpredict(test_labels,test_data, model,'-b 1');
