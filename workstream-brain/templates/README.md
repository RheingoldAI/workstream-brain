# templates/

Blank skeletons of the Layer 1 files, for adapting the brain to your own workstream without picking apart the Skylark example. Workflow (see [`../ADAPTING.md`](../ADAPTING.md)):

1. Copy a skeleton from here over the corresponding real file (e.g. `templates/CLAUDE.md` → `../CLAUDE.md`).
2. Fill in the `<…>` placeholders with your domain.
3. Repeat for each `docs/` file you need; delete the ones you don't.

The skills (`.claude/skills/*`) aren't templated here — you retune their *config*, not their structure. Each skill's SKILL.md has an "Adapting this skill" section.

Contents:
- `CLAUDE.md` — blank auto-load index
- `docs/project-overview.md`
- `docs/domain-glossary.md`
- `docs/data-sources-and-schema.md`
- `docs/working-queries.md`
- `docs/methodology-learnings.md`
