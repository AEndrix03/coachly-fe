# Workout Detail redesign: capability baseline

Discovery performed before the Workout Detail & Builder redesign.

| Capability | Existing | FE only | Missing / action |
| --- | --- | --- | --- |
| Exercise ordering | Yes, stable entry positions | No | Preserve IDs through draft and writes |
| Rep target | Yes, one value per set | No | Add optional min/max representation |
| RIR / RPE / %1RM | No | No | Extend the versioned workout contract |
| Set types | Warm-up, approach, drop set, cluster, failure, rest-pause, AMRAP | No | Add top-set/back-off semantics without changing logger |
| Superset | Implicit: a block with 2+ entries | No | Make group type and rounds explicit |
| Circuit | No | No | Add explicit group type and rounds |
| Sections | No | No | Add optional ordered section metadata; legacy workouts map to one implicit section |
| Exercise/workout notes | Set, block and workout translation description | No | Preserve the distinction in ViewData and draft |
| Local persistence | Hive workout cache plus structured snapshot | No | Persist the completed edit draft locally before remote sync |
| Offline sync | Session queue only | No | Add a small template-sync queue/retry path rather than writing during each interaction |
| Add Exercise catalog | Cached local catalog plus remote refresh | No | Reuse it with debounced search and compact filters |

## Compatibility rules

- Legacy blocks remain valid. A single-entry block maps to an exercise; a
  multi-entry block maps to a superset.
- A workout without explicit sections renders as one implicit section without
  a `Main` heading.
- Missing exercise metadata never prevents prescription rendering.
- New programming fields are optional in requests and responses.
- UI widgets depend on Workout Detail ViewData, not API DTOs.
- The redesign has one route-level switching point; persistence capabilities
  are never scattered as conditionals through widgets.

## Scope boundary

The Active Workout/logger, global navigation, progression assistant, voice and
AI editing remain unchanged. The redesigned page prepares structured
prescriptions for those future consumers without exposing unfinished features.
