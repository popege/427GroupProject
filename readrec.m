
function [hdr,ihdr,fhdr,datar,eof]=readrec(fid)
% Reads any kind of Arecibo records (e.g., MRACF, Power, raw ) 
% Header format adopted by Phil in jan-2000
% modified from Nestor's readrec by QHZ on Oct. 24, 2002.
% output is now a hdr structure that contains the standard header word.

% Description of variables
% dataid - program id (e.g., 'pwr', 'mra', 'top', 'raw') 
% hdr   - header part of record
% ihdr  - integer interpretation of a header
% fhdr  - floating interpretation of a header
% datar - data part of record 
% asthr - time in hours (AST) 
%
% Modified by QHZ to add raw data reading capability on Feb. 22
%%

%open the file from here for test purpose
%fid=fopen('G:\EGR\Zhouq\rodgermp\pwr99\ne9902.dat1', 'r', 'b');


iposb=ftell(fid);                           % beginning position
[hdrstd, count]=fread(fid,32,'long');       %read in the 32 standard words
if count < 32,
    hdr.datid='norec'; ihdr=0; fhdr=0; datar=0;     % prevents warning for not assigning these variables
    eof=feof(fid)
    return
end

ipos=ftell(fid);
fseek(fid,12-(ipos-iposb),0);              % go to pos. 12 from beg. of rec
b=fread(fid,3,'char');
ipos=ftell(fid);                           %check curr. position
dataid=char(b');                            % 3 letter program id (mra, pwr tps)

% This condition prevents errors when program reads a record that
% has not been fully written (in real time monitor)  
%if (strcmp(dataid','pwr') == 0) & (strcmp(dataid','mra') == 0) & ...
%   (strcmp(dataid','top') == 0) & (strcmp(dataid','clp') == 0) & ...
%   (strcmp(dataid','raw') ==0),            % check all posibilites, if none, return
%   dataid='norec';
%   return
%end

lenhdr=hdrstd(2);                       % header length in bytes
lenrec=hdrstd(3);                       % record length in bytes
nwhdr=lenhdr/4;                         % number of words in header 

%read in full header and data
fseek(fid,-(ipos-iposb),0);            %go back to beg. of rec 
ihdr=fread(fid,nwhdr,'long');        %read all the header words and interpret them as long integer
ipos=ftell(fid);                       %check curr. position
fseek(fid,-(ipos-iposb),0);            %go back to beg. or rec 
fhdr=fread(fid,nwhdr,'float');         %read all the header words and interpret them as floats
if strcmp(dataid, 'raw')
    nwinrec=(lenrec-lenhdr)/2;             % number of data words in record
    datar=fread(fid,nwinrec,'short');    %read raw data
else
    nwinrec=(lenrec-lenhdr)/4;             % number of data words in record
    datar=fread(fid,nwinrec,'float32');   % read floating data in the record
end
%ftell(fid)

%interpret commonly used standard header words and put them in the hdr.structure
hdr.lenhdr=ihdr(2);                       %length of header in bytes
hdr.lenrec=ihdr(3);                       %length of record in bytes
hdr.datid=dataid;                        %3-letter data ID, 'pwr', 'clp' etc.
hdr.datnp=nwinrec;                       %# of float data points in record
hdr.date=ihdr(7);                        %date when the record was taken
hdr.asthr=ihdr(8)/3600. ;                %AST hour
hdr.ntrg=ihdr(24);                       %total # of rec in group
hdr.icrg=ihdr(25);                       %current rec # in group
hdr.az=ihdr(27)/10000. ;                 %azimuth position of the gregorian feed, or pointing of linefeed
hdr.zag=ihdr(28)/10000. ;                %zenith angle of gregorian feed.
hdr.zal=ihdr(29)/10000.  ;               %zenith angle of line feed

eof=feof(fid);

