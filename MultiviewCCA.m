function [V, D] = MultiviewCCA(X, index, reg)


% implements the multiview CCA method from F. Bach and M. I. Jordan.
% written by Yunchao Gong
% Y. Gong, Q. Ke, M. Isard, S. Lazebnik.  A Multi-View Embedding Space for Internet Images, Tags, and Their Semantics.
% Microsoft Research Technical Report (MSR-TR-2012-125). Under review: International Journal of Computer Vision


% X is the n*(d1+d2+...+dk) feature matrix
% X = [X1,X2,X3,...,Xk]
% index is the index of different feature views [1,1,1,2,2,2,2,3,3,3,3...]
% This implementation corresponds to average kernel K = K1 + K2 + ... + K_k
% output P is the projected data scaled by eigenvalue
% set power to be 2,3,or 4
% P = X*W*eigenvale = [X1,X2,...,X_k]*V*D; XX = 2173 * 138 , V*D = 138*138
%  P = 2173 * 138 , P(:,1:10) , P(:,129:138)
%I_te = 693 * 128 , T_te = 693*10
%P1 = P(:,1:10) ,P2 = P(:,129:138) %cosine similaty Use ascend ///not Descend
% if want projection for independent feature, simply do P(:,index_of_feature)


% some covariance matrixes
C_all = cov(X); %138 138 
disp(size(C_all));
C_diag = zeros(size(C_all));
disp('done covariance matrix 1');
for i=1:max(index)
    index_f = find(index==i);
    % also add regularization here
    C_diag(index_f,index_f) = C_all(index_f,index_f) + reg*eye(length(index_f),length(index_f));
    C_all(index_f,index_f) = C_all(index_f,index_f) + reg*eye(length(index_f),length(index_f));
end
disp('done covariance matrix 2');
% solve generalized eigenvalue problem
tic;
[V,D] = eig(double(C_all),double(C_diag));% v = 138 * 138
toc;%A*V = B*V*D, AV = BV
%[V,D] = eig(A,B) returns diagonal matrix D of generalized eigenvalues and full matrix V whose columns are the corresponding right eigenvectors, so that A*V = B*V*D.
disp('done eigen decomposition');
[a, index] = sort(diag(D),'descend');
D = diag(a);
V = V(:,index);%128 , 10 
%10 = latent space
%138*138, 138 * 1, 128+10
%10 of 128 and rest all w2
%w2*x2 , w1[1:10]*x1

