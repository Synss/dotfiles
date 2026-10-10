# Typing

## Algebraic data types

- **sum**: Enumerated types.
- **product**: Tuples and records.

## Variance

```haskell
f :: contra -> co
```

- **contravariance (in)**: Reverses the inheritance direction.
- **covariance (out)**: Preserves the inheritance direction.

## De Morgan's laws

```haskell
-- First Law: not (A or B) == (not A) and (not B)
dM1 :: Bool -> Bool -> Bool
dM1 a b = not (a || b) == (not a && not b)

-- Second Law: not (A and B) == (not A) or (not B)
dM2 :: Bool -> Bool -> Bool
dM2 a b = not (a && b) == (not a || not b)
```
