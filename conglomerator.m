function [meteors_440s,meteors_200s,meteors_52s] = conglomerator (file_name,meteors_440s,meteors_200s,meteors_52s);
    fprintf('starting\n')
    [new_arr_440s, new_arr_200s, new_arr_52s]= get_all_records(file_name);
    fprintf('file loaded\n')
    new_meteors_440s = meteor_filter(new_arr_440s);
    fprintf('440s filtered, %g new meteors found!\n',size(new_meteors_440s,2))
    new_meteors_200s = meteor_filter(new_arr_200s);
    fprintf('200s filtered %g new meteors found!\n',size(new_meteors_200s,2))
    new_meteors_52s = meteor_filter(new_arr_52s);
    fprintf('52s filtered %g new meteors found!\n',size(new_meteors_52s,2))
    meteors_440s = [meteors_440s,new_meteors_440s];
    fprintf('440s conglomerated\n')
    meteors_200s = [meteors_200s,new_meteors_200s];
    fprintf('200s conglomerated\n')
    if(~isempty(new_meteors_52s)) 
        meteors_52s = [meteors_52s,new_meteors_52s];
        fprintf('52s conglomerated\n')
    else
        meteors_52s = meteors_52s;
    end
    %run this command in console
    %[meteors_440s,meteors_200s,meteors_52s] = conglomerator('t3150_20170106.003',meteors_440s,meteors_200s,meteors_52s
end