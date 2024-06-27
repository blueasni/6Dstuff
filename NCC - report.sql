SELECT 
	B.service_id,
	A.created_date,
	A.order_id,
	A.order_type,
	B.sub_order_state,
	B.state_reason,
	"Raised to NCC" As "Raised To",
	"Asnake" As "SPOC",
	"" As "Comments"
FROM
	COM_ORDER_MASTER PARTITION(p6) A,
	COM_SUB_ORDER_DETAILS PARTITION(p6) B
WHERE
	A.order_id = '1255429172516327424' AND A.order_id = B.ORDER_ID
ORDER BY
	A.CREATED_DATE;
	
SELECT
	B.SUB_ORDER_ID,
	A.order_id,
	B.service_id,
	A.order_type,
	B.sub_order_state,
	B.state_reason,
	A.created_date,
	A.CHANNEL
FROM
	COM_ORDER_MASTER A,
	COM_SUB_ORDER_DETAILS B
WHERE
	A.order_id = B.order_id
	AND A.ORDER_TYPE IN ('ConnectionMigration', 'AddService', 'Onboarding', 'ChangeSim','AdjustMainAccount', 'ChangeSubscription') 
	AND A.ORDER_STATE != 'Completed'
	and A.CREATED_DATE BETWEEN '2024-01-05 00:00:00' and now()
	AND A.ORDER_ID IN ('1252209357768380416', '', '')
	
SELECT
	B.SUB_ORDER_ID,
	A.order_id,
	A.service_id,
	A.order_type,
	B.sub_order_state AS SOS,
	B.state_reason,
	A.CHANNEL AS CH,
	DATE_FORMAT(A.created_date, "%Y-%m-%d %H:%i") AS created_date
FROM
	COM_ORDER_MASTER PARTITION(p6) A
JOIN COM_SUB_ORDER_DETAILS PARTITION(p6) B ON
	A.ORDER_ID = B.ORDER_ID
WHERE
	B.state_reason='500 :: Error in calling getdata Account to get E164 for account balance : Contact ESB :: NCC'
	AND A.order_type IN ('AddSubscription','MpesaBundlePurchase')
	AND A.CREATED_DATE BETWEEN '2024-06-06 21:30:00' and '2024-06-07 06:30:00'
ORDER BY B.state_reason DESC;

SELECT
B.SUB_ORDER_ID,
	A.order_id,
	B.service_id,
	A.order_type,
FROM
	COM_ORDER_MASTER PARTITION(p6) A,
	COM_SUB_ORDER_DETAILS PARTITION(p6) B
WHERE
	A.ORDER_ID = B.ORDER_ID
	and B.SUB_ORDER_STATE != 'Completed'
	AND A.ORDER_ID IN ('1252209357768380416', '1247270427167526912', '1248961262901821440')
	
SELECT
	COUNT(*),
	ORDER_STATE
FROM
	COM_ORDER_MASTER PARTITION(p6)
WHERE
	ORDER_STATE != 'Failed'
	AND CREATED_DATE>'2024-06-21 20:10:00'
GROUP BY
	ORDER_STATE;
SELECT COUNT(*), ORDER_STATE FROM COM_ORDER_MASTER PARTITION(p6) WHERE ORDER_STATE != 'Failed' AND CREATED_DATE>'2024-06-21 20:10:00' GROUP BY ORDER_STATE;
---
WHERE
Mdn_series = 53
AND Account_Id = 251700494353
AND (Event_Result = '1')
AND Call_Start_Time between '2024-06-01 00:00:00' AND '2024-06-19 16:05:30'
ORDER BY CALL_START_TIME

select APINAME,count(*) from APIGW_RPT where DATE(PROCESS_DATE)=DATE(CURRENT_DATE)-1 group by APINAME order by APINAME;