DROP CONTEXT fac_approval_ctx;

DROP PACKAGE fac_approval_guard_pkg;
DROP PACKAGE fac_fusion_write_pkg;
DROP PACKAGE fac_ai_tool_api_pkg;
DROP PACKAGE fac_action_stage_pkg;
DROP PACKAGE fac_suspense_read_pkg;
DROP PACKAGE fac_gl_period_read_pkg;
DROP PACKAGE fac_ess_job_pkg;
DROP PACKAGE fac_audit_pkg;
DROP PACKAGE fac_conn_get_pkg;

DROP TABLE fac_action_execution_log PURGE;
DROP TABLE fac_approval PURGE;
DROP TABLE fac_proposed_action_version PURGE;
DROP TABLE fac_proposed_action PURGE;
DROP TABLE fac_suspense_transaction PURGE;
DROP TABLE fac_gl_period_status PURGE;
DROP TABLE fac_ess_job_registry PURGE;
DROP TABLE fac_app_config PURGE;
DROP TABLE fac_approver PURGE;
DROP TABLE fac_module_registry PURGE;
