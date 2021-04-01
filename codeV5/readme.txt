Loading the features and label matrices:

>>>load('wikipedia_raw_features_labelled.mat')

Learning the latent space: f_similarity = "dot_product" or "squared_exponent"

>>>[Wx,D] = UnpairedCCA2(I_tr,T_tr,Z_tr,Z_tr,"dot_product");

Testing Image to Text:ld = 5, d_power = 4.

>>>[mAP,mAP_euclidian] = MyRetrieval(Wx,D,I_te,T_te,Z_te,Z_te,5,4)

