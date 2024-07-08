# Read Text Files with Pandas using read_fwf()

# importing pandas
import pandas as pd
import numpy as np
df = pd.read_csv('txt.txt')

blankIndex=[''] * len(df)
df.index=blankIndex
print(df)

#print(df.to_string(index=False))
# read text file into pandas DataFrame

