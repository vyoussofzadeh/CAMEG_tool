function [z] = zscore3D(data)

for i = 1:size(data,3)
    z(:,:,i) = zscore(data(:,:,i));
end
