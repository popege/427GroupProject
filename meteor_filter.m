%takes in from get_all_records one output array
%filters which ones are meteors and returns an array
function meteor_arr = meteor_filter(arr_of_hdr_and_data)
%----CONTROLS----%
    sum_size = 200; %averages n number of datapoints. this is used for smoothing
    PLOT = false;
%----------------%
    nsum = -1;
    meteor_counter = 1;
    for i = 1:size(arr_of_hdr_and_data,2)
        [hdr] = arr_of_hdr_and_data(i).header;
        [dat1r] = arr_of_hdr_and_data(i).data;
        
        %zhou code block 1;
        cxd1r=iq2complex(dat1r);        % convert iq into complex data
        ntot_pts=length(cxd1r);         % get total num points in cxd1r
        npts_1p=ntot_pts/hdr.ippsPerBuf; % total points / (num points/record)
        if npts_1p ~= floor(npts_1p),   % make sure all are integers (rarely an issue, safety net) 
            fprintf('\n, %s', 'Warning: non-integer npts_1p');
        end
        %
        
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
        elseif nsum == sum_size,              % output and start a new sum
            % find the avg power for over the length of 1 pulse
            if hdr.ippsPerBuf > 1;
                sumPwr2d= reshape(sumPwr, npts_1p, hdr.ippsPerBuf);
                avgPwr1p = mean(sumPwr2d')/nsum;
            else
                avgPwr1p=sumPwr/nsum;
            end
            if PLOT
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
            end
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
            [meteor]=meteor_stat3_kevan(cxd1p, avgPwr1p, hdr, PLOT); 
            if ~isempty(meteor)
                index = struct('meteor_stats',meteor,'header',hdr,'data',dat1r);
                meteor_arr(meteor_counter)=index;
                meteor_counter = meteor_counter + 1;
            end
            % avgPwr1p is before the current pulse except at the beginning. 
        end
        
    end
end