% opens file, returns 3 arrays of hdrs and data, seperated by rfLen.
% example run:  [arr_440s, arr_200s, arr_52s] = get_all_records();
% the arrays will look like this, [{hdr, data} , {hdr, data} ,... etc}]
function [arr_440s, arr_200s, arr_52s] = get_all_records()
%CONTROLS
input_filename='t3150_20170104.022'

%check if files are valid
fid=fopen(input_filename, 'r', 'b');        %open the input data file
if fid <=0, disp( [ 'Cannot open input file: ', input_filename,]); return, end

ip1rec=point2begrec(fid); %somehow formats the open file
eof=0; 

%counters for each array.
count_440 = 1;
count_200 = 1;
count_52 = 1;

for irec=1:999999,
    
    [hdr,ihdr,fhdr,dat1r,eof]=readrec(fid);
    
    if eof; break, end;
    
    [hdr]=interpret_raw2(hdr, ihdr, fhdr);
    
    index = struct('header',hdr,'data',dat1r); %creates a new object, {header, data}
    
    if(hdr.rfLen == 440)
        arr_440s(count_440) = index;
        count_440 = count_440 + 1;
    elseif(hdr.rfLen == 200)
        arr_200s(count_200) = index;
        count_200 = count_200 + 1;
    else
        arr_52s(count_52) = index;
        count_52 = count_52 + 1;
    end
end

end