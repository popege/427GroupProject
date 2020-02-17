function []=anz_meteor3(filein, inps);
%clear all
%close all
%% analyze Arecibo data for meteor parameters
% Q. Zhou, Jan. 2015

% get input file. 
%if nargin <= 0, 
                % have user input file
    %input_filename = ['G:/EGR/Zhouq/projects', input('Enter a File (PWR directory & FileName): ','s')]
    %   e.g., pwr99/ne9902.dat
    %input_filename='C:\Users\zhouq\Documents\ISR201501\t2963_20150102.104'
    %input_filename='F:\t1193_Jun2009_rawIL\t1193_24jun2009.023'
    input_filename='t3150_20170104.022'
%end


fid=fopen(input_filename, 'r', 'b');        %open the input data file
if fid <=0, disp( [ 'Cannot open input file: ', input_filename,]); return, end

outfile=['out3150_20170106.029.hdr'];
outfid=fopen(outfile, 'w');


%%%%%%%%%%%%%%%%%%%%%%% read in all the records  %%%%%%%%%%%%%%%%%%%%%%

eof=0;  
ip1rec=point2begrec(fid);
ndatpts_1=-1;
nsum = -1;
% irec = ith record
% date = date
% ast_hr = hour in AST
% ndat/rec = number of data points per record
% az = azimuth angle
% rfL = radio frequency length
% IPP = Inter pulse period (1/PRF)
% gd = Gate delay ex:     Tx      Receive
%                    _____--______-----____
%                        |--------| = Gate delay
% nipp = number of IPP per record
header1='irec   date   ast_hr ndat/rec az  rfL IPP nTx  gd nipp';
datFormat='\n %5i %8i %5.2f %6i %4.1f %3i %3i %3i %4i %2i';
fprintf('\n %s', header1);
fprintf(outfid, '\n %s', ['data file:     ', input_filename]);
fprintf(outfid, '\n %s', ['irec is when number of data points', ...
'in a record changes.']);
fprintf(outfid, '\n \n %s', header1);

for irec=1:999999,
    
    [hdr,ihdr,fhdr,dat1r,eof]=readrec(fid);
    if eof; break, end;
    
    [hdr]=interpret_raw2(hdr, ihdr, fhdr);
    
    % meteor data has a RF length of 440 and ?. floating data is dat1r
    if (hdr.rfLen == 200) 
        % cxd1r = complex data of 1 record
        cxd1r=iq2complex(dat1r);        % convert iq into complex data
        ntot_pts=length(cxd1r);         % get total num points in cxd1r
        npts_1p=ntot_pts/hdr.ippsPerBuf; % total points / (num points/record)
        if npts_1p ~= floor(npts_1p),   % make sure all are integers (rarely an issue, safety net) 
            fprintf('\n, %s', 'Warning: non-integer npts_1p');
        end
        
        % do pwr processing, including finding the avg pwr
        % initial case scenario
        if nsum==-1;            % at the very beginning of a file 
            sumPwr = abs(cxd1r).^2;
            sumAng = angle(cxd1r);
            nsum = 1;
            if hdr.ippsPerBuf > 1;
                sumPwr2d= reshape(sumPwr, npts_1p, hdr.ippsPerBuf);
                avgPwr1p = mean(sumPwr2d')/nsum;
            else
                avgPwr1p=sumPwr;
            end
        elseif nsum == 200,              % output and start a new sum
            % find the avg power for over the length of 1 pulse
            if hdr.ippsPerBuf > 1;
                sumPwr2d= reshape(sumPwr, npts_1p, hdr.ippsPerBuf);
                avgPwr1p = mean(sumPwr2d')/nsum;
            else
                avgPwr1p=sumPwr/nsum;
            end

            % plot the avg over a record 
            figure(1)       % Raw data, avg over record of 200 pulses
            subplot(3, 1, 1)
            semilogy( sumPwr, '.'); 
            title( ['nsum = ', num2str(nsum),' Date & time:', ...
                num2str(hdr.date),'   ',num2str(hdr.asthr)])
            xlabel('Data index'); ylabel('uncalibrated power');
            axis tight;grid
            subplot(3, 1, 2)
            
            % old code I think...
            % plot(sumAng/nsum, '.')
            % xlabel('Data index'); ylabel(' avg phase angle (rad)');
            
            % plot raw power of single pulse. i.e. 200 of these will be
            % averaged for above plot
            semilogy(abs(cxd1r), '.')
            xlabel('Data index'); ylabel(' pwr of one pulse');
            axis tight;grid;
            
            % plot phase difference of one pulse
            subplot(3, 1, 3)
            plot(diff(angle(cxd1r)), '.');
            xlabel('Data index'); ylabel(' one pulse del-phase (rad)');
            axis tight;grid;
            %pause(2);  % this slows down the program
        
            % start a new sum
            sumPwr = abs(cxd1r).^2;
            sumAng = angle(cxd1r);
            nsum = 1;
        else                    % keep adding
            sumPwr =sumPwr+abs(cxd1r).^2;
            sumAng = sumAng + angle(cxd1r);
            nsum = nsum +1;
        end  
        
        % process each pulse within a record
        for ip=1:hdr.ippsPerBuf;
            beg_pos=(ip-1)*npts_1p+1;
            end_pos=ip*npts_1p;
            cxd1p=cxd1r(beg_pos:end_pos);
            [meteor]=meteor_stat3(cxd1p, avgPwr1p, hdr);    
            % avgPwr1p is before the current pulse except at the beginning. 
        end
    end
 
  
    
    %output header to screen and/or a file
    paraOut={irec, hdr.date, hdr.asthr, hdr.datnp, hdr.az, ... 
         hdr.rfLen, hdr.ripp/1000, hdr.nTxSmp, hdr.gd, hdr.ippsPerBuf};
     % write to a file if there is a change in program
    if hdr.datnp ~= ndatpts_1 | irec==1,          
        fprintf(outfid,  datFormat,  paraOut{:} );
        fprintf( datFormat, paraOut{:} );
        ndatpts_1=hdr.datnp;
    end
    
end



% display or write to file the last record
fprintf( datFormat, paraOut{:} );
fprintf(outfid,  datFormat,  paraOut{:} );

disp( sprintf('\n record number read= %g', irec) );

fclose(fid);
fclose(outfid);

return