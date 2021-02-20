function [Z] = generatingLabelMatrix(categoryValue,n_unique_labels)
%categoryValue a matrix of n_data_samples x n_labels_assigned
%n_unique_labels is total number of unique lables space set from which one
%of these can be assigned. 
n_data_samples = size(categoryValue,1);%total number of samples
n_labels_assigned = size(categoryValue,2);%total number of labels being assigned to a data sample. 
%If all the samples are assigned upto 2 labels from a set of 10 labels then n_labels_assigned=2 and n_unique_labels=10
Z = zeros(n_data_samples,n_unique_labels);
for i = 1:n_data_samples
    for j =1:n_labels_assigned
        Z(i,categoryValue(i,j))=1;
    end 
end


