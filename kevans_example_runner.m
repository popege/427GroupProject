function kevans_example_runner()
[arr_440s, arr_220s, arr_52s] = Load_Meteor_Files

meteors_440s = meteor_filter(arr_440s)
meteors_200s = meteor_filter(arr_200s)
meteors_52s = meteor_filter(arr_52s)

arr = kevans_code_example(meteors_440s, meteors_200s, meteors_52s)