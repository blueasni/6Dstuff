import pandas as pd
import itertools

colors = {'first_set':  ['99', '88', '77', '66','55', '44', '33', '22'],'second_set': ['1', '2', '3', '4', '5','6', '7', '8']}
 
color = {'first_set':  ['a', 'b', 'c', 'd', 'e','f', 'g', 'h'],'second_set': ['VI', 'IN', 'BL', 'GR','YE', 'OR', 'RE', 'WI']}
# Calling DataFrame constructor on list
df = pd.DataFrame(colors, columns=['first_set', 'second_set'])
df1 = pd.DataFrame(color, columns=['first_set', 'second_set'])
#print(df)
#print(df1)
store_ids = df['STORE'].drop_duplicates()
mrp_values = (1999, 2499, 2699, 2799, 2999)
keys = itertools.product(store_ids, mrp_values)
temp = pd.DataFrame.from_records([{'store_id': store_id, 'mrp': mrp_value}
                                  for store_id, mrp_value in keys])
result = temp.merge(df, how="left", left_on=["store_id", "mrp"],
                                    right_on=["STORE", "MRP"])
print(result)