function arr1 = kevans_code_example;
     %This reads in the input file, then filters by rfLength.
     %arr is an array of 440s where each cell contains both the header
     %  and the data as so {header, data}
     [arr_440s, arr_200s, arr_52s] = get_all_records();
     
     %example of obstracting this data
     fprintf('\nthis is a header (hdr)\n')
     arr_440s(1).header
     
     fprintf('\nthese are the first 5 data points of index (record) 1\n')
     all_data_points = arr_440s(1).data;
     first_five = all_data_points(1:5);
     fprintf('\t%g %g %g %g %g\n',first_five)
     
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
     
     %lets abstract all meteor heights
     %and times
     c=1;
     a=1;
     b=1;
     for i = 1:size(meteors_440s,2)
         arr_heights440s(a)=meteors_440s(i).meteor_stats.ht;
         arr_times440s(a)=meteors_440s(i).meteor_stats.time;
         a = a+1;
     end
     for j = 1:size(meteors_200s,2)
         arr_heights200s(b)=meteors_200s(j).meteor_stats.ht;
         arr_times200s(b)=meteors_200s(j).meteor_stats.time;
         b = b+1;
     end
     for z = 1:size(meteors_52s,2)
         arr_heights52s(c)=meteors_52s(z).meteor_stats.ht;
         arr_times52s(c)=meteors_52s(z).meteor_stats.time;
         c = c+1;
     end
     arr_temp1= [ arr_heights440s; arr_times440s ];
     arr_temp2= [ arr_heights200s; arr_times200s ];
     arr_temp3= [ arr_heights52s; arr_times52s ];
     
     %sort by time
     arr1 = sortrows(arr_temp1,2);
     arr2 = sortrows(arr_temp2,2);
     arr3 = sortrows(arr_temp3,2);
     figure(1)
     scatter(arr1(1,:),arr1(2,:))
     hold on;
     scatter(arr2(1,:),arr2(2,:))
     hold on;
     scatter(arr3(1,:),arr3(2,:))
     legend('meteors_440s','meteors_200s','meteors_52s');
     hold off;
     title('Time vs Meteor Heights')
     xlabel('time')
     ylabel('height (km)')
     
end
