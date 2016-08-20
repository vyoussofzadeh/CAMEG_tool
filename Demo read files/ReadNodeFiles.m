fid=fopen('Node_AAL90.node','r');
s = '';
while ~feof(fid)
   line = fgetl(fid);
   if isempty(line), break, end
   s = strvcat(s,line);
end
dlmwrite('test.node',s,'delimiter','');
dlmwrite('test.node',s,'-append');
ave('test.node', 'var2',' -ASCII')
dlmwrite(filename,M,'-append')
