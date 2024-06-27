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
	WKN_COM.COM_ORDER_MASTER PARTITION (p3) A,
	WKN_COM.COM_SUB_ORDER_DETAILS PARTITION (p3) B
WHERE
	B.SUB_ORDER_STATE != 'Completed'
	and A.CREATED_DATE BETWEEN '2024-03-01 00:00:00' and '2024-03-09 23:59:59'
	AnD A.order_id = B.order_id
	AND A.CHANNEL IN ('MPESA_USSD', 'MPESA_DXL', 'MPESA_SuperAPP', 'MPESA', 'PRETUPS')
	AND A.ORDER_TYPE = 'AddSubscription'
	and A.STATE_REASON NOT LIKE '%Maximum Instance Limit : 1 is reached for Bundle%'
ORDER BY
	ORDER_DATE DESC;