import pandas as pd
import numpy as np
weather_df = pd.DataFrame(np.random.rand(10,2)*5,
                          index=pd.date_range(start="2021-01-01", periods=10),
                          columns=["Tokyo", "Beijing"])

def rain_condition(v):
    if v < 1.75:
        return "Dry"
    elif v < 2.75:
        return "Rain"
    return "Heavy Rain"

def make_pretty(styler):
    styler.set_caption("Weather Conditions")
    styler.format(rain_condition)
    styler.format_index(lambda v: v.strftime("%A"))
    styler.background_gradient(axis=None, vmin=1, vmax=5, cmap="YlGnBu")
    return styler
with pd.ExcelWriter('output1.xlsx') as writer:
    df = pd.DataFrame({"A": [1, 2], "B": [3, 4]})
    df.to_excel(writer, sheet_name='Data', index=False, startrow=1)
    ws = writer.book.get_worksheet_by_name('Data')
    ws.write('A1', 'This is a caption')
with pd.ExcelWriter('output1.xlsx') as writer:
    df1 = pd.DataFrame({"A": [1, 2], "B": [3, 4]})
    df1.to_excel(writer, sheet_name='Data', index=False, startrow=10)
    ws = writer.book.get_worksheet_by_name('Data')
    ws.write('A1', 'This is a caption')
weather_df
df = pd.DataFrame({"A": [1, 2], "B": [3, 4]})
df.columns = ['ID', 'First Name']
df.style.set_caption("testing")
df.to_excel("test.xlsx")
#df.loc["2021-01-04":"2021-01-08"].style.pipe(make_pretty)
#df.style.\
#    map(style_negative, props='color:red;').\
#    highlight_max(axis=0).\
#    to_excel('styled.xlsx', engine='openpyxl')
#weather_df.loc["2021-01-04":"2021-01-08"].style.pipe(make_pretty)
