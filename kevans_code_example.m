function arr = kevans_code_example;
     %This reads in the input file, then filters by rfLength.
     %arr_440s is an array of 440s where each cell contains both the header
     %  and the data as so {header, data}
     [arr_440s_f1, arr_200s_f1, arr_52s_f1] = get_all_records('t3150_20170104.022');
     [arr_440s_f2, arr_200s_f2, arr_52s_f2] = get_all_records('t3150_20170104.022');
     
     %conglomerate 
     arr_440s = [arr_440s_f1, arr_440s_f2];
     arr_200s = [arr_200s_f1, arr_200s_f2];
     arr_52s  = [arr_52s_f1, arr_52s_f2];
     
     %example of obstracting this data
     fprintf('\nthis is a header (hdr)\n')
     arr_440s(1).header
     
     fprintf('\nthese are the first 5 data points of index (record) 1\n')
     all_data_points = arr_440s(1).data;
     first_five = all_data_points(1:5);
     fprintf('\t%g %g %g %g %g\n',first_five)
     9
     %filter for meteors
     meteors_200s = meteor_filter(arr_200s);
     meteors_440s = meteor_filter(arr_440s);
     meteors_52s = meteor_filter(arr_52s);
     
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
     c=1;
     for i = 1:size(meteors_440s,2)
         arr_heights(c)=meteors_440s(i).meteor_stats.ht;
         arr_times(c)=meteors_440s(i).meteor_stats.time;
         arr_velocitys(c) = meteors_440s(i).meteor_stats.vel;
         c = c+1;
     end
     for j = 1:size(meteors_200s,2)
         arr_heights(c)=meteors_200s(j).meteor_stats.ht;
         arr_times(c)=meteors_200s(j).meteor_stats.time;
         arr_velocitys(c) = meteors_200s(j).meteor_stats.vel;
         c = c+1;
     end
     for z = 1:size(meteors_52s,2)
         arr_heights(c)=meteors_52s(z).meteor_stats.ht;
         arr_times(c)=meteors_52s(z).meteor_stats.time;
         arr_velocitys(c) = meteors_52s(z).meteor_stats.vel;
         c = c+1;
     end
     arr_temp= [ arr_heights; arr_times ];
     %sort by time
     arr = sortrows(arr_temp,2);
     arr2 = [ arr_heights; arr_velocitys];
     figure(1)
     scatter(arr(1,:),arr(2,:))
     title('Time vs Meteor Heights')
     xlabel('time')
     ylabel('height (km)')
     yline(85,'-','Thermosphere')
     % height vs velocity, mayeb this should be seperated by rflen? three
     % lines
     figure(2)
     arr2 = sortrows(arr2,1);
     plot(arr2(2,:),arr2(1,:))
     %atmosphere levels
     %Thermosphere 85 km to 500 km
     %Mesosphere 50 km to 85 km
     %stratospher 11 km to 50 km
     %troposphere 0 to 10 km
     
     
end