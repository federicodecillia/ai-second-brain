# flylabs-brain — company brain a due (design + registro attriti template)

**Data:** 2026-06-13
**Owner del lavoro:** Federico De Cillia
**Origine:** primo uso reale di `ai-second-brain` come starter, per creare il company brain di flylabs.ai (collaborazione Federico + Cesare).

## Obiettivo

Un secondo cervello aziendale che Federico e Cesare operano insieme via agente AI: assegnarsi task, vedere lo stato dei progetti, gestire clienti / prospect / preventivi / materiali / risorse. Repo **privato** nell'org GitHub `flylabs-ai`, nome `flylabs-brain`.

Doppio deliverable: (1) il brain funzionante, (2) un template `ai-second-brain` migliore, grazie agli attriti registrati durante questo primo uso reale.

## Modello di lavoro (due repo separati)

- **`flylabs-brain`** — nuova cartella pulita (`~/ai_projects/flylabs-brain`), copiata dal template *senza* `.git/.github/scripts`, personalizzata in modalità team, poi `gh repo create flylabs-ai/flylabs-brain --private` + push. I dati aziendali vivono solo qui.
- **`ai-second-brain`** — resta il template, intatto. Le migliorie emerse (sotto) si applicano come commit/PR su un branch dedicato, separato dai dati di flylabs.

## Decisioni (confermate con l'owner)

| Tema | Scelta |
|---|---|
| Pipeline commerciale | **Leggera**: campo `status` nel frontmatter + `pipeline.md` con viste per stage. Cresce coi dati. |
| Preventivi | **Nota dedicata per preventivo** (cliente, importo, validità, status, link a contatto/progetto). |
| Assegnazione task | **Tag persona** `#federico` / `#cesare` + sezioni per-persona in `dashboard.md` (nativo plugin Tasks). |
| Naming | cartelle snake_case, note kebab-case (coerente col template). |
| Context azienda | `_company.md` + `context/team/{federico,cesare}.md`, con stub `> Interview gap:`. Nessun dato inventato su flylabs.ai. |

## Struttura

```
flylabs-brain/
  AGENTS.md (+CLAUDE.md/GEMINI.md symlink)   rulebook team-aware
  README.md  index.md  MEMORY.md
  hub.md          task condivisi senza progetto
  routines.md     ricorrenti (link-hygiene, review pipeline settimanale)
  dashboard.md    cockpit task: Federico · Cesare · non assegnati · overdue · oggi
  pipeline.md     cockpit commerciale per stage (lead→prospect→preventivo→cliente→perso)
  Daily/
  01_Projects/    ingaggi cliente con deadline + iniziative interne (+ 1 esempio)
  02_Areas/
    sales/        sales.md + preventivi/ (1 nota per preventivo, + 1 esempio)
  03_Resources/
    templates/    i 6 del template + preventivo.md
    people/       clients/ prospects/ collaborators/ suppliers/ (+ 1 prospect esempio)
    materials/    deck, case study, boilerplate, brand
    context/
      _company.md identità flylabs.ai (lente strategica, stub)
      team/  federico.md  cesare.md (stub)
  09_Archive/
```

Anti-overcomplication: niente cartelle vuote pre-create (marketing/operations/finance si aggiungono quando hanno contenuto). Esempi chiaramente marcati come tali, facili da cancellare.

## Convenzioni

- **Task:** `- [ ] testo 📅 YYYY-MM-DD ⏫ #cesare`. Dashboard con sezioni per-persona via `tags include #federico|#cesare` + sezione "non assegnati".
- **Pipeline:** `status:` in frontmatter di prospect/preventivo (`lead·prospect·preventivo·cliente·perso`); `pipeline.md` raggruppa per stage. Preventivo vinto → nasce un progetto in `01_Projects/`, linkato.
- **Preventivo (template):** frontmatter `client · amount · currency · valid_until(📅) · status · project`. Mai inventare importi.
- **Context engine team:** per domande strategiche l'agente legge `_company.md` + `MEMORY.md` + i due profili.

## AGENTS.md team-aware (diff vs template)

- `Owner: {{owner_name}}` → `Team: Federico, Cesare`.
- Aggiunta regola assegnazione task con tag persona.
- Aggiunta sezione capture pipeline commerciale (prospect/preventivo → status).
- Context engine punta a `_company.md` + `context/team/` invece di `_owner.md`.

## Registro attriti → migliorie a `ai-second-brain`

Raccolti durante questo primo uso reale; da applicare al template su branch dedicato.

1. **Manca la modalità team.** Tutto (`AGENTS.md`, `_owner.md`, `setup.sh`) assume un solo `{{owner_name}}`. Per due+ persone serve: identità azienda, profili team, convenzione di assegnazione task. → documentare un "team mode" opt-in.
2. **`setup.sh` non porta su GitHub.** Fa `git init` locale ma non crea né pusha il repo (utente o org). Per il caso "repo privato in un'org" c'è un buco manuale. → step opzionale `gh repo create` (utente/org, public/private).
3. **CRM/pipeline gated come "pro".** Una pipeline *leggera* (status + viste) è il primo bisogno reale di chi usa il vault per lavoro. → spedire una versione minima opt-in nel template.
4. **`_owner.md` rigido.** Concetto mono-persona. → supportare `_company.md` per il caso team.
5. **Eseguire `setup.sh` dentro il clone è distruttivo** (`rm -rf .git`): per creare un brain partendo dal template bisogna copiare in una cartella nuova. Documentato implicitamente dal quickstart (clone in `my-second-brain`), ma vale ricordarlo per il caso org.

## Risoluzione (applicata al template, branch `feat/company-team-mode`)
- **#1 Team mode** → `setup.sh` chiede *personal/team*; in team scaffolda `_company.md`, profili `context/team/`, identità `Team:` in `AGENTS.md`, dashboard per-persona, pipeline + area sales + template `quote.md`. Guida: `docs/company-brain.md`. Pointer sempre presente nel `AGENTS.md` personale.
- **#2 Bootstrap GitHub** → step opzionale `gh repo create` (utente/org, private default) in `setup.sh`.
- **#3 Pipeline leggera** → ora inclusa in team mode (status + `pipeline.md` Dataview); reinquadrato il "pro" in `docs/customization.md`.
- **#4 `_owner.md`** → in team mode diventa `_company.md` + `context/team/`.
- **Verifica:** `scripts/smoke-test.sh` esteso con un run team; 28/28 PASS (personal + team).

## Fuori scope (YAGNI)

Forecast/probabilità sui deal, automazioni MCP (calendar/email/pagamenti), aree marketing/finance vuote, multi-lingua. Si aggiungono quando servono.
