function [Wx,D,p_each] = UnpairedCCA3(C_x ,C_z,f_type)
%C_x : cell of size 1xN, where N is number of modality. Each cell contains
%the feature matrix in the form nxp. where n is number of data samples in
%that modality and p is number of fetures of that data.

%C_z : cell of size 1xN, where each cell contains label matrix of
%corresponding modality. 

%f_type : determines type of similarity function "dot_product" or "squared_exponent"

%Wx : matrix of eigen vectors , size (sum of features x sum of features)
%D : diagnol matrix of eigen values , size (sum of features x sum of features)
%p_each = matrix of size n_modality x 1 , where each row contains number of
%features in that corresponding modality.
tic;
[~,n_modality] = size(C_x)
if(size(C_x) ~= size(C_z))
    disp("CHECK INPUT");
    return;
    %exit(1);
end
reg = 0.0001;
n_each=zeros(n_modality,1);
p_each=zeros(n_modality,1);
parfor i = 1:n_modality
    [n_each(i),p_each(i)]=size(C_x{1,i})
    C_x{1,i} = full(MyNormalization(C_x{1,i}));
end
C_all = zeros(sum(p_each),sum(p_each));
C_diag = zeros(sum(p_each),sum(p_each));
start_point_x  = 1;start_point_y = 1;
for i = 1:n_modality%
    disp(i);
    for j = i:n_modality
        disp([i,j]);
        %start_point_y = start_point_y + p_each(j,1);
        S_ij = zeros(p_each(i,1),p_each(j,1));
        n_each_j  = n_each(j,1);%edit
        C_z_i= C_z{ 1 , i };
        C_z_j= C_z{ 1 , j };
        C_x_i= C_x{ 1 , i };
        C_x_j= C_x{ 1 , j };
        parfor g = 1:n_each(i,1)
            disp(g);
            zig = C_z_i(g,:);
            xig = C_x_i(g,:);
            for h = 1:n_each_j
                label_similarity =  f_similarity(zig,C_z_j( h , :),f_type);
                if (label_similarity > 0)
                    S_ij = S_ij + label_similarity*xig'*C_x_j( h , :);
                end
            end
        end
        
        S_ij = S_ij/(n_each(i,1)*n_each(j,1));
        
        C_all(start_point_x:start_point_x+p_each(i,1)-1, start_point_y:start_point_y+p_each(j,1)-1) = S_ij;
        if(i~=j)
            S_ji = S_ij';
            C_all(start_point_y:start_point_y+p_each(j,1)-1,start_point_x:start_point_x+p_each(i,1)-1) = S_ji;
        else
            C_diag(start_point_x:start_point_x+p_each(i,1)-1 , start_point_y:start_point_y+p_each(j,1)-1) = S_ij;
        end
        start_point_y = start_point_y+ p_each(j,1);
    end
    start_point_x = start_point_x+ p_each(i,1);
    start_point_y = start_point_x;
end
size(C_all);
C_all = C_all + reg*eye(sum(p_each),sum(p_each));
C_diag = C_diag + reg*eye(sum(p_each),sum(p_each))
[Wx,D] = eig(double(C_all),double(C_diag));
disp('done eigen decomposition');
execution_time = toc
