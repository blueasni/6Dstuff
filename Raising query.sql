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