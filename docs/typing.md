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

## Functors, monoids and monads

- **Functor (mappable)**: A structure that can be mapped over (like
  `Array.map` or `Optional.map`).

  ```haskell
  class Functor f where
      fmap :: (a -> b) -> f a -> f b
  ```

  Laws:

  ```haskell
  fmap id      == id               -- identity
  fmap (g . f) == fmap g . fmap f  -- composition
  ```

- **Monoid (combiner)**: A set of elements with an associative binary
  operation and an identity element (ex. string concat with `""`, or
  numbers `+ 0`.

  ```haskell
  class Semigroup a => Monoid a where
    mempty  :: a                  -- identity element
    mappend :: a -> a -> a        -- binary operation (noted as <>)
    mconcat :: [a] -> a           -- folds a list of monoids into one
    mconcat = foldr (<>) mempty
  ```

  Laws:

  ```haskell
  mempty <> x   == x
  x <> mempty   == x
  (x <> y) <> z == x <> (y <> z)  -- associativity
  ```

- **Monad (chainer)**: A structure that allows chaining operations that return the
  same structure (`flatmap`, `bind`).

  ```haskell
  -- Wraps a raw value
  class Applicative m => Monad m where
     return :: a -> m a
     return = pure

  -- The bind operator (maps and flattens)
     (>>=)  :: m a -> (a -> m b) -> m b
  ```

  Laws:

  ```haskell
  return x >>= f   == f x                      -- Left identity
  m >>= return     == m                        -- Right identity
  (m >>= f) >>= g  == m >>= (\x -> f x >>= g)  -- Associativity
  ```
