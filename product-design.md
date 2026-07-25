# Anpu's Feather 阿努比斯的羽毛 — Product Design

> Design decisions for this work. Lineage and category context: [COMPETITIVE-UX-RESEARCH.md](./COMPETITIVE-UX-RESEARCH.md).

## What this is
A 5–10 minute art work about mortality — closer to *Before Your Eyes* and *Passage* than to anything in an app store. It is judged on whether the experience lands, not on retention. **Do not add length, features, or engagement mechanics; restraint is the design.**

## The four implementations (decided framing)
- **Web** = the public work (reaches essentially everyone; the right format for a five-minute piece).
- **Installation (Kinect)** = the exhibition work — the version with unique value and the strongest festival submission.
- **iOS Metal + Unity** = an architecture study; label them as that in the README so their purpose is honest.

## Experience shape
```
Arrive — no menu, no account, no explanation
 → the Nile, the boat, sound
 → Anubis. The question. YES / NO.
 → the reach: slow, deliberate, irreversible
 → the feather; the weight of your heart
 → leave a wisdom card (constrained prompt, character limit, slow input)
 → receive ONE card from a stranger
 → end. A real ending. No play-again button in the first ten seconds.
```

## Design rules
- **The input must cost something.** The Kinect reach was the theme made physical; on pointer/touch, a slow hold/drag substitutes — never a cheap click. No undo on the answer (irreversibility is thematically correct).
- Silence and waiting are content. Don't fill pauses with feedback.
- No UI chrome during the experience — no progress bar, no settings gear.
- **The card-writing moment gets the most design care in the piece.** A blank field produces jokes; a constrained prompt ("one thing you'd tell someone who hasn't died yet") + deliberate input produces sincerity.
- **Cards are gifts, not a feed.** One anonymous card, given at the end. A browsable list would turn moments into content.
- Accessibility is a design question: pointer/keyboard/touch alternatives to the reach, designed rather than bolted on — a work about a life reviewed should be experienceable with limited mobility.
- Bilingual (EN/繁中) done natively — the title already promises it.

## The card loop (the one growth mechanic — protect it)
You leave wisdom → a stranger receives it → they leave theirs. Self-sustaining and thematically inseparable. Plus a **send-to-one-person** action ("I did this and thought of you") instead of a generic share button. Festivals (A MAZE, IndieCade, Ars Electronica, Games for Change) with the 2020 installation as provenance; critical writing over marketing.

## Duty of care — non-negotiable
- Quiet, persistent support-resources link on the end card and about page (region-appropriate), never an atmosphere-breaking modal.
- **Human moderation before any card enters circulation.** User text on a mortality theme will attract abuse and occasionally real distress. This gates the public card exchange.
- Personal answers are not stored identifiably — and the interface says so (which also yields more honest answers).
- No re-engagement notifications, ever.
- One quiet line before it starts saying what the work is.

## Prohibited
Gamification of any kind · monetisation inside the experience (paid = once, before, cleanly) · explaining the myth in a tutorial · extending the runtime · unmoderated user text.

## Open decisions
- Whether the card exchange ships at public launch (requires the moderation pipeline) or the web version launches solitary first.
- Festival sequencing: installation-first submissions vs web-first release.
