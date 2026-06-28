---
id: example-tokens
title: Core design tokens
source: brand audit + design workshop, 2026-06
date: 2026-06-28
status: active
type: truth
---

The foundational token set. Binaries (logo files, fonts) are **not** here — they live in `/assets` and are referenced from `06-assets`.

## Color
| Token            | Hex       | Role                         |
|------------------|-----------|------------------------------|
| `color.pine`     | `#1B3A2F` | Primary brand / headings     |
| `color.slate`    | `#2E3A40` | Body text                    |
| `color.trail`    | `#C2683A` | Accent / calls to action     |
| `color.fog`      | `#F4F2EC` | Page background              |

## Type scale (1.250 major-third, 16px base)
| Token        | Size   | Use            |
|--------------|--------|----------------|
| `type.sm`    | 12.8px | Captions       |
| `type.base`  | 16px   | Body           |
| `type.lg`    | 20px   | Subheads       |
| `type.xl`    | 25px   | Section titles |
| `type.2xl`   | 31px   | Page titles    |

Families: **Söhne** (UI/body), **Tiempos** (display). Files referenced from `06-assets`.

## Spacing (4px base)
`space.1`=4 · `space.2`=8 · `space.3`=16 · `space.4`=24 · `space.5`=40 · `space.6`=64

**Why:** A restrained, earthy palette and a single modular scale keep the system calm and evidence-led rather than loud — consistent with a voice that trusts the reader. Tokenizing the values lets web, print, and product share one source of truth.
