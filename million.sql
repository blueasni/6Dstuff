SELECT
	B.SUB_ORDER_ID,
	A.ORDER_ID ,
	B.service_id,
	A.order_type,
	B.sub_order_state,
	B.state_reason,
	B.FAILED_STAGE_CODE,
	A.created_date,
	A.CHANNEL
FROM
	COM_ORDER_MASTER PARTITION(p6) A,
	COM_SUB_ORDER_DETAILS PARTITION(p6) B
WHERE
	B.SUB_ORDER_STATE != 'Completed'
	AND A.ORDER_TYPE IN ('MpesaBundlePurchase')
	AND B.FAILED_STAGE_CODE IN ('MPESA_BUNDLE_REVERSAL', 'BUNDLE_REVERSAL_CALLBACK')
	AND A.CREATED_DATE
	AND A.CREATED_DATE BETWEEN '2024-06-11 06:30:00' AND '2024-06-11 13:59:00'
	AND A.ORDER_ID = B.ORDER_ID
ORDER BY
	A.CREATED_DATE DESC;

-- Query for MPESA failed at the reversal stage 

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
	B.SUB_ORDER_STATE = 'Failed'
	AND A.ORDER_TYPE IN ('Onboarding', 'AddService')
	AND (B.STATE_REASON IN ('404 :: null :: NCC')
		OR B.STATE_REASON LIKE '400 :: Failed to provision%')
	AND A.CREATED_DATE BETWEEN DATE_SUB(NOW(),INTERVAL 10 DAY) AND NOW()
	AND A.ORDER_ID = B.ORDER_ID
ORDER BY
	A.CREATED_DATE DESC;
--- 
WITH CTE as
(
SELECT
	CAST(ShiftStart AS DATETIME) AS ShiftStart,
	CASE
		WHEN ShiftStart > ShiftEnd THEN CAST(ShiftEnd AS DATETIME) + 1
		ELSE CAST(ShiftEnd AS DATETIME)
	END AS ShiftEnd
FROM
	** TABLE_NAME **
)
SELECT * FROM CTE
WHERE
	CAST('11:00:00' AS DATETIME) BETWEEN ShiftStart AND ShiftEnd
	-- Start of Shift
	OR CAST('23:00:00' AS DATETIME) BETWEEN ShiftStart AND ShiftEnd
	-- End of Shift
	
SET @myjson = '["gmail.com","mail.ru","arcor.de","gmx.de","t-online.de",
                "web.de","googlemail.com","freenet.de","yahoo.de","gmx.net",
                "me.com","bluewin.ch","hotmail.com","hotmail.de","live.de",
                "icloud.com","hotmail.co.uk","yahoo.co.jp","yandex.ru"]';
SET @arr = 'a,b,c'
select * from @arr;
SELECT JSON_LENGTH(@myjson);
-- result: 19
SELECT JSON_VALUE(@myjson);

SELECT JSON_VALUE(@myjson, '$[*]');
SELECT FIND_IN_SET(@myjson);

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
	AND A.ORDER_ID IN ("1250734490899628032")