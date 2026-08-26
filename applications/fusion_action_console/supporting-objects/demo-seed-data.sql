-- Synthetic demo data standing in for real Fusion data (Phase 1 only).
-- NOT part of the automatic Supporting Objects install - run this
-- manually against a dev/demo workspace when you want to exercise the
-- proposal -> approval -> (stubbed) write flow end to end without any
-- live Fusion connectivity. Safe to skip entirely once Phase 2 wires up
-- real Fusion reads.

-- Demo approvers - replace SOMEONE@EXAMPLE.COM with real APEX usernames
-- before demoing the approval workflow. FAC_APPROVER is the only source
-- fac_action_stage_pkg.get_approvers reads from - nothing is hardcoded.
MERGE INTO fac_approver t
USING (
    SELECT 'GL' module_code, 'SOMEONE@EXAMPLE.COM' username FROM dual
    UNION ALL
    SELECT 'SLA', 'SOMEONE@EXAMPLE.COM' FROM dual
) s
ON (t.module_code = s.module_code AND t.username = s.username)
WHEN NOT MATCHED THEN
    INSERT (module_code, username) VALUES (s.module_code, s.username);

-- Module directory
MERGE INTO fac_module_registry t
USING (
    SELECT 'GL' module_code, 'General Ledger - Period Close' display_name,
           'FAC_GL_PERIOD_READ_PKG' read_package_name,
           'PERIOD_OPEN,PERIOD_CLOSE,CREATE_ACCOUNTING' action_types_supported FROM dual
    UNION ALL
    SELECT 'SLA', 'Accounting Hub - Suspense Accounting',
           'FAC_SUSPENSE_READ_PKG', 'SUSPENSE_CORRECTION' FROM dual
) s
ON (t.module_code = s.module_code)
WHEN NOT MATCHED THEN
    INSERT (module_code, display_name, read_package_name, action_types_supported)
    VALUES (s.module_code, s.display_name, s.read_package_name, s.action_types_supported);

-- GL period status - a small mixed-status calendar for one demo ledger
MERGE INTO fac_gl_period_status t
USING (
    SELECT 'VISION OPERATIONS' ledger_name, 'JUN-25' period_name, 'Closed' period_status,
           DATE '2025-06-01' period_start_date, DATE '2025-06-30' period_end_date FROM dual
    UNION ALL
    SELECT 'VISION OPERATIONS', 'JUL-25', 'Closed',
           DATE '2025-07-01', DATE '2025-07-31' FROM dual
    UNION ALL
    SELECT 'VISION OPERATIONS', 'AUG-25', 'Open',
           DATE '2025-08-01', DATE '2025-08-31' FROM dual
    UNION ALL
    SELECT 'VISION OPERATIONS', 'SEP-25', 'Future Enterable',
           DATE '2025-09-01', DATE '2025-09-30' FROM dual
) s
ON (t.ledger_name = s.ledger_name AND t.period_name = s.period_name)
WHEN NOT MATCHED THEN
    INSERT (ledger_name, period_name, period_status, period_start_date, period_end_date)
    VALUES (s.ledger_name, s.period_name, s.period_status, s.period_start_date, s.period_end_date)
WHEN MATCHED THEN UPDATE SET
    t.period_status = s.period_status,
    t.last_synced_at = SYSTIMESTAMP;

-- Suspense-posted transactions for the demo ledger's open period
MERGE INTO fac_suspense_transaction t
USING (
    SELECT 'DEMO-SUS-0001' suspense_txn_id, 'VISION OPERATIONS' ledger_name, 'AUG-25' period_name,
           '999-9999-9999-000-0000-000-000' suspense_account, 4250.00 entered_amount, 'USD' currency_code,
           'AP' source_system, 'Invoice INV-88213 - vendor site not mapped to a valid natural account' reference_description,
           DATE '2025-08-14' posted_date FROM dual
    UNION ALL
    SELECT 'DEMO-SUS-0002', 'VISION OPERATIONS', 'AUG-25',
           '999-9999-9999-000-0000-000-000', 1180.50, 'USD',
           'AR', 'Receipt RCT-44210 - unmapped cost center 7788', DATE '2025-08-19' FROM dual
    UNION ALL
    SELECT 'DEMO-SUS-0003', 'VISION OPERATIONS', 'AUG-25',
           '999-9999-9999-000-0000-000-000', 92300.00, 'USD',
           'FA', 'Asset transfer FA-3321 - retired cost center on source line', DATE '2025-08-22' FROM dual
) s
ON (t.suspense_txn_id = s.suspense_txn_id)
WHEN NOT MATCHED THEN
    INSERT (suspense_txn_id, ledger_name, period_name, suspense_account, entered_amount,
            currency_code, source_system, reference_description, posted_date)
    VALUES (s.suspense_txn_id, s.ledger_name, s.period_name, s.suspense_account, s.entered_amount,
            s.currency_code, s.source_system, s.reference_description, s.posted_date);

COMMIT;
