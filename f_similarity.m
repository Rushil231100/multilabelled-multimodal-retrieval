function [similarity_value] = f_similarity(Z_i_g,Z_j_h)

%Z_i_g = C x 1 column vector of labels for the gth data point in ith modality (can be made up of 0 1 or some weights w_k)
% Z_j_h = C x 1 column vector of labels for the hth data point in jth modality 
similarity_value = dot(Z_i_g,Z_j_h)/(norm(Z_i_g)*norm(Z_j_h));


