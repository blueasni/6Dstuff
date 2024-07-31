import pandas as pd

df = pd.read_csv('data.csv')

print(df.to_string())
print("-----------------------------------------------")
duplicated = df[df.duplicated("ORDER_TYPE")]
count_row = duplicated.shape[0]
unique = df.drop_duplicates(subset=["ORDER_TYPE"]) 
print("-----------------------------------------------")
print(unique)
print("-----------------------------------------------")

for row in range(count_row):
  ot = duplicated.iloc[row,0]
  print(ot.to_string())