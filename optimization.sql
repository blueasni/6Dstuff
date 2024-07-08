SELECT DATE(ORDER_DATE) AS Ordered_Date, ORDER_STATE,ORDER_TYPE, COUNT(*)
FROM COM_ORDER_MASTER
WHERE ORDER_TYPE IN ('Onboarding','Addservice','AddServiceToNewAccount','AddSubscription','BlockVoucher','BookDeposit','AdjustMainAccount','CancelSubscription','ChangeSim','ChangeSubscription','CreateDocument','CreateIdentification','Gifting','HardBarring','LifeCycleSync','LifeCycleSyncTermination','LineBarring','LineUnBarring','MakePayment','MoveToFWA','NumberRecycle','ResumeService''StopAutoRenewal','SuspendService','TransferOfService','UpdateBucket','UpdateCreditLimit','UpdateLanguage','UpdateProfile','UnlockMpesa','UpdateService','DeviceBlacklistWhitelist','VoucherRecharge')
AND ORDER_STATE IN ('Failed', 'Completed')
AND DATE(ORDER_DATE) >= '2024-07-03'
AND DATE(ORDER_DATE) < '2024-07-04'
GROUP BY DATE(ORDER_DATE), ORDER_STATE,ORDER_TYPE


SELECT ORDER_DATE AS Ordered_Date, ORDER_STATE, ORDER_TYPE, COUNT(*) AS order_count
FROM COM_ORDER_MASTER
WHERE ORDER_TYPE IN ('Onboarding', 'Addservice', 'AddServiceToNewAccount', 'AddSubscription', 'BlockVoucher', 'BookDeposit', 'AdjustMainAccount', 'CancelSubscription', 'ChangeSim', 'ChangeSubscription', 'CreateDocument', 'CreateIdentification', 'Gifting', 'HardBarring', 'LifeCycleSync', 'LifeCycleSyncTermination', 'LineBarring', 'LineUnBarring', 'MakePayment', 'MoveToFWA', 'NumberRecycle', 'ResumeService', 'StopAutoRenewal', 'SuspendService', 'TransferOfService', 'UpdateBucket', 'UpdateCreditLimit', 'UpdateLanguage', 'UpdateProfile', 'UnlockMpesa', 'UpdateService', 'DeviceBlacklistWhitelist', 'VoucherRecharge')
AND ORDER_STATE IN ('Failed', 'Completed')
AND ORDER_DATE >= '2024-07-03' AND ORDER_DATE < '2024-07-04'
GROUP BY ORDER_DATE, ORDER_STATE, ORDER_TYPE

SELECT ORDER_TYPE,ORDER_STATE,count(*)from COM_ORDER_MASTER PARTITION(p7) where DATE(CREATED_DATE)=date(now())-1 and ORDER_STATE in ('Completed','Failed')  group by ORDER_TYPE,ORDER_STATE  order by ORDER_TYPE

''' Optimized '''
SELECT ORDER_TYPE, ORDER_STATE, COUNT(*) 
FROM COM_ORDER_MASTER PARTITION(p7) 
WHERE CREATED_DATE >= DATE(NOW()) - INTERVAL 1 DAY 
  AND CREATED_DATE < DATE(NOW()) 
  AND ORDER_STATE in ('Completed', 'Failed') 
GROUP BY ORDER_TYPE, ORDER_STATE 
ORDER BY ORDER_TYPE;
''' Optimized '''
SELECT
    ORDER_TYPE,
    ORDER_STATE,
    SUM(CASE
            WHEN DATE(ORDER_DATE) >= '2024-07-03' AND DATE(ORDER_DATE) < '2024-07-04' THEN 1
            ELSE 0
        END) AS `TOTAL`,
    SUM(CASE
            WHEN ORDER_STATE = "Completed" THEN 1
            ELSE 0
        END) AS `COMPLETED`,
    SUM(CASE
            WHEN ORDER_STATE = "Failed" THEN 1
            ELSE 0
        END) AS `FAILED`
FROM `COM_ORDER_MASTER`
GROUP BY ORDER_TYPE, ORDER_STATE
''' Optimized '''
SET @report_date = '2013-01-17 00:00:00';
SELECT
	A.order_id,
	B.SUB_ORDER_ID,
	A.service_id,
	A.order_type,
	B.sub_order_state AS SOS,
	B.state_reason,
	TIMESTAMPDIFF(MINUTE , A.created_date, NOW()) AS MC,
	A.CHANNEL AS CH,
	DATE_FORMAT(A.created_date, "%Y-%m-%d %H:%i") AS created_date,
	CASE 
		WHEN A.CHANNEL IN ('MPESA_USSD','MPESA_SuperApp') THEN 'MPESA_*'
		ELSE A.CHANNEL
	END AS MPESA,
	CASE
		WHEN B.state_reason LIKE '400 :: Subscription create failed for Account ID : A_%' THEN '400 :: Subscription create failed for Account ID : A_...'
		WHEN B.state_reason LIKE '676 :: Plan%' THEN 'Mutual exclusive plan'
		WHEN B.state_reason LIKE 'SC0007%' THEN 'LMS -- Loyalty Management'
		WHEN B.state_reason LIKE '404 :: SM_FILTER_CRITERIA_MISMATCH: No subscription matched:%' THEN '404 :: SM_FILTER_CRITERIA_MISMATCH: No subscription matched: for filter entity ::: NCC'
		WHEN B.state_reason LIKE 'A technical error occurred while executing Patch request:Timeout acquiring locks:%' THEN 'A technical error occurred while executing Patch request:Timeout acquiring locks: [ClubNumberXXXXXX..]'
		WHEN B.state_reason LIKE '%The subscriber has active debt :: TIBCO' THEN '400 || 555 :: The subscriber has active debt :: TIBCO'
		WHEN B.state_reason LIKE '%Subscribe age on network of%' THEN 'Subscriber Min age || spent a little -- Genuine'
		WHEN B.state_reason LIKE '%To borrow%Birr you need to have spent at least%' THEN 'Subscriber Min age || spent a little -- Genuine'
		WHEN B.state_reason LIKE '%Get Device API Exception%' THEN 'Get Device API Exception'
		WHEN B.state_reason LIKE '%No success response from TIBCO QUERY BALANCE API :: TIBCO' THEN 'No success response from TIBCO QUERY BALANCE API :: TIBCO'
		WHEN B.state_reason LIKE '400 :: Failed to provision : Error Reference Number: DEVICE_%' THEN 'Raising issue -- 400 :: Failed to provision'
		WHEN B.state_reason LIKE '500 :: Failed to provision : Error Reference Number: ACCOUNT_%' THEN '500 :: Failed to provision : Error Reference Number: ACCOUNT_XXXXX'
		WHEN B.state_reason LIKE '409 :: SM_DB_RECORD_ALREADY_EXISTS: Duplicate record: Record already exists, For Account with ID : A_%' THEN '409 :: SM_DB_RECORD_ALREADY_EXISTS: Duplicate record: Record already exists, For Account with ID : A_XXXXXXXX'
		WHEN B.state_reason LIKE "424 :: Read timed out while invoking third party%" THEN '424 :: Read timed out while invoking third party'		
		WHEN B.state_reason LIKE '658 :: This operation is not allowed since customer has an active loan%' THEN 'customer has an active loan'
		WHEN B.state_reason LIKE '555 :: Client received a 5xx response for invocation at resource path%' THEN '555 :: Client received a 5xx response for invocation at resource path'		
		WHEN B.state_reason IN ('1 :: The initiator information is invalid. :: NCC', '1 :: The security credential is locked. :: NCC', '1 :: Duplicate Airtime Purchase. :: NCC') THEN 'Invalid info || Duplicate Airtime Purchase || Locked Credential -- NCC'
		WHEN B.state_reason IN ('404 :: Error in calling getdata Account to get E164 for account balance : Contact ESB :: NCC','500 :: Error in calling getdata Account to get E164 for account balance : Contact ESB :: NCC') THEN '404 || 500 :: Error in calling getdata Account to get E164 for account balance : Contact ESB :: NCC'
		WHEN B.state_reason IN ('1 :: The security credential has been locked because the number of input errors has reached the upper limit. :: NCC', '1 :: Your security credential will be locked if another attempt fails. :: NCC') THEN 'Credential locked due to max trial ||  will lock another attempt -- NCC'
		WHEN B.state_reason LIKE '400 :: DEVICE_OWNER_INVALID: Invalid device owner: Record does not exist for owner with id U%' THEN '400 :: DEVICE_OWNER_INVALID: Invalid device owner: Record does not exist for owner with id U_XXXXXXXX'
		WHEN B.state_reason IN ('662 :: as package is already used its not applicable for reversal :: NCC', 'COM-001 :: Customer has no bundle subscription') THEN 'Used package not applicable for reversal || has no bundle subscription -- NCC'
		ELSE B.state_reason
	END AS COMPILED_REASON
FROM
	COM_ORDER_MASTER PARTITION(p7) A
JOIN COM_SUB_ORDER_DETAILS PARTITION(p7) B ON A.ORDER_ID = B.ORDER_ID
WHERE
	B.SUB_ORDER_STATE NOT IN ('completed','Rejected')
	AND A.ORDER_TYPE NOT IN ('Gifting','StopAutoRenewal')
	AND A.CREATED_DATE BETWEEN '2024-07-07 06:00:00' and '2024-07-07 13:50:00'
	AND NOT EXISTS (
		SELECT 1 FROM (
			SELECT '00015 :: Subscription create failed for Account ID : A_%' AS reason
			UNION ALL SELECT '676 :: Plan%'
			UNION ALL SELECT '400 :: To borrow%Birr you need to have spent at least%Birr within the last%days :: NCC'
			UNION ALL SELECT '400 :: Subscribe age on network of%days is less than minimum required%months :: NCC'
			UNION ALL SELECT '404 :: SM_FILTER_CRITERIA_MISMATCH: No subscription matched: No subscription matched for filter entity%'
			UNION ALL SELECT '555 :: To borrow%Birr you need to have spent at least%Birr within the last 30 days :: NCC'
			UNION ALL SELECT '555 :: Subscribe age on network of%days is less than minimum required 2 months :: NCC'
			UNION ALL SELECT '400 :: Subscription create failed for Account ID : A_%'
			UNION ALL SELECT '500 :: SM_SERVICE_DEFAULT_ERRCODE: SMAPI_DEFAULT: SM is not responding, please check logs for more information. Account :A_%'
		) AS excluded
		WHERE B.STATE_REASON LIKE excluded.reason
	)
ORDER BY CREATED_DATE DESC;
''' Optimized '''

