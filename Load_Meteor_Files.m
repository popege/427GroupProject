function [arr_440s, arr_200s, arr_52s] = Load_Meteor_Files();
    %loads all the files into matlab so we only have to do this once.
    %otherwise it will take 10 minutes to run kevans example every time we
    %run it
    [arr_440s_f1, arr_200s_f1, arr_52s_f1] = get_all_records('t3150_20170106.000');
    [arr_440s_f2, arr_200s_f2, arr_52s_f2] = get_all_records('t3150_20170106.001');
     
    %conglomerate 
    arr_440s = [arr_440s_f1, arr_440s_f2];
    arr_200s = [arr_200s_f1, arr_200s_f2];
    arr_52s  = [arr_52s_f1, arr_52s_f2];
end