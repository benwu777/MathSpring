# Official Source Intake

## Purpose

This document defines which official olympiad-style sources MathSpring may
reference, which ones are safer candidates for first-party app ingestion, and
which ones require explicit rights review before full question text is bundled
into the app.

Current date reference for this review: July 19, 2026.

## Grade 7-12 First Batch Policy

For the first `grade7` to `grade12` expansion batch, MathSpring uses this
content policy:

- source scope: official or publicly available competition problems only
- shipping wording: rewritten for app use, not copied verbatim
- first-batch size: exactly 3 questions per `grade × olympiad topic` pack
- first-batch difficulty mix:
  - 1 easier entry question
  - 1 medium standard competition question
  - 1 harder question
- required source fields:
  - `contest`
  - `year`
  - `division`
  - `problemNumber`
  - `displayText`
  - `sourceUrl`
  - `rightsStatus`

This first batch is a quality-controlled seed, not a placeholder or demo set.

## Core Rule

MathSpring should not treat "publicly viewable PDF" as equivalent to "safe to
redistribute inside a commercial or public app".

Before a question is marked as official and bundled with full text, the source
should be reviewed under one of these states:

- `cleared_for_bundle`
- `needs_review`
- `do_not_bundle`

## Recommended Source Metadata

```json
{
  "source": {
    "type": "official_reference",
    "name": "Math Kangaroo USA",
    "contest": "Math Kangaroo USA",
    "year": "2025",
    "division": "Grades 3-4",
    "problemNumber": "12",
    "reference": "2025 Grades 3-4 Problem 12",
    "displayText": "Math Kangaroo USA 2025, Grades 3-4, Problem 12",
    "sourceUrl": "https://mathkangaroo.org/mks/practice/pdf-exams/",
    "rightsStatus": "needs_review"
  }
}
```

## Candidate Official Sources

### 1. Math Kangaroo USA

- Official site:
  - `https://mathkangaroo.org/mks/practice/pdf-exams/`
- What is available:
  - previous years' original test PDFs by grade bands
- Example display text:
  - `Math Kangaroo USA 2025, Grades 3-4, Problem 12`
- Current intake status:
  - `needs_review`
- Why:
  - the site publicly offers original exams for viewing or printing, but this
    does not by itself confirm repackaging rights for an app distribution

### 2. 澳門學界數學比賽（小學組）

- Official site:
  - `https://www.dsedj.gov.mo/cre/science/comp/info.html`
- What is available:
  - `2024/2025學年學界數學比賽(小學組)` and earlier PDF downloads
- Example display text:
  - `2024/2025學年學界數學比賽（小學組）第 7 題`
- Current intake status:
  - `needs_review`
- Why:
  - the files are publicly posted by a government education site, which makes
    this a stronger candidate than private contest archives, but reuse terms
    should still be checked before bundling full text

### 3. MOEMS Division E

- Official site:
  - `https://www.moems.org/pages/resources`
- What is available:
  - sample contest downloads and archived problem resources
- Example display text:
  - `MOEMS Division E Sample Contest, Problem 4`
- Current intake status:
  - `needs_review`
- Why:
  - official samples are available, but the organization also sells contest
    problem books, so full app bundling should not be assumed safe without
    permission

### 4. AMC 8

- Official site:
  - `https://maa.org/student-programs/amc/`
- Policy page:
  - `https://maa.org/student-programs/amc/maa-american-mathematics-competitions-policies/`
- Example display text:
  - `AMC 8 2025, Problem 6`
- Current intake status:
  - `do_not_bundle`
- Why:
  - the official policy explicitly states that reproduction or dissemination of
    problems or solutions is a violation of competition rules

## Suggested First Import Order

If MathSpring moves toward official-only content, the safest practical order is:

1. Build metadata-only records for all candidate official sources
2. Import full text only from sources with confirmed reuse permission
3. Keep all other official sources as references until rights are cleared

## Public-Competition Rewrite Policy

MathSpring may use public competition problems as the structural basis for
shipping content, but the bundled question text must still be rewritten into an
app-safe version unless reuse rights are explicitly cleared.

Allowed first-batch workflow:

1. verify the problem is on an official or clearly public archive
2. record exact source metadata
3. rewrite the prompt, solution steps, and answer text
4. preserve the mathematical structure and difficulty band
5. avoid figure-heavy items unless the figure can already be rendered cleanly

Not allowed:

- bundling raw copied contest PDFs into the app
- storing verbatim official solution text when reuse rights are unclear
- downgrading the source to `rewritten_olympiad_style` after using a real public
  contest item as the basis

## Immediate Project Policy

- Current bundled questions remain editorial rewrites unless explicitly marked
  otherwise
- A question must not be relabeled as official just because it resembles a past
  contest style
- Official source metadata may be stored before rights are cleared
- Full official question text should only be bundled after `rightsStatus` is
  changed to `cleared_for_bundle`
