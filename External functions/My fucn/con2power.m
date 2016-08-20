function [Y]  = con2power(X)


X(isnan(X)) = 0 ;
for i=1:size(X,1)
    M(i,i)=0;
    m1(i) = mean(X(i,:));
    m2(i) = mean(X(:,i));
    
end
Y = m1 + m2;