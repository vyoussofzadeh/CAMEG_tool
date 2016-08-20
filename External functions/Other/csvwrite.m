function csvwrite(fileName,cellArray)

fid = fopen(fileName,'w');
for i=1:size(cellArray,1)
    fprintf(fid,'%s,',cellArray{i,1:end-1});
    fprintf(fid,'%s\n',cellArray{i,end});
end
fclose(fid);