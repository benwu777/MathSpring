# Olympiad Template Examples

Worked samples: 6

This document provides one worked sample per **skill family**. These are template
examples, not shipping question packs. Each example shows how a future
high-quality olympiad-style question maps into the current MathSpring JSON schema.

> **Phase-1 topic note (canonical).** The samples are grouped by the six skill
> families for illustration. Some samples below use `"topic": "number_theory"` /
> `"algebra"` / `"combinatorics"` — these are **not** valid shipped topicCodes.
> A shipped question's `topic`/`topicCode` must be one of the four:
> `arithmetic` / `geometry` / `logic` / `mixed` (number_theory → `arithmetic`;
> algebra → `mixed`/`arithmetic`; combinatorics → `mixed`/`logic`). Treat the
> skill-family label here as descriptive only. See `olympiad-template-spec.md`.

## arithmetic sample

Template family:

- `working_backward`
- tier: `foundation`
- answer mode: `integer_input`

Example JSON:

```json
{
  "id": "arithmetic_grade4_foundation_sample_001",
  "topic": "arithmetic",
  "subtopic": "working_backward",
  "difficulty": "foundation",
  "levelStage": "grade4",
  "challengeTier": "foundation",
  "prompt": {
    "zh-Hant": "一個數先加上 8，再乘以 2，結果是 30。原來的數是多少？",
    "en": "A number is increased by 8 and then multiplied by 2 to get 30. What was the original number?"
  },
  "answer": {
    "zh-Hant": "答案是 7。",
    "en": "The answer is 7."
  },
  "solutionSteps": {
    "zh-Hant": [
      "倒推，先把 30 除以 2 得到 15。",
      "再把 15 減去 8，得到 7。"
    ],
    "en": [
      "Work backward. First divide 30 by 2 to get 15.",
      "Then subtract 8 to get 7."
    ]
  },
  "figure": {
    "type": "custom",
    "kind": "none",
    "params": {}
  },
  "answerMode": "integer_input",
  "correctAnswer": {
    "type": "integer",
    "value": "7"
  },
  "inputConstraints": {
    "allowNegative": false,
    "maxDigits": 2
  },
  "source": {
    "type": "rewritten_olympiad_style",
    "name": "MathSpring Editorial",
    "reference": "arithmetic-working-backward-sample",
    "rightsStatus": "cleared_for_bundle"
  }
}
```

## number_theory sample

Template family:

- `remainders`
- tier: `competition`
- answer mode: `multiple_choice`

Example JSON:

```json
{
  "id": "number_theory_grade5_competition_sample_001",
  "topic": "number_theory",
  "subtopic": "remainders",
  "difficulty": "competition",
  "levelStage": "grade5",
  "challengeTier": "competition",
  "prompt": {
    "zh-Hant": "把某個整數除以 5 餘 2。把這個整數再加上 9 後，除以 5 會餘多少？",
    "en": "An integer leaves remainder 2 when divided by 5. What remainder will it leave when 9 is added and the result is divided by 5?"
  },
  "answer": {
    "zh-Hant": "答案是 1。",
    "en": "The answer is 1."
  },
  "solutionSteps": {
    "zh-Hant": [
      "原本餘 2，加上 9 等於再加上 5 和 4。",
      "加上 5 不改變餘數，所以只要看 2 + 4 = 6。",
      "6 除以 5 餘 1。"
    ],
    "en": [
      "Start with remainder 2. Adding 9 is the same as adding 5 and 4.",
      "Adding 5 does not change the remainder, so only 2 + 4 matters.",
      "6 leaves remainder 1 when divided by 5."
    ]
  },
  "figure": {
    "type": "custom",
    "kind": "none",
    "params": {}
  },
  "answerMode": "multiple_choice",
  "options": {
    "A": { "zh-Hant": "0", "en": "0" },
    "B": { "zh-Hant": "1", "en": "1" },
    "C": { "zh-Hant": "2", "en": "2" },
    "D": { "zh-Hant": "4", "en": "4" }
  },
  "correctAnswer": {
    "type": "choice",
    "value": "B"
  },
  "source": {
    "type": "rewritten_olympiad_style",
    "name": "MathSpring Editorial",
    "reference": "number-theory-remainders-sample",
    "rightsStatus": "cleared_for_bundle"
  }
}
```

## algebra sample

Template family:

- `equivalent_substitution`
- tier: `foundation`
- answer mode: `integer_input`

Example JSON:

```json
{
  "id": "algebra_grade5_foundation_sample_001",
  "topic": "algebra",
  "subtopic": "equivalent_substitution",
  "difficulty": "foundation",
  "levelStage": "grade5",
  "challengeTier": "foundation",
  "prompt": {
    "zh-Hant": "如果 △ = 6，而且 ○ = △ + 4，那麼 ○ 是多少？",
    "en": "If △ = 6 and ○ = △ + 4, what is ○?"
  },
  "answer": {
    "zh-Hant": "答案是 10。",
    "en": "The answer is 10."
  },
  "solutionSteps": {
    "zh-Hant": [
      "先代入 △ = 6。",
      "所以 ○ = 6 + 4 = 10。"
    ],
    "en": [
      "Substitute △ = 6.",
      "Then ○ = 6 + 4 = 10."
    ]
  },
  "figure": {
    "type": "custom",
    "kind": "none",
    "params": {}
  },
  "answerMode": "integer_input",
  "correctAnswer": {
    "type": "integer",
    "value": "10"
  },
  "inputConstraints": {
    "allowNegative": false,
    "maxDigits": 2
  },
  "source": {
    "type": "rewritten_olympiad_style",
    "name": "MathSpring Editorial",
    "reference": "algebra-substitution-sample",
    "rightsStatus": "cleared_for_bundle"
  }
}
```

## geometry sample

Template family:

- `figure_cutting_and_rearrangement`
- tier: `competition`
- answer mode: `integer_input`

Example JSON:

```json
{
  "id": "geometry_grade5_competition_sample_001",
  "topic": "geometry",
  "subtopic": "figure_cutting_and_rearrangement",
  "difficulty": "competition",
  "levelStage": "grade5",
  "challengeTier": "competition",
  "prompt": {
    "zh-Hant": "一個邊長 6 的正方形，四個角各切去一個邊長 1 的小正方形。剩下圖形的周長是多少？",
    "en": "A square of side length 6 has a 1-by-1 square cut from each corner. What is the perimeter of the remaining figure?"
  },
  "answer": {
    "zh-Hant": "答案是 24。",
    "en": "The answer is 24."
  },
  "solutionSteps": {
    "zh-Hant": [
      "原本正方形周長是 6 × 4 = 24。",
      "每切掉一個角，少掉兩段長 1，也多出兩段長 1，周長不變。",
      "所以剩下圖形周長仍是 24。"
    ],
    "en": [
      "The original perimeter is 6 × 4 = 24.",
      "Each corner cut removes two length-1 edge pieces and adds two new length-1 edge pieces, so the perimeter does not change.",
      "The remaining figure still has perimeter 24."
    ]
  },
  "figure": {
    "type": "custom",
    "kind": "shape_diagram",
    "params": {
      "shape": "cut_corners_square"
    }
  },
  "answerMode": "integer_input",
  "correctAnswer": {
    "type": "integer",
    "value": "24"
  },
  "inputConstraints": {
    "allowNegative": false,
    "maxDigits": 2
  },
  "source": {
    "type": "rewritten_olympiad_style",
    "name": "MathSpring Editorial",
    "reference": "geometry-cutting-sample",
    "rightsStatus": "cleared_for_bundle"
  }
}
```

## combinatorics sample

Template family:

- `systematic_listing`
- tier: `foundation`
- answer mode: `integer_input`

Example JSON:

```json
{
  "id": "combinatorics_grade4_foundation_sample_001",
  "topic": "combinatorics",
  "subtopic": "systematic_listing",
  "difficulty": "foundation",
  "levelStage": "grade4",
  "challengeTier": "foundation",
  "prompt": {
    "zh-Hant": "用數字 1、2、3 各一次可以排成多少個不同的三位數？",
    "en": "Using the digits 1, 2, and 3 exactly once each, how many different three-digit numbers can be formed?"
  },
  "answer": {
    "zh-Hant": "答案是 6。",
    "en": "The answer is 6."
  },
  "solutionSteps": {
    "zh-Hant": [
      "百位可以選 3 種。",
      "十位剩 2 種，個位剩 1 種。",
      "所以共有 3 × 2 × 1 = 6 種。"
    ],
    "en": [
      "There are 3 choices for the hundreds digit.",
      "Then 2 choices remain for the tens digit and 1 for the ones digit.",
      "So there are 3 × 2 × 1 = 6 numbers."
    ]
  },
  "figure": {
    "type": "custom",
    "kind": "none",
    "params": {}
  },
  "answerMode": "integer_input",
  "correctAnswer": {
    "type": "integer",
    "value": "6"
  },
  "inputConstraints": {
    "allowNegative": false,
    "maxDigits": 1
  },
  "source": {
    "type": "rewritten_olympiad_style",
    "name": "MathSpring Editorial",
    "reference": "combinatorics-listing-sample",
    "rightsStatus": "cleared_for_bundle"
  }
}
```

## logic sample

Template family:

- `ordering_and_matching`
- tier: `competition`
- answer mode: `multiple_choice`

Example JSON:

```json
{
  "id": "logic_grade5_competition_sample_001",
  "topic": "logic",
  "subtopic": "ordering_and_matching",
  "difficulty": "competition",
  "levelStage": "grade5",
  "challengeTier": "competition",
  "prompt": {
    "zh-Hant": "甲、乙、丙三人排成一列。甲不在最前面，乙在丙前面，丙不在最後面。最前面的是誰？",
    "en": "A, B, and C stand in a line. A is not first, B is ahead of C, and C is not last. Who is first?"
  },
  "answer": {
    "zh-Hant": "答案是乙。",
    "en": "The answer is B."
  },
  "solutionSteps": {
    "zh-Hant": [
      "乙在丙前面，所以丙不可能第一。",
      "甲也不在最前面。",
      "因此最前面只能是乙。"
    ],
    "en": [
      "B stands ahead of C, so C cannot be first.",
      "A is also not first.",
      "Therefore B must be first."
    ]
  },
  "figure": {
    "type": "custom",
    "kind": "none",
    "params": {}
  },
  "answerMode": "multiple_choice",
  "options": {
    "A": { "zh-Hant": "甲", "en": "A" },
    "B": { "zh-Hant": "乙", "en": "B" },
    "C": { "zh-Hant": "丙", "en": "C" },
    "D": { "zh-Hant": "無法判斷", "en": "Cannot tell" }
  },
  "correctAnswer": {
    "type": "choice",
    "value": "B"
  },
  "source": {
    "type": "rewritten_olympiad_style",
    "name": "MathSpring Editorial",
    "reference": "logic-ordering-sample",
    "rightsStatus": "cleared_for_bundle"
  }
}
```
