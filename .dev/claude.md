# mt-devops-framework Architecture & Standards

## 1. Code Structure & Quality
- **Keep code DRY:** Eliminate duplication. Never use inline scripting; always extract into dedicated functional files.
- **Modularity:** Avoid long, monolithic scripts, classes, or Terraform files. Maintain a short, concise codebase with a logical directory structure.
- **Configuration over Hardcoding:** Do not use hardcoded strings or variable values. Use YAML config files to manage and inject values.
- **Documentation:** When generating documentation or explaining infrastructure concepts, use simple, accessible language suitable for non-technical stakeholders.

## 2. Terraform & GCP Infrastructure
- **External Configuration:** Do NOT use inline JSON or YAML in Terraform. Always create a standalone file for the JSON/YAML and load it into Terraform.
- **Observability:** Include a Google Cloud Platform Monitoring Dashboard for all provisioned infrastructure where possible.
- **Reliability:** Always include Healthchecks and/or Liveness Probes.
- **Security:** Follow the principle of least-privilege for IAM roles, but avoid creating custom roles if standard roles suffice.

## 3. Strict Naming Conventions
- **Compute VM Instances:** `<cloud><os><service><role><environment><number>`
  - Parameters: cloud (gc/aw), os (ms/lx), role (app/web/db/orch), env (dv/ts/st/lv). Example: `gclxsftpts01`
- **Firewall Rules:** `<network>-allow-<protocol>[-<source-or-target>]`
  - Example: `ri-global-allow-ssh`. Network tags on instances must exactly match this firewall rule name.
- **Cloud Monitoring:** `<projectname>-<component>` for groups. Alerting policies must use `<projectname> > <component> > <description>` (e.g., `dev-connect > test-qlikservers > CPU Usage Exceeds 90%`).