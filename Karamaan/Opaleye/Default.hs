{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances #-}

module Karamaan.Opaleye.Default where

import Karamaan.Opaleye.Wire (Wire)
import Karamaan.Opaleye.Colspec (Colspec'(Colspec'), writerWire, packMapWire)
-- TODO: vv this imports a lot of names.  Should we list them all?
import Data.Profunctor.Product

class Default p a b where
  -- Would rather call it "default", but that's a keyword
  def :: p a b

instance ProductProfunctor p => Default p () () where
  def = empty

-- FIXME: um, shouldn't this be defined in Colspec?
instance Default Colspec' (Wire a) (Wire a) where
  def = Colspec' writerWire packMapWire

instance (ProductProfunctor p, Default p a1 b1, Default p a2 b2)
         => Default p (a1, a2) (b1, b2) where
  def = p2 (def, def)

instance (ProductProfunctor p, Default p a1 b1, Default p a2 b2,
          Default p a3 b3)
         => Default p (a1, a2, a3)
                      (b1, b2, b3) where
  def = p3 (def, def, def)

instance (ProductProfunctor p, Default p a1 b1, Default p a2 b2,
          Default p a3 b3, Default p a4 b4, Default p a5 b5)
         => Default p (a1, a2, a3, a4, a5)
                      (b1, b2, b3, b4, b5) where
  def = p5 (def, def, def, def, def)

instance (ProductProfunctor p, Default p a1 b1, Default p a2 b2,
          Default p a3 b3, Default p a4 b4, Default p a5 b5,
          Default p a6 b6, Default p a7 b7)
         => Default p (a1, a2, a3, a4, a5, a6, a7)
                      (b1, b2, b3, b4, b5, b6, b7) where
  def = p7 (def, def, def, def, def, def, def)

instance (ProductProfunctor p, Default p a1 b1, Default p a2 b2,
          Default p a3 b3, Default p a4 b4, Default p a5 b5,
          Default p a6 b6, Default p a7 b7, Default p a8 b8)
         => Default p (a1, a2, a3, a4, a5, a6, a7, a8)
                      (b1, b2, b3, b4, b5, b6, b7, b8) where
  def = p8 (def, def, def, def, def, def, def, def)

instance (ProductProfunctor p, Default p a1 b1, Default p a2 b2,
          Default p a3 b3, Default p a4 b4, Default p a5 b5,
          Default p a6 b6, Default p a7 b7, Default p a8 b8,
          Default p a9 b9, Default p a10 b10)
         => Default p (a1, a2, a3, a4, a5, a6, a7, a8,
                       a9, a10)
                      (b1, b2, b3, b4, b5, b6, b7, b8,
                      b9, b10) where
  def = p10 (def, def, def, def, def, def, def, def, def, def)

instance (ProductProfunctor p, Default p a1 b1, Default p a2 b2,
          Default p a3 b3, Default p a4 b4, Default p a5 b5,
          Default p a6 b6, Default p a7 b7, Default p a8 b8,
          Default p a9 b9, Default p a10 b10, Default p a11 b11,
          Default p a12 b12)
         => Default p (a1, a2, a3, a4, a5, a6, a7, a8,
                       a9, a10, a11, a12)
                      (b1, b2, b3, b4, b5, b6, b7, b8,
                      b9, b10, b11, b12) where
  def = p12 (def, def, def, def, def, def, def, def, def, def, def, def)

instance (ProductProfunctor p, Default p a1 b1, Default p a2 b2,
          Default p a3 b3, Default p a4 b4, Default p a5 b5,
          Default p a6 b6, Default p a7 b7, Default p a8 b8,
          Default p a9 b9, Default p a10 b10, Default p a11 b11,
          Default p a12 b12, Default p a13 b13, Default p a14 b14)
         => Default p (a1, a2, a3, a4, a5, a6, a7, a8,
                       a9, a10, a11, a12, a13, a14)
                      (b1, b2, b3, b4, b5, b6, b7, b8,
                      b9, b10, b11, b12, b13, b14) where
  def = p14 (def, def, def, def, def, def, def, def, def, def,
             def, def, def, def)