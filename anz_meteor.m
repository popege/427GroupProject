function []=anz_meteor(filein, inps);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROLS                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PLOT = false;
PAUSE = false;
data_point_skip = 2000;
PRINT_STANDARD = true;
RF_FREQUENCY = 270; %original 440, 270 is optimal for meteor detection
% meteor data has a RF length of 270. floating data is dat1r

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% produce a file containing the header information

% get input file. 
if nargin <= 0, 
                % have user input file
    %input_filename = ['G:/EGR/Zhouq/projects', input('Enter a File (PWR directory & FileName): ','s')]
    %   e.g., pwr99/ne9902.dat
    % input_filename='C:\Users\zhouq\Dropbox\t2574_20dec2011.092',
    % input_filename='C:\Users\zhouq\Dropbox\04jul2006c2.spec'
    input_filename='t3150_20170104.022'
end

fid=fopen(input_filename, 'r', 'b');        %open the input data file
if fid <=0, disp( [ 'Cannot open input file: ', input_filename,]); return, end

outfile=['out3150_20170106.029.hdr'];
outfid=fopen(outfile, 'w');


%%%%%%%%%%%%%%%%%%%%%%% read in all the records  %%%%%%%%%%%%%%%%%%%%%%

eof=0;  
ip1rec=point2begrec(fid);
ndatpts_1=-1;
nsum = 0;

header1='irec   date   ast_hr ndat/rec az  rfL IPP nTx  gd nipp';
datFormat='\n %5i %8i %5.2f %6i %4.1f %3i %3i %3i %4i %2i';
fprintf('\n %s', header1);
fprintf(outfid, '\n %s', ['data file:     ', input_filename]);
fprintf(outfid, '\n %s', ['irec is when number of data points', ...
'in a record changes.']);
fprintf(outfid, '\n \n %s', header1);

for irec=1:990099,
    
    [hdr,ihdr,fhdr,dat1r,eof]=readrec(fid);
    [hdr]=interpret_raw2(hdr, ihdr, fhdr);
    
    % meteor data has a RF length of 270. floating data is dat1r
    if (hdr.rfLen == RF_FREQUENCY) %original set to 440
        cxd1r=iq2complex(dat1r);        % convert record into complex
        if hdr.datnp ~= ndatpts_1 | nsum == 50,              % start a new sum
            if nsum > 1, 
                    if PLOT
                    subplot(3, 1, 1)
                    semilogy( sumPwr, '.'); 
                    title( ['nsum = ', num2str(nsum),' Date & time:', ...
                        num2str(hdr.date),' ',num2str(hdr.asthr)])
                    xlabel('Data index'); ylabel('uncalibrated power');
                    axis tight;grid
                    subplot(3, 1, 2)
                    % plot(sumAng/nsum, '.')
                    % xlabel('Data index'); ylabel(' avg phase angle (rad)');
                    semilogy(abs(cxd1r), '.')
                    xlabel('Data index'); ylabel(' pwr of one pulse');
                    axis tight;grid;
                    subplot(3, 1, 3)
                    plot(diff(angle(cxd1r)), '.');
                    xlabel('Data index'); ylabel(' one pulse del-phase (rad)');
                    axis tight;grid;
                    if PAUSE
                        pause(2);  % this slows down the program
                    end
                end
            end
            sumPwr = abs(cxd1r).^2;
            sumAng = angle(cxd1r);
            nsum =1;
        else
            sumPwr =sumPwr+abs(cxd1r).^2;
            sumAng = sumAng + angle(cxd1r);
            nsum = nsum +1;
        end  
    end
    
    paraOut={irec, hdr.date, hdr.asthr, hdr.datnp, hdr.az, ... 
         hdr.rfLen, hdr.ripp/1000, hdr.nTxSmp, hdr.gd, hdr.ippsPerBuf};
     % write to a file if there is a change in program
    if hdr.datnp ~= ndatpts_1 | irec==1,  
        if PRINT_STANDARD
            fprintf(outfid,  datFormat,  paraOut{:} );
            fprintf( datFormat, paraOut{:} );
            ndatpts_1=hdr.datnp;
        end
    end
    % write to screen
     if floor(irec/data_point_skip)*data_point_skip == irec | irec==1, 
         if ~PRINT_STANDARD
            fprintf( datFormat, paraOut{:} );
         end
     end
    
    if eof; break, end;
    
end



% display or write to file the last record
fprintf( datFormat, paraOut{:} );
fprintf(outfid,  datFormat,  paraOut{:} );

disp( sprintf('\n record number read= %g', irec) );

fclose(fid);
fclose(outfid);

return