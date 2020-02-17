
function [hdr]=interpret_raw2(hdr, ihdr, fhdr)

%% Interpret Arecibo raw data header
% Modified by Q. Zhou Jan.13, 2015. 
% This version makes all parameters a field of hdr.
%%

BegRiPos=33;                % 33 for matlab 32 for IDL
hdr.SmpPairIpp=ihdr(BegRiPos+5);	%# of total sample pairs per ipp
hdr.ippsPerBuf=ihdr(BegRiPos+6);	%# of ipps per Buf
hdr.BegIppBuf1=ihdr(BegRiPos+7);	%beginning IPP # in this record, start from 1.
hdr.ripp=fhdr(BegRiPos+8);
hdr.gw=fhdr(BegRiPos+9);

%begSpsPos=offsets(3)/4		% should be 44 or 43 (Jan. 2015, =45)
BegSpsPos=45;

hdr.baudLen=fhdr(BegSpsPos+4);
hdr.txIppToRfOn=fhdr(BegSpsPos+7);
hdr.rfLen=fhdr(BegSpsPos+8);
hdr.nTxSmp=ihdr(BegSpsPos+36);
hdr.gd=fhdr(BegSpsPos+38);
hdr.ndatsmp=ihdr(BegSpsPos+39);
hdr.nCaNsmp=ihdr(BegSpsPos+42);
hdr.nNoiSmp=ihdr(BegSpsPos+43);

return



