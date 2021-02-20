function [Wx, D] = UnpairedCCA2(X_1, X_2 , Z_1, Z_2)

% what happens if we normalize the features / L2 
% implements the 2 view unpaired multilabel CCA
% X_1 = p_1 * n_1 feature matrix for X_1 modality.
% X_2 = p_2 * n_2
%Z_1 = c * n_1 sized label matrix or images
%Z_2 = c * n_2 sized label matrix for texts
[p_1,n_1] = size(X_1);
[p_2,n_2] = size(X_2);

%calculating mean accross the columns, which will give mean of values for a
%particular feature for all the n data samples.
mean_X_1 = mean(X_1,2); %p_1 *1 column vector
mean_X_2 = mean(X_2,2); %p_2 *1 column vector

var_X_1 = sqrt(var(X_1,0,2));
var_X_2 = sqrt(var(X_2,0,2));
%making the effective mean 0 and deviation 1. Gaussian distribution
X_1 = (X_1 - repmat(mean_X_1,1,n_1))./repmat(var_X_1,1,n_1);
X_2 = (X_2 - repmat(mean_X_2,1,n_2))./repmat(var_X_2,1,n_2);

%L2 normalization for a particular feature generalized for all.
l2_norm_1 = sqrt(sum(X_1.^2,2));
l2_norm_2 = sqrt(sum(X_2.^2,2));

X_1 = (X_1)./repmat(l2_norm_1,1,n_1);
X_2 = (X_2)./repmat(l2_norm_2,1,n_2);

X_1 = full(X_1);
X_2 = full(X_2);
%disp(size(T));
%XX = [X,T];
%index = [ones(size(X,2),1);ones(size(T,2),1)*2];
%[V, D] = UnpairedMultiviewCCA(XX, index, 0.0001);
reg = 0.0001;
%C_all = zeros((p_1 + p_2),(p_1 + p_2));
%C_diag = zeros((p_1 + p_2),(p_1 + p_2));
S_11 = zeros(p_1 ,p_1);
S_12 = zeros(p_1 ,p_2);
S_21 = zeros(p_2 ,p_1);
S_22 = zeros(p_2 ,p_2);
%for S_11
for g = 1:n_1
    for h = 1:n_1
        S_11 = S_11 + f_similarity(Z_1(:,g),Z_1(:,h))*X_1(:,g)*X_1(:,h)';
    end
end

%for S_12
for g = 1:n_1
    for h = 1:n_2
        S_12 = S_12 + f_similarity(Z_1(:,g),Z_2(:,h))*X_1(:,g)*X_2(:,h)';
    end
end

%for S_21
%S_21 = S_12'; done later when scaling

%for S_22
for g = 1:n_2
    for h = 1:n_2
        S_22 = S_22 + f_similarity(Z_2(:,g),Z_2(:,h))*X_2(:,g)*X_2(:,h)';
    end
end
%division for n
S_11 = S_11/((n_1)*(n_1));
S_12 = S_12/((n_1)*(n_2));
S_22 = S_22/((n_2)*(n_2));
%for S_21
S_21 = S_12';



C_all = [S_11,S_12; S_21 , S_22] + reg*eye((p_1 + p_2),(p_1 + p_2));
C_diag = [S_11, zeros(p_1 ,p_2) ;zeros(p_2 ,p_1),S_22 ] + + reg*eye((p_1 + p_2),(p_1 + p_2));

[V,D] = eig(double(C_all),double(C_diag));
disp('done eigen decomposition');
[a, index] = sort(diag(D),'descend');
D = diag(a);
V = V(:,index);
Wx = V;































