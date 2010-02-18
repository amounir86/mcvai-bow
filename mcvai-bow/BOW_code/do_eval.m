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

col = 'NONE';
switch cls_index
    case 1
        col = 'yo-'
    case 2
        col = 'm^-'
    case 3
        col = 'r+-'
    case 4
        col = 'g+-'
    case 5
        col = 'cd-'
    case 6
        col = 'b^-'
    case 7
        col = 'k-'
    otherwise
        'Hi';
end

grid on

if draw
    % plot precision/recall
%     plot(rec,prec,'-', 'Color', col);
      plot(rec,prec, col, 'LineWidth',2);
%     grid;
    xlabel 'recall'
    ylabel 'precision'
%     gtext(sprintf('class: %s, AP = %.3f',opts.classes{cls_index},ap), 'Color', col);
    axis([0 1 0 1]);
end
