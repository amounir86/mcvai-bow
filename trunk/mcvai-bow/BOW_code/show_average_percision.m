%% show results
% shows the most probable images for each of the classes

load(eventopts.trainset);
load(eventopts.testset);
load(eventopts.labels);

indexes=1:eventopts.nimages;
test_indexes=indexes(testset);
percision = [1:eventopts.nclasses];

for ii=1:eventopts.nclasses
    % Working now with class "ii"
    predicted_class = find(predict_label == ii);
    actual_class = find(test_labels == ii);
    correct = intersect(actual_class, predicted_class);
    % Get the TP
    TP = length(correct);
    % Get the FP
    FP = length(predicted_class) - length(correct);
    % Get the Percision = TP / (TP + FP)
    percision(ii) = TP / (TP + FP);
end

averagePercision = 100 * sum(percision) / eventopts.nclasses;
fprintf(1, 'Average percision = %2.4f%%\n', averagePercision);