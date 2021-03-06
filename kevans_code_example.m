function arr = kevans_code_example(meteors_440s, meteors_200s, meteors_52s);
     %This reads in the input file, then filters by rfLength.
     %arr_440s is an array of 440s where each cell contains both the header
     %  and the data as so {header, data}
     %[arr_440s_f1, arr_200s_f1, arr_52s_f1] = get_all_records('t3150_20170106.000');
     %[arr_440s_f2, arr_200s_f2, arr_52s_f2] = get_all_records('t3150_20170106.001');
     
     %conglomerate 
     %arr_440s = [arr_440s_f1, arr_440s_f2];
     %arr_200s = [arr_200s_f1, arr_200s_f2];
     %arr_52s  = [arr_52s_f1, arr_52s_f2];
     
     %example of obstracting this data
     %fprintf('\nthis is a header (hdr)\n')
     %arr_440s(1).header
     
     fprintf('\nthese are the first 5 data points of index (record) 1\n')
     %all_data_points = arr_440s(1).data;
     %first_five = all_data_points(1:5);
     %fprintf('\t%g %g %g %g %g\n',first_five)
     
     %filter for meteors
     %meteors_200s = meteor_filter(arr_200s);
     %meteors_440s = meteor_filter(arr_440s);
     %meteors_52s = meteor_filter(arr_52s);
     
     %the same can be done for meteor arrays
     meteor_stats=meteors_52s(1).meteor_stats
     meteor_header=meteors_52s(1).header;
     meteor_data=meteors_52s(1).data;
     
     %not confirmed just number of hits
     fprintf('\nnumber of meteor detections per rfLen\n')
     fprintf('\n\trfLen of 440 found %g meteors\n',size(meteors_440s,2))
     fprintf('\trfLen of 200 found %g meteors\n',size(meteors_200s,2))
     fprintf('\trfLen of 52 found %g meteors\n',size(meteors_52s,2))
     
     %lets obstract all meteor heights
     %and times
     
     for i = 1:size(meteors_440s,2)
         arr_heights_440s(i)=meteors_440s(i).meteor_stats.ht;
         arr_times_440s(i)=meteors_440s(i).meteor_stats.time;
         if(i~=1 && arr_times_440s(i)<arr_times_440s(i-1))
             arr_times_440s(i) = arr_times_440s(i) + 24;
         end
     end
     for j = 1:size(meteors_200s,2)
         arr_heights_200s(j)=meteors_200s(j).meteor_stats.ht;
         arr_times_200s(j)=meteors_200s(j).meteor_stats.time;
         if(j~=1 && arr_times_200s(j)<arr_times_200s(j-1))
             arr_times_200s(j) = arr_times_200s(j) + 24;
         end
     end
     for z = 1:size(meteors_52s,2)
         arr_heights_52s(z)=meteors_52s(z).meteor_stats.ht;
         arr_times_52s(z)=meteors_52s(z).meteor_stats.time;
         if(z~=1 && arr_times_52s(z)<arr_times_52s(z-1))
             arr_times_52s(z) = arr_times_52s(z) + 24;
         end
     end
     arr_temp1= [ arr_heights_440s; arr_times_440s ];
     arr_temp2= [ arr_heights_200s; arr_times_200s ];
     arr_temp3= [ arr_heights_52s; arr_times_52s ];
     
     %sort by time
     arr1 = sortrows(arr_temp1,2);
     arr2 = sortrows(arr_temp2,2);
     arr3 = sortrows(arr_temp3,2);
     figure(1) % plot of heights at times
     scatter(arr1(1,:),arr1(2,:))
     hold on;
     scatter(arr2(1,:),arr2(2,:))
     hold on;
     scatter(arr3(1,:),arr3(2,:))
     legend('meteors440s','meteors200s','meteors52s');
     hold off;
     title('Time vs Meteor Heights')
     xlabel('time')
     ylabel('height (km)')
     
     %find number of meteors in a certain range of time
     
     %git the start and end times of each.
     start_time=min([arr1(1,1) arr2(1,1) arr3(1,1)])
     end_time=max([arr1(1,end) arr2(1,end) arr3(1,end)])
     
     %----good--pairs-----%
     %{5,20}
     % allowable rate may be 10 meteors per minute tops 
     % accourding to zhou article http://www.naic.edu/~djanches/Icarus00b.pdf
     %------controls------%
     num_divisions = 22; 
     
     tua = ( abs(end_time - start_time) ) / num_divisions %not a control!%
     if(end_time < start_time)
         warning('Meteor Times roll over into next day, this will cause a condensed graph')
     end
     limiting_factor = 0; %max number of meteors per instance
     limiting_factor = (tua*60)*10; %max number is 10 per minute, finds max per time tua
     %--------------------%
     
     
     %get arrays
     
     num_meteors_per_tua_440s = zeros(2,num_divisions + 1);
  
     c = 1;
     cur_tua = start_time;
     for i=1:length(arr1)
        if(arr1(1,i)<=cur_tua)
            if(num_meteors_per_tua_440s(1,c) < limiting_factor || limiting_factor == 0) %limiting factor
                num_meteors_per_tua_440s(1,c) = num_meteors_per_tua_440s(1,c) + 1;
            end
        else
            num_meteors_per_tua_440s(2,c) = cur_tua;
            c=c+1;
            cur_tua = cur_tua + tua;
        end
     end
     
     num_meteors_per_tua_200s = zeros(2,num_divisions + 1);
     c = 1;
     cur_tua = start_time;
     for i=1:length(arr2)
        if(arr2(1,i)<=cur_tua)
            if(num_meteors_per_tua_200s(1,c) < limiting_factor || limiting_factor == 0) %limiting factor
                num_meteors_per_tua_200s(1,c) = num_meteors_per_tua_200s(1,c) + 1;
            end
        else
            num_meteors_per_tua_200s(2,c) = cur_tua;
            c=c+1;
            cur_tua = cur_tua + tua;
        end
     end
     
     num_meteors_per_tua_52s = zeros(2,num_divisions + 1);
     c = 1;
     cur_tua = start_time;
     for i=1:length(arr3)
        if(arr3(1,i)<=cur_tua)
            if(num_meteors_per_tua_52s(1,c) < limiting_factor || limiting_factor == 0) %limiting factor
                num_meteors_per_tua_52s(1,c) = num_meteors_per_tua_52s(1,c) + 1;
            end
        else
            num_meteors_per_tua_52s(2,c) = cur_tua;
            c=c+1;
            cur_tua = cur_tua + tua;
        end
     end
     num_meteors_per_tua_440s;
     num_meteors_per_tua_200s;
     num_meteors_per_tua_52s;
     
     figure(2) % plot of heights at times
     %plot(1:length(num_meteors_per_tua_440s),num_meteors_per_tua_440s(1,:))
     plot(1:length(num_meteors_per_tua_440s),num_meteors_per_tua_440s(1,:))
     hold on;
     plot(1:length(num_meteors_per_tua_200s),num_meteors_per_tua_200s(1,:))
     hold on;
     plot(1:length(num_meteors_per_tua_52s),num_meteors_per_tua_52s(1,:))
     
     legend('meteors440s','meteors200s','meteors52s');
     hold off;
     title('Number of Meteors V. Time Interval')
     xlabel(['time interval of tua (tua = ',num2str(tua * 60),'min)'])
     ylabel('number of meteors')
     
     
     
end