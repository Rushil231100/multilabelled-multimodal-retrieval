function [sum_1,sum_euclidian, index] = MyRetrieval(Wx,D,X_1_test , X_2_test ,Z_1_test,Z_2_test, ld , D_power)
%ld latent space dimension
normalized_X_1_test = MyNormalization(X_1_test);
normalized_X_2_test = MyNormalization(X_2_test);

[n_1_t,p_1_t] = size(X_1_test);
[n_2_t,p_2_t] = size(X_2_test);
W_1 = Wx(1:p_1_t,1:ld);%128 x ld 

%temp = Wx*(D^D_power);%138*d
W_2 = Wx(p_1_t+1 : p_1_t+p_2_t,1:ld);%p_1_t + ld %10 x ld
D_1 = D(1:ld,1:ld);
D_2 = D(p_1_t+ 1 :p_1_t +ld,p_1_t+ 1 :p_1_t + ld);

D_1 = D_1^D_power;
D_2 = D_2^D_power;

result_matrix = zeros(n_1_t,n_2_t);
for i = 1:n_1_t
    for j = 1 :n_2_t
        result_matrix(i,j) = f_similarity(normalized_X_1_test(i,:)*W_1*D_1,normalized_X_2_test(j,:)*W_2*D_2,"dot_product");
    end
end
P_1 = normalized_X_1_test*W_1*D_1;
P_2 = normalized_X_2_test*W_2*D_2;
result_matrix_euclidian = dist_mat(P_1,P_2);
[a_euclidian, index_euclidian] = sort(result_matrix,2);

[a, index] = sort(result_matrix,2,'descend');
sum_1 = zeros(n_1_t,1);
sum_euclidian = zeros(n_1_t,1);
for i = 1:n_1_t
    temp_sum_1 = 0;
    temp_sum_euclidian = 0;
    for j = 1 : 10 %top ten
        temp_sum_1 = temp_sum_1 + f_similarity(Z_2_test(index(i,j),:), Z_1_test(i,:),"dot_product");
        temp_sum_euclidian = temp_sum_euclidian + f_similarity(Z_2_test(index_euclidian(i,j),:), Z_1_test(i,:),"dot_product");
    end
    sum_1(i) = temp_sum_1/10;
    sum_euclidian(i) = temp_sum_euclidian/10;
end
aaa = sum(sum_1 == 0)
aaa_euclidian = sum(sum_euclidian == 0)

