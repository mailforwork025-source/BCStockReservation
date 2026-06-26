# Implementation Plan - Business Central API Integration Audit & Deployment Readiness

Comprehensive static analysis and audit of the BCStockReservation AL extension to verify deployment readiness for WooCommerce integration.

## User Review Required

> [!WARNING]
> The `BCSR API` (ID 50101) permission set does **not** include Page execute permissions (`X`) for the custom API pages (pages 50110-50116).
> If a WooCommerce API user is only assigned `BCSR API`, they can execute the action-based endpoints under codeunit 50104 (`BCSR API Actions`), but queries to API resource pages (e.g. GET `/reservations`, `/availabilityBuckets`) will fail with authorization errors.
> To resolve this, the API User should either be assigned the `BCSR ADMIN` permission set or a custom permission set that grants Execute (`X`) permissions to the 7 API Page objects.

> [!IMPORTANT]
> The extension does not implement any programmatic or automated web service registration upon installation. Therefore, `codeunit 50104 "BCSR API Actions"` must be published manually in the Business Central **Web Services** page post-installation to make the `[ServiceEnabled]` methods callable.

## Proposed Deliverables

The audit will generate the following reports under the artifacts directory:

### [NEW] [api_object_report.md](file:///C:/Users/Bornov%20Engineering/.gemini/antigravity-ide/brain/8953b152-e22d-46af-afbf-fed8d411f4a6/api_object_report.md)
* Details all API Pages and ServiceEnabled methods.
* Documents object IDs, namespaces (Publisher, Group, Version), entity mappings, and key bindings.
* Traces procedure call chains connecting the REST interface to core business logic.

### [NEW] [deployment_report.md](file:///C:/Users/Bornov%20Engineering/.gemini/antigravity-ide/brain/8953b152-e22d-46af-afbf-fed8d411f4a6/deployment_report.md)
* Verifies `app.json` configurations (publisher, ID range, runtime level).
* Audits SaaS compatibility (validates absence of local file system dependencies, .NET assemblies, or on-premises scope limiters).
* Confirms SandboxProd09072025 deployment target alignment.

### [NEW] [web_services_setup_guide.md](file:///C:/Users/Bornov%20Engineering/.gemini/antigravity-ide/brain/8953b152-e22d-46af-afbf-fed8d411f4a6/web_services_setup_guide.md)
* Step-by-step instructions for publishing `BCSR API Actions` in Business Central Web Services.
* Explains URL structures for SOAP and OData V4 custom endpoints.
* Outlines OAuth App Registration and authentication setup (Microsoft Entra ID integration) for the WooCommerce connection.

### [NEW] [missing_components_report.md](file:///C:/Users/Bornov%20Engineering/.gemini/antigravity-ide/brain/8953b152-e22d-46af-afbf-fed8d411f4a6/missing_components_report.md)
* Highlights potential risks (such as the API Page execute permissions gap in the `BCSR API` permission set).
* Details any lacking automated installation routines or configuration boundaries.

### [NEW] [production_readiness_verdict.md](file:///C:/Users/Bornov%20Engineering/.gemini/antigravity-ide/brain/8953b152-e22d-46af-afbf-fed8d411f4a6/production_readiness_verdict.md)
* Delivers final verdict: `⚠ Ready for Sandbox with Manual Configuration Required`.
* Sums up mandatory manual setup tasks.

## Verification Plan

### Automated Checks
* Verify AL file counts and directory integrity.
* Perform object ID and unique range check.
* Cross-check procedures against code implementations.

### Manual Verification
* Review compiled package configuration.
