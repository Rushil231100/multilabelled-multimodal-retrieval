function [mAP,mAP21] = MyRetrieval3(Wx,D,p_each,g,h,X_1_test , X_2_test ,Z_1_test,Z_2_test, ld , D_power)
%<g,h> = modality index for which the test code is to run
new_Wx = zeros(p_each(g,1)+p_each(h,1),sum(p_each));
new_Wx(1:p_each(g,1),:) = Wx(sum(p_each(1:g-1)) + 1 : sum(p_each(1:g-1))+p_each(g,1) ,:);
new_Wx(p_each(g,1)+1 :p_each(g,1)+p_each(h,1),:) = Wx(sum(p_each(1:h-1)) + 1 : sum(p_each(1:h-1))+p_each(h,1) , :);
save('new_Wx');
[mAP,mAP21] = MyRetrieval(new_Wx,D,X_1_test , X_2_test ,Z_1_test,Z_2_test, ld , D_power);