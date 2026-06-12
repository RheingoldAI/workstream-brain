# Domain glossary — Skylark

> **Fictional example.** Terms for the made-up Skylark workstream. Replace with your own product's vocabulary — anything a newcomer (or the agent) would otherwise have to stop and ask about.

## Entities

- **Account** — a customer organization (a company). Billing and licensing happen at the account level. `account_id`.
- **User** — an individual person within an account. `user_id`. A user belongs to exactly one account.
- **Workspace** — a container for documents and tasks within an account. An account can have many workspaces. `workspace_id`. Don't confuse "workspace" (a Skylark container) with "account" (the company) — early dashboards conflated them and over-counted.
- **Document** — a single collaborative doc. `doc_id`.

## Usage concepts

- **Active user** — a user who took a meaningful action on a given day. **Canonically: at least one `content_edited` event.** See `methodology-learnings.md` for why this signal and not the alternatives. Rolls up to **DAU / WAU / MAU**.
- **Interactive vs automated** — an edit a person typed (interactive) vs one produced by a template, integration, or scheduled automation (automated, `properties.source = 'automation'`). Automated activity is **counted** in headline usage and **labeled**, never filtered out.
- **Internal vs external** — Internal = the Skylark company's own dogfooding account (`account_id = 'acct_skylark_internal'`). External = all customer accounts. The cut is **account-level**.
- **Habitual user** — a user active on ≥ 3 distinct days in a rolling 7-day window. Used in the adoption funnel's final step.

## Funnel stages (feature adoption)

1. **Onboarded** — completed first-run setup (`onboarding_completed`).
2. **First doc** — created their first document (`doc_created`).
3. **First share** — shared a doc with another user (`doc_shared`). ⚠ Under-fires on mobile — see schema doc.
4. **Habitual** — see above.

## Retention terms

- **Returning account** — an account active in week *N* that was also active in week *N−1*.
- **Weekly return rate** — returning accounts ÷ (denominator under discussion — see `project-overview.md` open dependencies).

## Conventions

- A **day** is bucketed in UTC unless a dashboard explicitly says otherwise.
- A **week** runs Monday–Sunday.
- "Engagement" without a qualifier means the canonical active-user signal, not app opens.
