SELECT
	order_id,
	service_id,
	order_type,
	order_state AS `status`,
	state_reason,
	created_date,
	CHANNEL
FROM
	COM_ORDER_MASTER PARTITION(p3,
	p4)
WHERE
	ORDER_TYPE = 'AddSubscription'
	AND CHANNEL IN ('PRETUPS', 'SND')
	AND CREATED_DATE>'2024-03-21 00:00:00'
	AND ORDER_STATE != 'Completed'
ORDER BY
	created_date;