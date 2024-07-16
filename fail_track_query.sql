SELECT
	A.order_id,
	B.SUB_ORDER_ID,
	B.service_id,
	A.order_type,
	B.sub_order_state,
	B.state_reason,
	A.created_date,
	A.CHANNEL,
	'Asnake' As Name_,
	'2024-07-15 21:30:00' AS St_TIme,
	CASE 
	   WHEN B.state_reason LIKE '400 :: Service Details already exist for serviceId : %' THEN 'The Service is already active'
		WHEN B.state_reason = '1503 :: Service limit reached for a profile :: Billing' THEN 'limit reached'
		WHEN B.state_reason = '404 :: Blank Sim Details is not available in db :: NMS' THEN 'Duplicate request'
		WHEN B.state_reason = '404 :: SIM Details is not valid for pairing :: NMS' THEN 'Duplicate request'
		WHEN B.state_reason = '400 :: SIM is already paired with another msisdn :: NMS' THEN 'IMSI already paired'
		WHEN B.state_reason = '400 :: MSISDN is already paired with another SIM :: NMS' THEN 'IMSI already paired'
		WHEN B.state_reason = '404 :: Sim Details is not available in DB :: NMS' THEN 'ICCID already paired'
		WHEN B.state_reason = '424 :: Read timed out while invoking third party :: ERP' THEN 'Raised to Tibco'
		WHEN B.state_reason LIKE 'Object uid=%' THEN 'Duplicate Request'
		WHEN B.state_reason LIKE '555 :: To borrow%Birr you need to have spent at least%Birr within the last 30 days :: NCC' THEN 'Not eligible'
		WHEN B.state_reason = 'Please attach the document' THEN 'The document is rejected'
		WHEN B.state_reason = '400 :: Invalid Patch for Path:/identities for operation:replace. The Identity supplied in Where clause is not associated with this device. :: NCC' THEN 'Duplicate request'
		WHEN B.state_reason LIKE '658 :: This operation is not allowed since customer has an active loan ::%' THEN 'Customer have active loan'		
		WHEN B.state_reason = '400 :: DNA Pairing Failed! :: NMS' THEN 'Duplicate order'
	ELSE null
	END AS DESCRIPTION,
	CASE 
		WHEN DESCRIPTION IS NOT NULL THEN 'NO'
		-- ELSE 'YES'
	END AS WA
	FROM
	COM_ORDER_MASTER PARTITION(p7) A,
	COM_SUB_ORDER_DETAILS PARTITION(p7) B
WHERE
	B.SUB_ORDER_STATE != 'Completed'
	AND B.state_reason != 'Waiting for Bank Callback'
	AND B.Sub_order_state != 'In-Progress'
	AND A.ORDER_TYPE in ('Onboarding', 'AddService', 'TransferOfService', 'ChangeSim', 'TerminateService', 'ChangeSubscription', 'UpdateStarterPackKYC', 'HardUnbarring', 'HardBarring', 'SoftUnbarring', 'SoftBarring', 'AddServiceToNewAccount', 'ConnectionMigration')
	AND A.CREATED_DATE BETWEEN '2024-07-15 13:30:00' and '2024-07-15 21:30:00'
	AND A.ORDER_ID = B.ORDER_ID
ORDER BY
	A.CREATED_DATE;