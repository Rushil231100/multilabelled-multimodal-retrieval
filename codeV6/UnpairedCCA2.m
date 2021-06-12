function [Wx,D] = UnpairedCCA2(X_1, X_2 , Z_1, Z_2,f_type)


% implements the 2 view unpaired multilabel CCA
% X_1 = n_1 * p_1 feature matrix for X_1 modality.
% X_2 = n_2 * p_2
%Z_1 = n_1 * C sized label matrix or images
%Z_2 = n_2 * C sized label matrix for texts
[n_1,p_1] = size(X_1);
[n_2,p_2] = size(X_2);

X_1 = MyNormalization(X_1);
X_2 = MyNormalization(X_2);

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
        S_11 = S_11 + f_similarity(Z_1(g,:),Z_1(h,:),f_type)*X_1(g,:)'*X_1(h,:);
    end
end

%for S_12
for g = 1:n_1
    for h = 1:n_2
        S_12 = S_12 + f_similarity(Z_1(g,:),Z_2(h,:),f_type)*X_1(g,:)'*X_2(h,:);
    end
end

%for S_21
%S_21 = S_12'; done later when scaling

%for S_22
for g = 1:n_2
    for h = 1:n_2
        S_22 = S_22 + f_similarity(Z_2(g,:),Z_2(h,:),f_type)*X_2(g,:)'*X_2(h,:);
    end
end
%division for n
S_11 = S_11/((n_1)*(n_1));
S_12 = S_12/((n_1)*(n_2));
S_22 = S_22/((n_2)*(n_2));
%for S_21
S_21 = S_12';



C_all = [S_11,S_12; S_21 , S_22] + reg*eye((p_1 + p_2),(p_1 + p_2));
C_diag = [S_11, zeros(p_1 ,p_2) ;zeros(p_2 ,p_1),S_22 ] + reg*eye((p_1 + p_2),(p_1 + p_2));

[V,D] = eig(double(C_all),double(C_diag));
disp('done eigen decomposition');
%[a, index] = sort(diag(D),'descend');
%D = diag(a);
%V = V(:,index);
Wx = V;































