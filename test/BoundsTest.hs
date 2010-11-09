import Graphics.Rendering.Diagrams
import Graphics.Rendering.Diagrams.Transform

import Diagrams.TwoD

import Diagrams.Backend.Cairo
import Diagrams.Combinators
import Diagrams.Path
import Diagrams.Segment

import Data.VectorSpace

p = stroke $ Path False zeroV [Linear (1.0,0.0),Linear (0.0,1.0)]
bez = stroke $ Path False zeroV [Cubic (1.0,0.0) (0.0,1.0) (1.0,1.0)]
ell = scaleX 2 $ scaleY 0.5 circle

-- correct:
b1 = runBoundsTest box
b2 = runBoundsTest circle
b3 = runBoundsTest p

-- failures:
b4 = runBoundsTest bez
b5 = runBoundsTest ell
b6 = runBoundsTest (scale 2 box)
b7 = runBoundsTest (scale 2 circle)
b8 = runBoundsTest (scale 2 p)
b9 = runBoundsTest (scale 2 bez)
b10 = runBoundsTest (scale 2 ell)

runBoundsTest :: Diagram Cairo -> Diagram Cairo
runBoundsTest d = scale 20 $ translate (10,10) (sampleBounds2D 10 d)

sampleBounds2D :: Int -> Diagram Cairo -> Diagram Cairo
sampleBounds2D n d = foldr atop d bs
    where b  = getBounds (bounds d)
          bs = [stroke $ mkLine (s *^ v) (perp v) | v <- vs, let s = b v]
          vs = [(cos t, sin t) | i <- [0..n]
                               , let t = ((fromIntegral i) * 2.0 * pi) / (fromIntegral n)]
          mkLine a v = Path False a [Linear v]
          perp (x,y) = (-y,x)
          getBounds (Bounds f) = f

opts = CairoOptions "test2.pdf" $ PDF (400, 400)
main = renderDia Cairo opts b5
