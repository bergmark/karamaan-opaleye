module Karamaan.Opaleye.Values where

import Prelude hiding (Integer)
import Karamaan.Opaleye.QueryArr (Query)
import Karamaan.Opaleye.Colspec (col)
import Karamaan.Opaleye.Table (makeTable)
import Data.List (intercalate)
import Karamaan.Opaleye.Wire (Wire)
import Control.Arrow ((***), first)
import Control.Monad.State (State, get, put, runState)
import Control.Monad.Reader (ReaderT, runReaderT, ask)
import Karamaan.Opaleye.Colspec (Colspec, colsT2)
import qualified Karamaan.WhaleUtil.Date as UD
import Data.Time.Calendar
import Karamaan.Opaleye.Predicates (singleEnquoten)
import Control.Applicative (liftA2)

type S a = ReaderT String (State Int) a

data SQLType = Integer | Text | Date | Boolean deriving Show

showSQLType :: SQLType -> String
-- vv Just using show works currently, but there's no reason
--    it will for all the types we want to represent, so
--    consider this function as a "hack for now".
showSQLType = show

-- TODO: don't know why these are in a tuple!
-- We would like to enforce the condition that ValuesMaker (f, c) ts
-- has the image of f with constant length, which equals the length of
-- ts, and also matches c in length somehow too I guess.  Not sure how to
-- arrange that.
-- Probably should make a type for it, in fact.
-- data ConstLengthListMap a = C (a -> [String])
-- and then only provide operators that preserve that condition.
data ValuesMaker a b = ValuesMaker (a -> [String], S (Colspec b), [SQLType])

-- If and when we make Colspec a profunctor I guess we could make
-- ValuesMaker a profunctor
--bimap :: (a' -> a) -> (b -> b' ) -> ValuesMaker a b -> ValuesMaker a' b'
--bimap f g (ValuesMaker p q) = ValuesMaker (fmap (. f) p) (fmap g q)

(****) :: ValuesMaker a b -> ValuesMaker a' b' -> ValuesMaker (a, a') (b, b')
(****) (ValuesMaker (f, m, ts)) (ValuesMaker (f', m', ts'))
  = ValuesMaker (f'', m'', ts'')
  where f'' = catResults f f'
        m'' = liftA2 (curry colsT2) m m'
        ts'' = ts ++ ts'

(.:.) :: (r -> z) -> (a -> b -> c -> r) -> (a -> b -> c -> z)
(f .:. g) x y z = f (g x y z)

catResults :: (a -> [r]) -> (c -> [r]) -> (a, c) -> [r]
catResults = uncurry (++) .:. (***)

nextCol :: S Int
nextCol = do { a <- get; put (a + 1); return a }

nextColName :: S String
nextColName = do { s <- ask; a <- nextCol; return (s ++ show a) }

string :: ValuesMaker String (Wire String)
string = valuesMakerMaker singleEnquoten Text

int :: ValuesMaker Int (Wire Int)
int = valuesMakerMaker show Integer

day :: ValuesMaker Day (Wire Day)
day = valuesMakerMaker dayToSQL Date

bool :: ValuesMaker Bool (Wire Bool)
bool = valuesMakerMaker show Boolean

valuesMakerMaker :: (a -> String) -> SQLType -> ValuesMaker a (Wire b)
valuesMakerMaker f t = ValuesMaker ((:[]) . f, w, [t])
  where w = do { n <- nextColName; return (col n) }

-- TODO: this doesn't belong here
dayToSQL :: Day -> String
dayToSQL = (++ " :: date") . singleEnquoten . UD.dayToSQL

-- colsT0 doesn't exist, but if it did I think this would work
--unit :: ValuesMaker () ()
--unit = ValuesMaker (return (const [])) (return colsT0)

runValuesMaker :: ValuesMaker a b -> String -> [a]
                  -> ([[String]], Colspec b, Int, [SQLType])
runValuesMaker (ValuesMaker (f, m, ts)) colPrefix a
   = (stringRows, colspec, nextCol', ts)
  where startColNum = 1
        mapper = f
        (colspec, nextCol') = runS m colPrefix startColNum
        stringRows = map mapper a

runS :: S a -> String -> Int -> (a, Int)
runS m c s = runState (runReaderT m c) s

-- I guess we'll have a bug if there are no columns at all, but it doesn't seem
-- like we can create a zero column ValuesMaker without the constructor, so
-- that's nice.
-- We *had* a bug where we couldn't create tables with no rows, but I fixed
-- that with a hack.  It requires the Postgres type information to be passed
-- around unfortunately, too, because the trick requires we use NULLs, and
-- Postgres doesn't have polymorphism (at least the right kind of polymorphism).
valuesToQuery' :: ([[String]], Colspec b, Int, [SQLType]) -> Query b
valuesToQuery' (stringRows, colspec, nextCol', ts) = makeTable colspec select
  where colNumbers = map show [1..nextCol'-1]
        columnSelectors = map colNames colNumbers
        colNames x = "column" ++ x ++ " as foocol" ++ x
        select = (embracket . intercalate " ") [ "select"
                                               , intercalate "," columnSelectors
                                               , "from"
                                               , values
                                               , "as foo"
                                               , maybeWhere ]
        whenSome = (stringRows, "")
        whenNone = ([map nullOfType ts], "where false")

        (values, maybeWhere) = first valuesOfStringRows $ if null stringRows
                                                          then whenNone
                                                          else whenSome
        typeSig x y = x ++ " :: " ++ showSQLType y
        nullOfType = typeSig "NULL"

valueOfStringRow :: [String] -> String
valueOfStringRow = embracket . intercalate ","

valuesOfStringRows :: [[String]] -> String
valuesOfStringRows = embracket
                     . ("values "++)
                     . intercalate ","
                     . map valueOfStringRow

valuesToQuery'' :: ValuesMaker a b -> String -> [a] -> Query b
valuesToQuery'' = valuesToQuery' .:. runValuesMaker

valuesToQuery :: ValuesMaker a b -> [a] -> Query b
-- vv just provide a dummy column name
-- Not really sure what the right thing to do with this is
-- but any dummy name will always work
valuesToQuery = flip valuesToQuery'' "foocol"

embracket :: String -> String
embracket = ("("++) . (++")")
