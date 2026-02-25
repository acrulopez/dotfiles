---
name: humanize
description: Rewrite text to remove signs of AI writing and make it sound human-written. Use when user wants to humanize, de-AI, or naturalize text. Triggers include "humanize", "make it sound human", "remove AI writing", "de-AI", "naturalize text", "make it natural", "sounds like AI". Accepts pasted text or a file path as argument.
---

# Humanize Text

Rewrite text to eliminate AI writing patterns based on Wikipedia's Signs of AI Writing guide.

## Input/Output

- **Pasted text**: User provides text inline after invoking the skill. Write output to `humanized-output.md` in the current directory.
- **File path argument**: User provides a path (e.g., `/humanize docs/post.md`). Read the file, write output to `humanized-<filename>` in the same directory as the source file.

Preserve the original meaning, facts, and structure. Only change how things are said, not what is said.

## Rewriting Rules

Apply all rules below in a single pass. When in doubt, prefer plain, direct language.

### 1. Kill AI Vocabulary

Replace these overused AI words with plain alternatives or remove them:

delve, tapestry, landscape (abstract), multifaceted, pivotal, foster, testament, harness, illuminate, facilitate, bolster, realm, beacon, vibrant, showcase (verb), intricate, crucial, underscore (verb), enhance, garner, interplay, nuanced, comprehensive, robust, key (adj), enduring, seamlessly, cutting-edge, revolutionary, empower, leverage (verb), navigate (abstract), elevate, cornerstone, spearhead, encompass, myriad, plethora, paramount, aforementioned, noteworthy, commendable

Fix: Use the simplest word that fits. "Delve into" → "look at". "Facilitate" → "help". "Leverage" → "use". "Robust" → "strong" or just cut it. If removing the word leaves the sentence intact, remove it.

### 2. Strip Puffery

Remove grandiose importance claims that inflate the subject:

- "stands as a testament to" → cut or say what it actually shows
- "plays a vital/crucial/pivotal role" → "matters for" or "helps with"
- "rich cultural heritage" → name what's actually there
- "breathtaking", "stunning", "remarkable", "extraordinary" → use specific descriptions or cut
- "dynamic hub of activity" → say what actually happens there
- "captivates both residents and visitors alike" → cut entirely
- Any sentence whose only job is to say the topic is important → delete it

### 3. Remove Editorializing

Cut meta-commentary that tells the reader what to think:

- "It's important to note that..." → just state the fact
- "It is worth mentioning..." → just mention it
- "No discussion would be complete without..." → cut, just discuss it
- "Interestingly,..." → cut
- "Notably,..." → cut or keep only if genuinely surprising
- "It should be emphasized that..." → cut

### 4. Break Structural Formulas

**Rule of threes**: If adjectives/items come in triplets, vary the count — use 2 or 4, or restructure.

**Compulsive summaries**: Remove "Overall,", "In conclusion,", "In summary,", "To summarize," — especially when the text is too short to need one. If a summary restates what was just said, delete it.

**Negative parallelisms**: Rewrite "It's not just X, it's Y" and "It isn't X — it's Y" into direct statements.

**Excessive transitions**: Cut or vary "Moreover,", "Furthermore,", "Additionally,", "On the other hand,", "Not only... but also...". Use shorter connectors or just start the sentence.

### 5. Fix Trailing Participle Clauses

Remove dangling present participle phrases tacked onto sentences:

- "...emphasizing the importance of diversity" → cut or make it its own sentence
- "...reflecting the continued relevance of the movement" → cut
- "...highlighting the need for further research" → cut
- "...making it a popular destination for tourists" → cut or rewrite as a new sentence

These almost always add fluff, not information.

### 6. Fix Em Dash Overuse

Replace most em dashes (—) with commas, parentheses, colons, or periods. Keep em dashes only for genuine dramatic interruption or aside. If a paragraph has more than one em dash, it has too many.

### 7. Fix Style Tells

- **Title case headings**: Use sentence case ("How it works" not "How It Works")
- **Excessive lists**: Convert bullet lists back to prose where they read more naturally
- **Synonym cycling**: If the text uses 4 different words for the same thing to avoid repetition (e.g., "the artist", "the creator", "the visionary", "the master"), pick one and reuse it. Repetition is natural.
- **Uniform sentence length**: Vary it. Mix short punchy sentences with longer ones. Add fragments if they fit.
- **Excessive bolding/formatting**: Reduce. Plain text is fine.

### 8. Fix Tone

- **Promotional language**: Replace "scenic", "world-class", "state-of-the-art", "innovative", "best-in-class" with concrete descriptions
- **Sycophantic openers**: Remove "Certainly!", "Absolutely!", "Great question!", "Of course!"
- **Corporate flatness**: Add personality. Use contractions (it's, don't, can't). Vary formality. Be direct.
- **Excessive hedging**: Cut "generally speaking", "to some extent", "it could be argued that", "in many ways". State things plainly or qualify with specifics.

### 9. Remove Artifacts

Delete any of these immediately:

- "As an AI language model...", "I hope this helps", "Let me know if...", "Would you like me to expand on..."
- "As of my last training data...", "Up to my last training update..."
- Markdown formatting artifacts in non-markdown context (stray `**`, `_`, `##`)
- Reference codes like `[oaicite:0]`, `turn0search0`
- "Here's a comprehensive overview of..."

### 10. Add Genuine Depth

- Replace generic claims with specific details where possible
- If a sentence says something is "significant" or "important", either explain why concretely or cut it
- Prefer one vivid specific over three vague adjectives
- If the text reads like a brochure or press release, make it read like a person explaining something to a friend

## Quality Check

Before writing the output file, verify:

1. No words from Rule 1 remain unless contextually irreplaceable
2. No sentence exists solely to assert importance (Rule 2)
3. No meta-commentary phrases remain (Rule 3)
4. No triplet adjective patterns (Rule 4)
5. Sentence length varies naturally (Rule 7)
6. Text has a consistent, human voice — not corporate or promotional
7. Every sentence carries actual information or moves the text forward
