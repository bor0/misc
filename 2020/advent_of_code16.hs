import qualified Data.Map as M
import Data.List (sortBy, groupBy)
import Data.Function (on)

type TicketId = Integer
type Ticket   = [TicketId]
type Location = String
type RuleData = [Integer]
type Rules    = M.Map Location RuleData
type Column   = Int

-- Given rules and a list of tickets, only filter the valid ones
filterValidTickets :: Rules -> [Ticket] -> [Ticket]
filterValidTickets rules = filter (ticketValid rules) where
  ticketValid rules ticketIds = let
    allRules = concat $ M.elems rules
    in not $ any (`notElem` allRules) ticketIds

-- Whether a list of tickets is valid - for every ticket, the specific column passes a specific rule
ticketValidByColumnAndLocation :: Rules -> [Ticket] -> Column -> Location -> Bool
ticketValidByColumnAndLocation rules ticketIds column location =
  let ruleTicketIds     = rules M.! location
      columnedTicketIds = map (!! column) ticketIds
  in all (`elem` ruleTicketIds) columnedTicketIds

-- Go through all combinations of rules and column indices, filtering only the valid ones.
getValidityCombinations rules tickets =
  let validTickets = filterValidTickets rules tickets
      calculation = [ (location, col) | location <- M.keys rules,
                                        col <- [0..length validTickets - 1],
                                        ticketValidByColumnAndLocation rules validTickets col location ]
      in calculation

-- This function will process validity combinations by sorting them by the column and then grouping them by the column.
-- For example, `[("class",1),("class",2),("row",0),("row",1),("row",2),("seat",2)]` turns to
-- `[[("row",0)],[("class",1),("row",1)],[("class",2),("row",2),("seat",2)]]`.
-- We can then further process this in an easier way to determine the columns.
-- For example, for column 0 it's only `row` that satisfies, so we can conclude the mapping 0 -> `row`.
processValidityCombinations combinations = let
      sortedCalc  = sortBy (compare `on` snd) combinations
      groupedCalc = groupBy (\p1 p2 -> snd p1 == snd p2) sortedCalc
      in groupedCalc

-- The following function is just an iterative approach to the same idea of `processValidityCombinations`.
getColumns rules tickets = go (processValidityCombinations $ getValidityCombinations rules tickets) [] where
  go []        acc = acc -- return the determined columns
  go (x : xs') acc =
    let filtered_x = filter (\x -> fst x `notElem` map fst acc) x -- remove all determined columns so far
    in  go xs' (head filtered_x : acc)

---- Sample data
rules = M.fromList [("class", [0..1] ++ [4..19]),
                    ("row", [0..5] ++ [8..19]),
                    ("seat", [0..13] ++ [16..19])]

myTicket :: Ticket
myTicket = [11,12,13]

tickets :: [Ticket]
tickets = [[15,1,5],
           [3,9,18],
           [5,14,9]]

tickets' :: [Ticket]
tickets' = [[1,15,5],
           [9,3,18],
           [14,5,9]]
