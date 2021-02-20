function [rank,index_1] = MyRetrieval(Wx,D,normalized_X_1_test , normalized_X_2_test , ld)
%ld latent space dimension
temp = Wx*D;
test_out = [normalized_X_1_test,normalized_X_2_test]*temp;%693*138;
P1 = test_out(:,1:ld);
P2 = test_out(:,129:128+ld);
D1 = dist_mat(P1,P2);
[sorted,index_1] = sort(D1,2);

n_1_test = size(normalized_X_1_test,1);
n_2_test = size(normalized_X_2_test,1);
%assuming n_1_test = n_2_test and tests are already paired one to one
rank = zeros(n_1_test,1);
for i = 1:n_1_test
    temprow = index_1(i,:);
    rank(i,1) = find(temprow == i);
end
