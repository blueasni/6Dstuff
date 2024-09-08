use WKN_COM;
SELECT
	SERVICE_ID,
	CUSTOMER_ID,
	ORDER_ID,
	EXTERNAL_ID,
	CREATED_DATE,
	STATE_REASON
FROM
	COM_ORDER_MASTER PARTITION(p7)
WHERE
	LAST_MODIFIED_DATE BETWEEN '2024-07-01 00:00:00' AND '2024-07-17 23:59:59'
	AND ORDER_TYPE = 'MpesaBundlePurchase'
	AND ORDER_STATE != 'Completed'
	and STATE_REASON = '424 :: Read timed out while invoking third party :: TIBCO';
	

SELECT
"Serial",COUNT(*)
FROM
	COM_ORDER_MASTER
WHERE
	order_state = 'Acknowledged'
	AND created_date BETWEEN '2024-07-28 06:30:00' and '2024-07-28 22:30:00'
	
SELECT * from COM_ORDER_STAGE_CONFIG

SELECT
	order_id,
	service_id,
	order_type,
	state_reason,
	created_date,
	LAST_MODIFIED_DATE,
	CHANNEL
FROM
	COM_ORDER_MASTER PARTITION(p8)
WHERE
	ORDER_TYPE in ('Onboarding', 'AddService', 'TransferOfService', 'ChangeSim', 'TerminateService', 'ChangeSubscription', 'UpdateStarterPackKYC', 'HardUnbarring', 'HardBarring', 'SoftUnbarring', 'SoftBarring', 'AddServiceToNewAccount', 'ConnectionMigration', 'ResumeService')
	and ORDER_STATE IN ('Acknowledged', 'In-Progress')
ORDER BY
	CREATED_DATE DESC
	
SELECT
	A.order_id,
	B.SUB_ORDER_ID,
	A.service_id,
	A.order_type,
	A.Order_state,
	A.state_reason,
	A.created_date,
	A.LAST_MODIFIED_DATE,
	A.CHANNEL
FROM
	COM_ORDER_MASTER PARTITION(p8) A,
	COM_ORDER_STAGES PARTITION(p8) B
WHERE
	A.ORDER_ID = B.ORDER_ID
	and B.STATE != 'Completed'
	AND B.NAME = 'MPESA Payment Reversal'
	
use WKN_COM;
SELECT
	A.order_id,
	B.SUB_ORDER_ID,
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
	AND A.ORDER_TYPE IN ('AddService', 'Onboarding') 
	AND A.ORDER_STATE = 'Failed'
	and A.CREATED_DATE BETWEEN '2024-08-19 16:47:07' and now()
