# Anpu's Feather 阿努比斯的羽毛 — Competitive & UX Research

**Researched:** July 2026
**App as built:** One narrative experience in four incarnations — `apps/web` (TypeScript + Vite + Canvas, source of truth), `apps/ios` (Swift + Metal, from scratch, no web view), `apps/unity` (C# port mirroring the Metal architecture), and `archive/` (the original 2020 Processing + Kinect installation). All share the same narrative, art, music and recorded-movement data.
**Premise:** You have died. On a trip down the Nile, Anubis weighs your heart against a feather and asks you to reflect on how you lived — you answer, and you leave a wisdom card.
**Category:** Art game / interactive experience about mortality — closer to installation art than to consumer software, and it should be evaluated that way.

---

## 1. The competitive set — the works this belongs beside

| Work | What it does | Why it matters here |
|---|---|---|
| **That Dragon, Cancer** | Autobiographical game about a child's terminal illness | Established that games can hold real grief. The critical reference point for mortality-themed interactive work |
| **Everything Will Be OK / Nina Freeman's work** | Personal, confessional, formally inventive small games | The itch.io tradition this belongs to |
| **Before Your Eyes** | You blink (via webcam) and time advances; you cannot stay in a memory | **The closest mechanical analogue** — an embodied input tied to mortality, and a beautiful example of the mechanic *being* the theme |
| **Passage (Rohrer, 2007)** | Five minutes, an entire life | The canonical proof that a tiny game can say something about death |
| **Death Stranding, Spiritfarer** | Death as commercial subject | Spiritfarer especially: warmth rather than horror around dying |
| **WeCroak, We're Not Really Strangers, The Death Deck** | Non-game mortality reflection products | Prove there's an audience for *prompted reflection on death* outside games |
| **Museum/gallery interactives** (Kinect-era installations, teamLab) | The original 2020 form | The installation lineage |

**The clearest positioning:** this is closer to *Before Your Eyes* and *Passage* than to anything in an app store — a short, complete, formally-committed work whose value is the experience, not the retention.

---

## 2. What the good ones do

**Before Your Eyes' insight: the input must mean something.** Blinking to advance time is unforgettable because the mechanic *is* the theme — you lose moments involuntarily, exactly as in life. The original Kinect installation had this quality: reaching your body into the answer is a commitment that a mouse click isn't. **The web/iOS/Unity ports risk losing precisely that**, because a click is cheap and a reach is not. The `apps/web` version's "reach into it with your pointer" is the right instinct — the question is whether it retains the felt cost.

**Passage's insight: brevity is the form.** Five minutes. No menus, no settings, no tutorial. The work ends before the audience decides whether to stay.

**That Dragon, Cancer's insight: sincerity survives, cleverness doesn't.** Work about death is destroyed by irony and by mechanical over-design.

**WeCroak's insight: the prompt is the product.** Five reminders a day that you'll die, and a quote. Nothing else. Its success shows that people *want* to be asked, briefly and repeatedly, and that the ask needs no elaboration.

---

## 3. Where the opening is

1. **Mortality reflection has an audience and almost no good interactive work serving it.** Death cafés, *We're Not Really Strangers*, WeCroak, stoicism content, Ikigai/*memento mori* culture — the demand is visible in adjacent formats.
2. **The Egyptian weighing-of-the-heart myth is a gift** — it's a *judgment* framework that is genuinely non-punitive (the feather is light; the ask is honesty), and it's visually rich and instantly legible across cultures. Far better source material than a generic afterlife.
3. **The wisdom card is the strongest idea in the project.** Leaving something for the next person converts a solitary reflection into a chain. It is simultaneously the emotional payoff, the retention mechanism, and the growth loop. **Almost everything in §6 and §7 follows from it.**
4. **The bilingual framing (阿努比斯的羽毛)** is unusual and gives the work a natural second audience.
5. **The four-implementation structure is the project's main practical liability** — see §8.

---

## 4. Interaction design dynamics worth stealing

- **The input must cost something.** Reaching, holding, waiting, breathing — anything that isn't a tap. If a pointer must substitute for a Kinect, make it a *hold* or a *slow drag*, so the answer takes time and cannot be given carelessly.
- **No undo on the answer.** Irreversibility is thematically correct and mechanically simple.
- **Silence and waiting are content.** The instinct to fill dead time with feedback is exactly wrong here. Let the pause after the question sit.
- **No UI chrome.** No progress bar, no settings gear, no back button visible during the experience. Chrome converts a work into an app.
- **The card-writing moment needs the most care in the whole piece.** A blank text field is intimidating and produces jokes. A constrained prompt ("one thing you'd tell someone who hasn't died yet"), a character limit, and a slow, deliberate input produce sincerity.
- **Reading others' cards should be a gift, not a feed.** One card, given, unbrowsable. A scrollable list of strangers' wisdom becomes content; a single anonymous card given to you at the end is a moment.
- **The ending must be an ending.** Definite, complete, with no "play again" button in the first ten seconds.
- **Accessibility as a design question, not a checkbox.** A work about a life reviewed should be experienceable by people with limited mobility — which is another argument for offering pointer/keyboard/touch alternatives to the reaching gesture, carefully designed rather than grudgingly bolted on.

---

## 5. Psychological triggers — used honestly

| Trigger | Application | Note |
|---|---|---|
| **Mortality salience** | The entire premise | Well-studied: reminders of death reliably shift values toward the intrinsic and the relational. This is the work's actual mechanism |
| **Self-reflection under a frame** | A myth gives permission to answer honestly | The Egyptian framing does real work — it's not decoration |
| **Confession / catharsis** | Answering "how have you lived" privately | Powerful and needs care — see §9 |
| **Legacy / generativity** | The wisdom card. The desire to leave something is one of the strongest human motivations, and it intensifies with mortality salience | The project's core insight |
| **Reciprocity** | You leave a card; you receive one | Emotionally perfect and structurally elegant |
| **Ritual / ceremony** | Slow pacing, myth, music | What separates this from a quiz |
| **Anti-trigger: gamification** | Scores, achievements, streaks | Would destroy the work entirely |

---

## 6. Growth loops

**The card loop (the only one that matters).** You leave wisdom; a stranger receives it; they leave theirs. This is a genuine, self-sustaining loop that is also thematically inseparable from the work. Every design decision should protect it.

**The gift loop.** "Someone sent you this" — the natural way this work spreads. Not "check out this app," but "I did this and I thought of you." Design an explicit *send to one person* action rather than a share button.

**The festival/exhibition loop.** The 2020 Kinect installation is a credential. IndieCade, A MAZE, Ars Electronica, Games for Change, and museum/gallery programmes are the right venues, and the physical version is the strongest submission.

**The critical-writing loop.** Short art games about death get written about. One thoughtful piece in a games or art publication is worth more than any marketing.

**The bilingual loop.** Presenting properly in 繁中 opens a Taiwanese art/games audience that Western indie work rarely reaches, and where mortality/ancestor themes have deep cultural resonance.

---

## 7. The experience shape (not a usage loop)

```
Arrive (no menu, no account, no explanation)
  → the Nile, the boat, sound
  → Anubis. The question. YES or NO.
  → the reach — slow, deliberate, irreversible
  → the feather. the weight of your heart.
  → the ask: leave a wisdom card
  → you receive one card from someone else
  → end. no play-again button.
```

Total: 5–10 minutes. **Do not add length.** The temptation to extend an affecting five-minute work into a thirty-minute one has ruined many of them.

---

## 8. The four-implementation problem

Web (canvas), iOS (Metal), Unity (C#), and a Processing archive is an extraordinary amount of duplicated engineering for one short experience. Some honest framing:

- If the ports exist as a **technical exercise** — implementing the same immediate-mode canvas across three very different stacks — that's a legitimate and genuinely interesting piece of R&D. Say so explicitly in the README, and treat the parity as the deliverable.
- If they exist to **reach audiences**, the honest calculus is: **the web build reaches essentially everyone**, the iOS build reaches a small App Store audience that will struggle to discover it, and the Unity build reaches nobody it wouldn't otherwise. For a five-minute art piece, web is the format.
- The **installation version is the one with unique value** — a physical, embodied, gallery-sited experience is what the web can't be.

**Recommendation:** web as the public work, the installation as the exhibition work, and the iOS/Unity ports framed explicitly as an architecture study rather than as distribution.

---

## 9. Duty of care — the part that matters most

This work asks people to contemplate their own death. That is legitimate and valuable, and it also means some people will arrive at it in a bad place.

- **Provide a quiet, non-intrusive route to support.** Not a modal warning that breaks the atmosphere — a persistent, understated link on the end card and the about page, with region-appropriate crisis resources. This is standard practice for serious work in this space and it costs nothing artistically.
- **Moderate the wisdom cards.** User-submitted text shown to strangers, on a mortality theme, will attract abuse, jokes, and occasionally genuine distress. Human review before a card enters circulation. This is non-negotiable if the card loop ships publicly.
- **Never store the answers to the personal questions identifiably.** If the app asks "how have you lived," the honest thing is to not keep it. Say so in the interface — and it will produce more honest answers.
- **Don't send re-engagement notifications.** Anything that pings someone about a death-reflection app days later is intrusive and misjudged.
- **Age-appropriate framing.** Be explicit about what the work is before it starts, in a single quiet line.

---

## 10. Anti-patterns

- ❌ **Any gamification.** Scores, streaks, achievements, leaderboards.
- ❌ **A browsable feed of others' wisdom cards.** It becomes content; one gifted card stays a moment.
- ❌ **Monetisation inside the experience.** If it must be paid, it's paid before, once, cleanly — never a prompt mid-reflection.
- ❌ **Extending the runtime.**
- ❌ **Explaining the myth in a tutorial.** Let the imagery carry it.
- ❌ **Unmoderated user text.**

---

## 11. Prioritised next moves

1. **Designate the web build as the public work** and say what the ports are for.
2. **Get the reach/hold input right on pointer and touch** — the mechanic is the theme; a cheap click undoes the piece.
3. **Redesign the card-writing moment** for sincerity: constrained prompt, character limit, slow input.
4. **Card moderation pipeline** before any public card exchange.
5. **Duty-of-care links** on the end card and about page.
6. **Send-to-one-person** action instead of a generic share.
7. **繁中 version reviewed by a native speaker** — the bilingual title deserves a bilingual work.
8. **Festival and gallery submissions**, leading with the 2020 installation as provenance.
9. **Resist every impulse to add length or features.**
