function kevans_code_example;
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
     meteors_200s = meteor_filter(arr_200s);
     meteors_440s = meteor_filter(arr_440s);
     meteors_52s = meteor_filter(arr_52s);
     
     %the same can be done for meteor arrays
     meteor_stats=meteors_52s(1).meteor_stats
     meteor_header=meteors_52s(1).header;
     meteor_data=meteors_52s(1).data;
end