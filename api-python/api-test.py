#from functools import singledispatchmethod
import os
from sys import byteorder
from openpyxl.compat import numbers
from sqlalchemy import URL, create_engine
from pandas import DataFrame, ExcelWriter, to_datetime
from datetime import date, datetime  
from openpyxl.utils.dataframe import dataframe_to_rows
from openpyxl.worksheet.table import Table, TableStyleInfo
from pandas._libs.tslibs.timestamps import Timestamp
import openpyxl
from openpyxl import load_workbook,Workbook,cell
import math
from PIL import ImageFont
import pandas as pd
from openpyxl.styles import Alignment,Border,Color, Font,PatternFill,Side, alignment
from openpyxl.utils import get_column_letter
from openpyxl.utils.dataframe import dataframe_to_rows
from openpyxl.worksheet.dimensions import ColumnDimension,DimensionHolder
from sqlalchemy import text
import datetime

url_object = URL.create("mysql+pymysql",username="rptuserc1_ro",password="bssuser@6Dtech",host="10.3.74.22",database="WKN_COM",port=6033,)
engine = create_engine(url_object)
connection = engine.connect()
PARTITION = 'p'+str(datetime.date.today().month)
#q=text("SELECT A.order_id, B.SUB_ORDER_ID,B.service_id, A.order_type, B.sub_order_state, B.state_reason, A.created_date,	A.CHANNEL, 'Asnake' As Name_,'2024-06-24 06:30:00' AS St_TIme, CASE WHEN B.state_reason LIKE '400 :: Service Details already exist for serviceId : %' THEN 'The Service is already active' WHEN B.state_reason = '1503 :: Service limit reached for a profile :: Billing' THEN 'limit reached' WHEN B.state_reason = '404 :: Blank Sim Details is not available in db :: NMS' THEN 'Duplicate request' WHEN B.state_reason = '404 :: SIM Details is not valid for pairing :: NMS' THEN 'Duplicate request' WHEN B.state_reason = '400 :: SIM is already paired with another msisdn :: NMS' THEN 'IMSI already paired' WHEN B.state_reason = '400 :: MSISDN is already paired with another SIM :: NMS' THEN 'IMSI already paired' WHEN B.state_reason = '404 :: Sim Details is not available in DB :: NMS' THEN 'ICCID already paired' WHEN B.state_reason = '424 :: Read timed out while invoking third party :: ERP' THEN 'Raised to Tibco' WHEN B.state_reason LIKE 'Object uid=%' THEN 'Duplicate Request' WHEN B.state_reason LIKE '555 :: To borrow%Birr you need to have spent at least%Birr within the last 30 days :: NCC' THEN 'Not eligible' WHEN B.state_reason = 'Please attach the document' THEN 'The document is rejected' WHEN B.state_reason = '400 :: Invalid Patch for Path:/identities for operation:replace. The Identity supplied in Where clause is not associated with this device. :: NCC' THEN 'Duplicate request' WHEN B.state_reason LIKE '658 :: This operation is not allowed since customer has an active loan ::%' THEN 'Customer have active loan' WHEN B.state_reason = '400 :: DNA Pairing Failed! :: NMS' THEN 'Duplicate order' ELSE null END AS DESCRIPTION, CASE WHEN DESCRIPTION IS NOT NULL THEN 'NO' END AS WA FROM COM_ORDER_MASTER PARTITION(p6) A, COM_SUB_ORDER_DETAILS PARTITION(p6) B WHERE B.SUB_ORDER_STATE != 'Completed' AND B.state_reason != 'Waiting for Bank Callback' AND B.Sub_order_state != 'In-Progress' AND A.ORDER_TYPE in ('Onboarding', 'AddService', 'TransferOfService', 'ChangeSim', 'TerminateService', 'ChangeSubscription', 'UpdateStarterPackKYC', 'HardUnbarring', 'HardBarring', 'SoftUnbarring', 'SoftBarring', 'AddServiceToNewAccount', 'ConnectionMigration') AND A.CREATED_DATE BETWEEN '2024-06-23 21:30:00' and '2024-06-24 06:30:00' AND A.ORDER_ID = B.ORDER_ID ORDER BY A.CREATED_DATE;")
#q=text("SELECT DATE(ORDER_DATE),ORDER_STATE,COUNT(*) FROM COM_ORDER_MASTER WHERE DATE(ORDER_DATE)>='2024-07-01' and ORDER_TYPE='onboarding' and ORDER_STATE in ('Completed','Failed')  GROUP BY DATE(ORDER_DATE),ORDER_STATE;")
q=text("SELECT DATE(ORDER_DATE) AS ORDER_DATE,ORDER_STATE,coalesce(COUNT(ORDER_STATE), 0) FROM COM_ORDER_MASTER WHERE CREATED_DATE BETWEEN '2024-07-03' and '2024-07-04' and ORDER_STATE in ('Completed','Failed') GROUP BY DATE(ORDER_DATE),ORDER_STATE")
TOP5_FAILED_ORDERS = text("SELECT DATE(A.CREATED_DATE) as Created_Date ,NAME,count(*) from COM_ORDER_MASTER PARTITION({0}) A,COM_ORDER_STAGES PARTITION(p7) B where A.CREATED_DATE BETWEEN '2024-07-03' and '2024-07-04' and B.STATE='Failed' and A.ORDER_ID=B.ORDER_ID group by DATE(A.CREATED_DATE),NAME  order by DATE(A.CREATED_DATE),count(*) desc;".format(PARTITION))
ONBOARDING = text("SELECT DATE(ORDER_DATE) AS ORDER_DATE,ORDER_STATE,COUNT(*) AS COUNT FROM COM_ORDER_MASTER WHERE DATE(ORDER_DATE)>='2024-07-02' and ORDER_TYPE='onboarding' and ORDER_STATE in ('Completed','Failed')  GROUP BY DATE(ORDER_DATE),ORDER_STATE;")
COMPLETED = text("SELECT (SELECT count(*) FROM patients WHERE order_state='Completed' AND DATE(ORDER_DATE)>='2024-07-02' AND ORDER_TYPE='onboarding') AS Completed, (SELECT count(*) FROM patients WHERE order_state='Failed' AND DATE(ORDER_DATE)>='2024-07-02' AND ORDER_TYPE='onboarding') AS Failed")

api_data = pd.read_sql(TOP5_FAILED_ORDERS,connection) 
api_data[['Created_Date']] = api_data[['Created_Date']].astype(str)
print(api_data)
#api_data[['order_id', 'SUB_ORDER_ID']] = api_data[['order_id', 'SUB_ORDER_ID']].astype(str)
thin=Side(border_style="thin",color="000000")
test = Side(border_style="double",color="ffffff")
testBorder = Border(top=test,bottom=test,left=test,right=test)
singleBorder= Side(border_style="thin",color="121212")
doubleBorder = Side(border_style="double",color="008000")
alignment = Alignment(horizontal="center",vertical="center",indent=1)
border = Border(top=singleBorder,left=singleBorder,right=singleBorder,bottom=singleBorder)
#api_data = api_data.iloc[1:]

#writer = pd.ExcelWriter('pandas_multiple.xlsx', engine='xlsxwriter')

# Position the dataframes in the worksheet.

#api_data.to_excel(writer, sheet_name='Sheet1')  # Default position, cell A1.
#api_data.to_excel(writer, sheet_name='Sheet1', startcol=4)
#api_data.to_excel(writer, sheet_name='Sheet1', startcol=7)

#--------------------------------------------------------
thin=Side(border_style="thin",color="000000")
wb = Workbook()
ws = wb.active
#writer.save()
for r in dataframe_to_rows(api_data, index=False, header=True):
    ws.append(r)
for row in range(2 , ws.max_row):
    ell = ws['A'+str(row)]
    ell.font = Font(name='Calibri',size=11,bold=True,italic=False, color='008000')
    ell.number_format = "@"
for i in range(1 , ws.max_column+1):
    ell = ws[get_column_letter(i)+str(1)]
    ell.font = Font(name='Calibri',size=11,bold=True,italic=False, color='008000')
    ell.fill = PatternFill(fill_type='solid',start_color='FFFF00',end_color='FFFF00')
    ell.border = Border(top=thin , bottom = thin , left = thin , right = thin)
    ell.number_format = "@"
style = TableStyleInfo(name="TableStyleMedium9", showFirstColumn=False,showLastColumn=False, showRowStripes=True, showColumnStripes=True)
table = Table(displayName="API_TEST", ref="A1:" + get_column_letter(ws.max_column) + str(ws.max_row))

print(get_column_letter(ws.max_column))
print(str(ws.max_row))
print(PARTITION)
rng = ws["A1:"+ get_column_letter(ws.max_column) + str(ws.max_row)]

for row in rng:
    for c in row:
        c.border = border
        c.alignment=alignment
#ws.column_dimensions.group('A', 'D', hidden=True,outline_level=1)        
ws.column_dimensions.group('F', 'F', hidden=True)        
ws.cell(2,2).number_format='@'
def auto_width(workb,ws): #adjusting auto column width
    column_widths = []
    for row in ws.iter_rows():
        for i, cell in enumerate(row):
            try:
                column_widths[i] = max(column_widths[i], len(str(cell.value)))
            except IndexError:
                column_widths.append(len(str(cell.value)))
    for i, column_width in enumerate(column_widths):
        ws.column_dimensions[get_column_letter(i + 1)].width = column_width + 1
    workb.save("table-pandas.xlsx")
#++++++++++++++
col_range = ws['A3:A4']
for row in col_range:
    for c in row:
        c.fill = PatternFill(fill_type='solid',start_color='FFFF00',end_color='FFFF00')
table.tableStyleInfo = style
ws.add_table(table)
auto_width(wb,ws)
#adjust_excel_column_widths(ws, '/home/blue/openpxl/export-dataframes-to-excel/calibri.ttf')
c = ws['A2']
ws.freeze_panes = c
wb.save("table-pandas.xlsx")
os.startfile("table-pandas.xlsx")
connection.close