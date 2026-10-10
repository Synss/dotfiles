# Testing

## Test doubles

Following Martin Fowler's definitions:

- **dummy**: Obj. passed around to fill a parameter list, but never
  actually used.
- **fake**: Obj. have working impl., but take some shortcut (ex. in-memory
  DB).
- **stub**: Provide canned answers.
- **spy**: Stub that also records some info based on how they were called.
- **mock**: Obj. pre-programmed with expectations which form a spec of the
  calls they are expected to received.

## See Also

- https://martinfowler.com/articles/mocksArentStubs.html
