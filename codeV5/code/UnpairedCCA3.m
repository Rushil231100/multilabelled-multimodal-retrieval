function [Wx,D,p_each] = UnpairedCCA3(C_x ,C_z,f_type)
[~,n_modality] = size(C_x)
if(size(C_x) ~= size(C_z))
    disp("CHECK INPUT");
    exit(1);
end
reg = 0.0001;
n_each=zeros(n_modality,1);
p_each=zeros(n_modality,1);
for i = 1:n_modality
    [n_each(i),p_each(i)]=size(C_x{1,i});
    C_x{1,i} = full(MyNormalization(C_x{1,i}));
end
C_all = zeros(sum(p_each),sum(p_each));
C_diag = zeros(sum(p_each),sum(p_each));
start_point_x  = 1;start_point_y = 1;
for i = 1:n_modality%
    for j = i:n_modality
        %start_point_y = start_point_y + p_each(j,1);
        S_ij = zeros(p_each(i,1),p_each(j,1));
        for g = 1:n_each(i,1)
            for h = 1:n_each(j,1)
                S_ij = S_ij + f_similarity(C_z{1,i}(g,:),C_z{1,j}(h,:),f_type)*C_x{1,i}(g,:)'*C_x{1,j}(h,:);
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
C_diag = C_diag + reg*eye(sum(p_each),sum(p_each));
[Wx,D] = eig(double(C_all),double(C_diag));
disp('done eigen decomposition');
