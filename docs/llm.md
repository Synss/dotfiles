# LLM

## Transparency on LLM Usage

Add these trailers to a commit message to establish the primary
creator of the change, the human or the LLM. The trailer is
optional.

- `Generated-By: ...`: the LLM is the primary creator. An
  open-ended prompt describes the desired behavior, and the LLM
  decides the design and implementation.
- `Executed-By: ...`: the human is the primary creator. The
  human decides the design, for example an interface to
  implement, a fragment to refactor, a rename, or the direction
  given across an iterative prompting session. The LLM carries
  it out.

### Examples

| Use case | Primary creator | Trailer |
| -------- | --------------- | ------- |
| "Write X that does Y." | LLM | Generated-By |
| "Optimize that function." (no specs) | LLM | Generated-By |
| "Implement this interface: <specs>" | Human | Executed-By |
| "Fix bug where X happens under Y..." | Human | Executed-By |
| Iterative prompting | Human | Executed-By |

## See Also

- https://github.com/artsy/README/pull/582 proposes `Assisted-By`
  as a generic, non-mandatory trailer.
- https://www.baristalabs.io/blog/ai-assisted-commits-need-provenance-trailer
  discusses `Co-Authored-By` vs `Assisted-By`.
- https://openinfra.org/legal/ai-policy defines the trailers based
  on the volume of LLM-generated code.
