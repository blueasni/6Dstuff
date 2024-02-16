SELECT
	A.service_id,
	A.order_id,
	A.order_type,
	B.sub_order_state,
	B.state_reason,
	TIMESTAMPDIFF(MINUTE , A.created_date, NOW()) AS MC,
	DATE_FORMAT(A.created_date, '%H:%i') AS M,
	A.CHANNEL AS CH,
	A.created_date
FROM
	COM_ORDER_MASTER PARTITION(p2) A
JOIN COM_SUB_ORDER_DETAILS PARTITION(p2) B ON
	A.ORDER_ID = B.ORDER_ID
WHERE
	B.SUB_ORDER_STATE NOT IN ('Completed', 'Rejected')
	AND A.ORDER_TYPE NOT IN ('Gifting', 'StopAutoRenewal')
	AND B.state_reason NOT LIKE '00015 :: Subscription create failed for Account ID : A_%'
	AND B.STATE_REASON NOT LIKE '500 :: SM_SERVICE_DEFAULT_ERRCODE: SMAPI_DEFAULT: SM is not responding, please check logs for more information. Account :A_%'
	AND B.state_reason NOT IN ('1 :: subscription_already_deactivated :: Subscription Management', '1 :: status_code_subscriber_does_not_exists :: Subscription Management'
, '400 :: SIM is already paired with another msisdn :: NMS', 'Waiting for Bank Callback', '658 :: This operation is not allowed since customer has an active loan :: NCC'
, '404 :: Blank Sim Details is not available in db :: NMS'
, '400	 :: Invalid/InActive MemberMsisdn!! :: Billing'
, '400 :: Validation Failed :: Billing', 'Waiting for Approval', 'Waiting for Deposit Payment Callback'
, '1 :: status_code_subscriber_does_not_exists :: Subscription Management'
, '503 :: Error in calling getdata Account to get E164 for account balance : Contact ESB :: NCC'
, '1503 :: Service limit reached for a pro××file :: Billing'
, '676 :: Plan Daily Unlimited Internet and calls to Safaricom is mutually exclusive to the subscribed offer Daily Unlimited Internet and calls to Safaricom_RC :: COM'
, '676 :: Plan CBU Weekly Unlimited is mutually exclusive to the subscribed offer Daily Unlimited Internet & Onnet Min :: COM'
, '500 :: EWKN_COMWKN_COMrror in calling getdata Account to get E164 for account balance : Contact ESB :: NCC'
, '676 :: Plan CBU Mpasswordonthly Unlimited is mutually exclusive to the subscribed offer CBU Weekly Unlimited :: COM'
, '676 :: Plan Daily Unlimited Internet and calls to Safaricom_RC is mutually exclusive to the subscribed offer Daily Unlimited Internet and calls to Safaricom :: COM'
, '676 :: Plan Daily Unlimited Internet & Onnet Min is mutually exclusive to the subscribed offer CBU Weekly Unlimited :: COM'
, '676 :: Plan CBU Monthly Unlimited is mutually exclusive to the subscribed offer Daily Unlimited Internet & Onnet Min :: COM'
)
	AND A.CREATED_DATE BETWEEN '2024-02-15 13:30:00' and '2024-02-15 21:59:00'
ORDER BY
	A.CREATED_DATE DESC;
#ORDER BY B.state_reason DESC;
