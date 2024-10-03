set @report_date = cast('2013-01-17 00:00:00' as datetime);
set @night = "251717165548";
set @afternooon = "251717165548";
set @morning = "251717165548";
use WKN_COM;
SELECT
	A.order_id,
	B.SUB_ORDER_ID,
	A.service_id,
	A.order_type,
	B.sub_order_state AS SOS,
	B.state_reason,
	DATE_FORMAT(A.created_date, "%Y-%m-%d %H:%i") AS created_date,
	TIMESTAMPDIFF(MINUTE , A.created_date, NOW()) AS MC,
	-- DATE_FORMAT(A.created_date, '%H:%i') AS M,
	A.CHANNEL AS CH,
	CASE 
		WHEN A.CHANNEL IN ('MPESA_USSD','MPESA_SuperApp') THEN 'MPESA_*'
		ELSE A.CHANNEL
	END AS MPESA,
	CASE
		WHEN B.state_reason IN ('424 :: Read timed out while invoking third party :: Loyalty Management','425 :: Connection refused while invoking third party :: Loyalty Management') THEN 'Connection refused || Read time out -- LMS'
		WHEN B.state_reason LIKE '400 :: Subscription create failed for Account ID : A_%' THEN '400 :: Subscription create failed for Account ID : A_...'
		WHEN B.state_reason LIKE '958 :: status_duplicate_subscription_id :: Subscription Management' THEN 'Work around at BSS'
		WHEN B.state_reason LIKE '676 :: Plan%' THEN 'Mutual exclusive plan'
		-- WHEN B.state_reason LIKE 'SC0007%' THEN 'LMS -- Loyalty Management'
		WHEN (A.order_type='Addsubscription' and B.state_reason LIKE '% :: Error in calling getdata Account to get E164 for account balance : Contact ESB :: NCC') THEN 'Nothing to do'
		-- WHEN (A.order_type='Addsubscription' and B.state_reason='500 :: SM is not responding, please check logs for more information. :: NCC') THEN 'Nothing to do'
		WHEN B.state_reason LIKE 'SC000%' THEN 'Work around at BSS'WHEN (A.order_type='MpesaBundlePurchase' and B.state_reason LIKE '%Error in calling getdata Account to get E164 for account balance : Contact ESB :: NCC') THEN 'Nothing to do'
		WHEN (A.order_type='MpesaBundlePurchase' and B.state_reason='555 :: No success response from TIBCO QUERY BALANCE API :: NCC') THEN 'Nothing to do'
		WHEN B.state_reason LIKE '%SM_OVERLOAD_DISCARDED_REQUEST: Discarded Request: Request is discarded due to overload :: NCC' THEN 'Nothing to do'
		WHEN B.state_reason LIKE 'Waiting for%' THEN 'Waiting for callback'
		WHEN (A.order_type='MpesaBundlePurchase' and B.state_reason LIKE '555 :: Get Device API Exception<?xml%') THEN 'Nothing to do'
		WHEN (A.order_type='MpesaBundlePurchase' and B.state_reason LIKE '%No success response from TIBCO QUERY BALANCE API :: NCC') THEN 'Nothing to do'
		WHEN (A.order_type='ChangeSubscription' and B.state_reason LIKE '400 :: Subscription Details not found for ocsSubscriptionId%') THEN 'Work around at BSS'
		WHEN (A.order_type='MpesaBundlePurchase' and B.state_reason LIKE '%Read timed out while invoking third party :: NCC') THEN 'Nothing to do'
		WHEN B.state_reason='1503 :: Service limit reached for a profile :: Billing' THEN 'Nothing to do'
		WHEN (A.order_type='addservice' and B.state_reason='404 :: null :: NCC') THEN 'Raising issue -- to NCC'
		WHEN (A.order_type='onboarding' and B.state_reason='404 :: null :: NCC') THEN 'Raising issue -- to NCC'
		WHEN (A.order_type='changesubscription' and B.state_reason='400 :: null :: NCC') THEN 'Raising issue -- to NCC'
		WHEN (A.order_type='addsubscription' and B.state_reason='424 :: Read timed out while invoking third party :: NCC') THEN 'Nothing to do'
		WHEN B.state_reason LIKE '500 :: Failed to provision on ME(s) KLT%' THEN '500 :: Failed to provision on ME(s) KLT1: Client received SOAP Fault from server: Error :: NCC'
		WHEN B.state_reason LIKE '409 :: SM_DB_RECORD_ALREADY_EXISTS: Duplicate record: Record already exists, for Account with ID : A%' THEN 'Raising issue -- to NCC'
		WHEN B.state_reason LIKE '409 :: SM_DB_RECORD_ALREADY_EXISTS: Duplicate record: Record already exists, for Device with ID : D%' THEN 'Raising issue -- to NCC'
		WHEN B.state_reason LIKE '400 :: A technical error occurred while executing Patch request:Error%' THEN '400 :: A technical error occurred while executing Patch request:Error -- Read timed out :: NCC'
		WHEN B.state_reason LIKE '404 :: MISSING_ENTITY: Entity missing: Record does not exist for these Bundle ids :%' THEN '404 :: MISSING_ENTITY: Entity missing: Record does not exist for these Bundle ids : xxxxxx. :: NCC'
		WHEN B.state_reason LIKE '400 :: No suitable online Manage Element configured for subscriber related entities. Please contact administrator. Account :A_%' THEN '400 :: No suitable online Manage Element configured for subscriber related entities.-- NCC'
		WHEN B.state_reason LIKE '404 :: SM_FILTER_CRITERIA_MISMATCH: No subscription matched:%' THEN '404 :: SM_FILTER_CRITERIA_MISMATCH: No subscription matched: for filter entity ::: NCC'
		WHEN B.state_reason LIKE 'A technical error occurred while executing Patch request:Timeout acquiring locks:%' THEN 'A technical error occurred while executing Patch request:Timeout acquiring locks: [ClubNumberXXXXXX..]'
		WHEN B.state_reason LIKE '%The subscriber has active debt :: TIBCO' THEN '400 || 555 :: The subscriber has active debt :: TIBCO'
		WHEN B.state_reason LIKE '%Subscribe age on network of%' THEN 'Subscriber Min age || spent a little -- Genuine'
		WHEN B.state_reason LIKE '%To borrow%Birr you need to have spent at least%' THEN 'Subscriber Min age || spent a little -- Genuine'
		WHEN B.state_reason LIKE '%Get Device API Exception%' THEN 'Get Device API Exception'
		WHEN B.state_reason LIKE '%No success response from TIBCO QUERY BALANCE API :: TIBCO' THEN 'No success response from TIBCO QUERY BALANCE API :: TIBCO'
		WHEN B.state_reason LIKE '400 :: Failed to provision : Error Reference Number: DEVICE_%' THEN 'Raising issue -- to NCC'
		WHEN B.state_reason LIKE '500 :: Failed to provision : Error Reference Number: ACCOUNT_%' THEN 'Raising issue -- to NCC'
		WHEN B.state_reason LIKE '400 :: Failed to provision : Error Reference Number: DEVICE_%' THEN 'Raising issue -- to NCC'
		WHEN B.state_reason LIKE "424 :: Read timed out while invoking third party%" THEN '424 :: Read timed out while invoking third party'		
		WHEN B.state_reason LIKE '658 :: This operation is not allowed since customer has an active loan%' THEN 'customer has an active loan'
		WHEN B.state_reason LIKE '555 :: Client received a 5xx response for invocation at resource path%' THEN '555 :: Client received a 5xx response for invocation at resource path'		
		WHEN B.state_reason IN ('1 :: The initiator information is invalid. :: NCC', '1 :: The security credential is locked. :: NCC', '1 :: Duplicate Airtime Purchase. :: NCC') 
	     					THEN 'Invalid info || Duplicate Airtime Purchase || Locked Credential -- NCC'
		WHEN B.state_reason IN ('1 :: The security credential has been locked because the number of input errors has reached the upper limit. :: NCC', '1 :: Your security credential will be locked if another attempt fails. :: NCC') 
	     					THEN 'Credential locked due to max trial ||  will lock another attempt -- NCC'
		WHEN B.state_reason LIKE '400 :: DEVICE_OWNER_INVALID: Invalid device owner: Record does not exist for owner with id U%' THEN 'Nothing to do'
		WHEN B.state_reason IN ('662 :: as package is already used its not applicable for reversal :: NCC', 'COM-001 :: Customer has no bundle subscription') THEN 'Used package not applicable for reversal || has no bundle subscription -- NCC'
		ELSE B.state_reason
	END AS COMPILED_REASON
FROM
	COM_ORDER_MASTER PARTITION(p9) A
JOIN COM_SUB_ORDER_DETAILS PARTITION(p9) B ON
	A.ORDER_ID = B.ORDER_ID
WHERE
	B.SUB_ORDER_STATE NOT IN ('completed','Rejected')
	AND A.ORDER_TYPE NOT IN ('Gifting','StopAutoRenewal')
	-- AND (B.SUB_ORDER_STATE = 'In-Progress' AND TIMESTAMPDIFF(MINUTE , A.created_date, NOW()) >10)
	AND B.state_reason NOT LIKE '%Subscription create failed for Account ID : A_%'
	AND B.state_reason NOT LIKE '676 :: Plan%'
	AND B.state_reason NOT LIKE '%:: To borrow%Birr you need to have spent at least%Birr within the last%days :: NCC'
	AND B.state_reason NOT LIKE '%:: Subscribe age on network of%days is less than minimum required%months  :: NCC'
	AND B.state_reason NOT LIKE '404 :: SM_FILTER_CRITERIA_MISMATCH: No subscription matched: No subscription matched for filter entity%'
	AND B.STATE_REASON NOT LIKE '500 :: SM_SERVICE_DEFAULT_ERRCODE: SMAPI_DEFAULT: SM is not responding, please check logs for more information. Account :A_%'
	AND B.state_reason NOT IN ('1 :: subscription_already_deactivated :: Subscription Management', '1 :: status_code_subscriber_does_not_exists :: Subscription Management'
, '400 :: SIM is already paired with another msisdn :: NMS', '400 :: MSISDN is already paired with another SIM :: NMS', '658 :: This operation is not allowed since customer has an active loan :: NCC'
, '404 :: Blank Sim Details is not available in db :: NMS', '1 :: Transaction Already Reversed :: MPESA'
, '555 :: The subscriber has active debt :: NCC'
, '1 :: The balance is insufficient for the transaction. :: NCC'
, '1 :: Your security credential will be locked if another attempt fails. :: NCC'
, '1 :: The initiator information is invalid. :: NCC'
, '1 :: Duplicate Airtime Purchase. :: NCC'
, '1 :: The request is not permitted according to product assignment. :: NCC'
, '1 :: No security credential is found. Operation failed. :: NCC'
, '404 :: SM_FILTER_CRITERIA_MISMATCH: No subscription matched: for filter entity ::: NCC'
, '404 :: SIM Details is not valid for pairing :: NMS'
, '1 :: The security credential is locked. :: NCC'
, '659 :: This operation is not allowed because of insufficient airtime balance  :: ESB'
, '1 :: The security credential has been locked because the number of input errors has reached the upper limit. :: NCC'
, '400	 :: Invalid/InActive MemberMsisdn!! :: Billing', '404 :: MSISDN is not valid for pairing :: NMS'
, '400 :: Validation Failed :: Billing', 'Waiting for Approval', 'Waiting for Deposit Payment Callback'
, '1 :: status_code_subscriber_does_not_exists :: Subscription Management'
, '503 :: Error in calling getdata Account to get E164 for account balance : Contact ESB :: NCC'
, '1503 :: Service limit reached for a profile :: Billing'
, '500 :: EWKN_COMWKN_COMrror in calling getdata Account to get E164 for account balance : Contact ESB :: NCC'
, '662 :: as package is already used its not applicable for reversal :: NCC'
, '400 :: Invalid/InActive MemberMsisdn!! :: Billing'
, '400 :: The Subscriber is not Segmented :: NCC'
, '555 :: The Subscriber is not Segmented :: NCC'
, '400 :: The subscriber has active debt :: NCC'
, "600 :: Order Doesn't exist :: TIBCO"
, '1 :: Declined -The service request is processed successfully. :: NCC'
, '4007 ::  Initiator exceeds monthly allowed reversal. :: Subscription Management'
)
	AND A.CREATED_DATE BETWEEN '2024-09-30 06:00:00' and '2024-09-30 13:50:00'
ORDER BY A.CREATED_DATE DESC;
#ORDER BY B.state_reason DESC;

