{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

module Karamaan.Opaleye.Pack where

flatten0 () = ()
unflatten0 () = ()

flatten1 a = a
unflatten1 a = a

flatten2 (a, b) = (a, b)
unflatten2 (a, b) = (a, b)

flatten3 (a, (b, c)) = (a, b, c)
unflatten3 (a, b, c) = (a, (b, c))

flatten4 (a, (b, (c, a4))) = (a, b, c, a4)
unflatten4 (a, b, c, a4) = (a, (b, (c, a4)))

flatten5 (a, (b, (c, (a4, a5)))) = (a, b, c, a4, a5)
unflatten5 (a, b, c, a4, a5) = (a, (b, (c, (a4, a5))))

flatten6 (a, (b, (c, (a4, (a5, a6))))) = (a, b, c, a4, a5, a6)
unflatten6 (a, b, c, a4, a5, a6) = (a, (b, (c, (a4, (a5, a6)))))

flatten7 (a, (b, (c, (a4, (a5, (a6, a7)))))) = (a, b, c, a4, a5, a6, a7)
unflatten7 (a, b, c, a4, a5, a6, a7) = (a, (b, (c, (a4, (a5, (a6, a7))))))

flatten8 (a, (b, (c, (a4, (a5, (a6, (a7, a8)))))))
  = (a, b, c, a4, a5, a6, a7, a8)
unflatten8 (a, b, c, a4, a5, a6, a7, a8)
  = (a, (b, (c, (a4, (a5, (a6, (a7, a8)))))))

flatten9 (a, (b, (c, (a4, (a5, (a6, (a7, (a8, a9))))))))
  = (a, b, c, a4, a5, a6, a7, a8, a9)
unflatten9 (a, b, c, a4, a5, a6, a7, a8, a9)
  = (a, (b, (c, (a4, (a5, (a6, (a7, (a8, a9))))))))

flatten10 (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, a10)))))))))
  = (a, b, c, a4, a5, a6, a7, a8, a9, a10)
unflatten10 (a, b, c, a4, a5, a6, a7, a8, a9, a10)
  = (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, a10)))))))))

flatten11 (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, (a10, a11))))))))))
  = (a, b, c, a4, a5, a6, a7, a8, a9, a10, a11)
unflatten11 (a, b, c, a4, a5, a6, a7, a8, a9, a10, a11)
  = (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, (a10, a11))))))))))

flatten12 (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, (a10, (a11, a12)))))))))))
  = (a, b, c, a4, a5, a6, a7, a8, a9, a10, a11, a12)
unflatten12 (a, b, c, a4, a5, a6, a7, a8, a9, a10, a11, a12)
  = (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, (a10, (a11, a12)))))))))))

flatten13 (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, (a10, (a11, (a12,
           a13))))))))))))
  = (a, b, c, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13)
unflatten13 (a, b, c, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13)
  = (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, (a10, (a11, (a12, a13))))))))))))

flatten14 (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, (a10, (a11, (a12,
           (a13, a14)))))))))))))
  = (a, b, c, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14)
unflatten14 (a, b, c, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14)
  = (a, (b, (c, (a4, (a5, (a6, (a7, (a8, (a9, (a10, (a11, (a12, (a13, a14)))))))))))))
