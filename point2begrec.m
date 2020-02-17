function [iposb]=point2begrec(fid);
%% position the file reading pointer to the beginning of a record.
% QHZ, Feb, 22, 2014.
%%
iposb=0;
beg4a=fread(fid, 4, 'char');
beg4c=char(beg4a');
while ~strcmp(beg4c, 'hdr_') 
    beg4a=fread(fid, 4, 'char');
    beg4c=char(beg4a');
    eof=feof(fid);
    if eof,
      disp(['hdr_ record not found after (bytes): ', num2str(iposb)]);
        return, 
    end
end
iposb=ftell(fid)-4;
fseek(fid, -4, 0);

disp(['Beginning of a record found at (bytes): ', num2str(iposb)]);


return