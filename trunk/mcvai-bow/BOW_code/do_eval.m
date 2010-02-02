function [rec,prec,ap] = do_eval(opts,cls_index,score)
% Mark Everigham (adapted by Joost van de Weijer)
draw=1;

load(opts.testset);
load(opts.labels);
gt=(labels(testset)==cls_index);   % images in test set which belong to class cls_index

% compute precision/recall

[so,si]=sort(-score);
tp=gt(si)>0;
fp=gt(si)==0;

fp=cumsum(fp);
tp=cumsum(tp);
rec=tp/sum(gt>0);
prec=tp./(fp+tp);

% compute average precision

ap=0;
for t=0:0.1:1
    p=max(prec(rec>=t));
    if isempty(p)
        p=0;
    end
    ap=ap+p/11;
end

if draw
    % plot precision/recall
    plot(rec,prec,'-');
    grid;
    xlabel 'recall'
    ylabel 'precision'
    title(sprintf('class: %s, AP = %.3f',opts.classes{cls_index},ap));
    axis([0 1 0 1]);
end
