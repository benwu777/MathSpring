# Paper-Doll Avatar Design

## Scope

MathSpring learners receive a locally stored, flat-illustration paper-doll avatar.
Creation begins by choosing a boy or girl presentation. Each presentation has an
independent component library; components are not shared across presentations.

The first release supports six categories, each with at least five choices for
each presentation:

- Skin tone
- Face shape
- Hairstyle
- Eyes / glasses
- Nose
- Mouth

Clothing and accessories are explicitly out of scope for this release.

## Experience

New-learner creation presents one step at a time: presentation, skin tone, face
shape, hairstyle, eyes / glasses, nose, and mouth. A large preview updates
immediately; Back and Next retain prior selections. The learner is only saved
after the final confirmation step.

The profile area displays the completed avatar. Selecting it opens the same
editor for an existing learner, so all choices can be changed later without
achievement or progression restrictions. Avatars appear consistently in learner
lists, the active learner card, history, and achievements.

## Rendering and persistence

The avatar uses consistently aligned flat illustration layers: skin/face at the
base, then nose, mouth, eyes/glasses, and hair. Each learner stores the chosen
presentation and one component identifier per category. New components can be
added without changing existing learner data. Learners created before this
feature receive a deterministic default avatar when loaded.

All data remains on-device with the existing learner records; no account,
network connection, or analytics is needed.

## Verification

Automated coverage must prove that both component libraries contain at least
five options per category, saved choices survive reload, editing updates the
learner's avatar, and legacy learners get safe defaults. Widget tests cover the
step-by-step selection flow and immediate preview changes. Visual checks confirm
layer registration and alignment for representative combinations.
