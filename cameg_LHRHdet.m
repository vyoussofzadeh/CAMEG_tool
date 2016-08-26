function [LH, RH] = cameg_LHRHdet(ssROI)

for i = 1:size(ssROI,1)  
    R = ssROI.Label(i);
    if R{1}(1) == 'L'
        m(i) = 4;
    else
        m(i) = 3;
    end
end

% conns at left and right hemisphres
LH = find(m == 4);
RH = find(m == 3);

end