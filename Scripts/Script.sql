SELECT
	B.SUB_ORDER_ID,
	A.order_id,
	A.service_id,
	A.order_type,
	B.sub_order_state AS SOS,
	B.state_reason,
	TIMESTAMPDIFF(MINUTE , A.created_date, NOW()) AS MC,
	-- DATE_FORMAT(A.created_date, '%H:%i') AS M,
	A.CHANNEL AS CH,
	DATE_FORMAT(A.created_date, "%Y-%m-%d %H:%i") AS created_date,
FROM
	COM_ORDER_MASTER PARTITION(p6) A
JOIN COM_SUB_ORDER_DETAILS PARTITION(p6) B ON
	A.ORDER_ID = B.ORDER_ID
WHERE
	B.SUB_ORDER_STATE NOT IN ('Completed', 'Rejected')
	AND A.ORDER_TYPE NOT IN ('Gifting') 
	AND B.state_reason NOT IN ('500 :: Error in calling getdata Account to get E164 for account balance : Contact ESB :: NCC')
)
	AND A.CREATED_DATE BETWEEN '2024-06-06 21:30:00' and '2024-06-07 06:30:00'
ORDER BY
	A.CREATED_DATE DESC;
#ORDER BY B.state_reason DESC;

