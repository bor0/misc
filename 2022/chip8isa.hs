{-# LANGUAGE BinaryLiterals #-}

import qualified Data.Word as W (Word8, Word16)
import Data.Bits

type Reg = W.Word16
--type Reg = W.Word8
type Reg4 = W.Word16
type Reg8 = W.Word16
type Reg12 = W.Word16
type Nibble = W.Word16

data SetExpr =
  Imm Reg8
  | Add Reg8
  | ImmReg Reg
  | Or Reg
  | And Reg
  | Xor Reg
  | AddReg Reg
  | SubReg Reg
  | ShiftL
  | Minus Reg
  | ShiftR
  | Rand
  deriving (Show)

data Instruction =
  ClearScreen
  | Return
  | Goto Reg12
  | Call Reg12
  | SkipIfEq Reg Reg8
  | SkipIfNeq Reg Reg8
  | SkipIfRegEq Reg Reg
  | Set Reg SetExpr
  | SkipIfRegNeq Reg Reg
  | SetI Reg12
  | SetPC Reg12
  | Draw Reg Reg Reg4 
  | SkipIfKeyEq Reg
  | SkipIfKeyNeq Reg
  | GetDelay Reg
  | GetKey Reg
  | SetDelay Reg
  | SetSound Reg
  | AddI Reg
  | SetISprite Reg
  | BCD Reg
  | RegDump Reg
  | RegLoad Reg
  deriving (Show)

data VM = VM {
  registers :: [W.Word8],
  regI :: W.Word16,
  regPC :: W.Word16,
  regSP :: W.Word16,
  memory :: [W.Word8],
  display :: [W.Word8],
  stack :: [W.Word16],
  key :: [W.Word8],
  halt :: W.Word8,
  soundTimer :: W.Word8,
  delayTimer :: W.Word8
  }
  deriving (Show)

parseInstructionWord :: W.Word16 -> (Nibble, Nibble, Nibble, Nibble)
parseInstructionWord x = (getNibble x 3, getNibble x 2, getNibble x 1, getNibble x 0)
  where
  getNibble x n = shiftR (x .&. shiftL 0b1111 (n * 4)) (n * 4)

parse :: W.Word16 -> Maybe Instruction
parse opcode = case parseInstructionWord opcode of
  (0x0, 0x0, 0xE, 0x0) -> Just ClearScreen
  (0x0, 0x0, 0xE, 0xE) -> Just Return
  (0x1, _,   _,     _) -> Just $ Goto r12
  (0x2, _,   _,     _) -> Just $ Call r12
  (0x3, _,   _,     _) -> Just $ SkipIfEq x r12
  (0x4, _,   _,     _) -> Just $ SkipIfNeq x r12
  (0x5, _,   _,   0x0) -> Just $ SkipIfRegEq x y
  (0x6, _,   _,     _) -> Just $ Set x (Imm r8)
  (0x7, _,   _,     _) -> Just $ Set x (Add r8)
  (0x8, _,   _,   0x0) -> Just $ Set x (ImmReg y)
  (0x8, _,   _,   0x1) -> Just $ Set x (Or y)
  (0x8, _,   _,   0x2) -> Just $ Set x (And y)
  (0x8, _,   _,   0x3) -> Just $ Set x (Xor y)
  (0x8, _,   _,   0x4) -> Just $ Set x (AddReg y)
  (0x8, _,   _,   0x5) -> Just $ Set x (SubReg y)
  (0x8, _,   _,   0x6) -> Just $ Set x ShiftL
  (0x8, _,   _,   0x7) -> Just $ Set x (Minus y)
  (0x8, _,   _,   0xE) -> Just $ Set x ShiftR
  (0x9, _,   _,   0x0) -> Just $ SkipIfRegNeq x y
  (0xA, _,   _,     _) -> Just $ SetI r12
  (0xB, _,   _,     _) -> Just $ SetPC r12
  (0xC, _,   _,     _) -> Just $ Set x Rand
  (0xD, _,   _,     _) -> Just $ Draw x y r4
  (0xE, _, 0x9,   0xE) -> Just $ SkipIfKeyEq x
  (0xE, _, 0xA,   0x1) -> Just $ SkipIfKeyNeq x
  (0xF, _, 0x0,   0x7) -> Just $ GetDelay x
  (0xF, _, 0xA,   0x1) -> Just $ GetKey x
  (0xF, _, 0x1,   0x5) -> Just $ SetDelay x
  (0xF, _, 0x1,   0x8) -> Just $ SetSound x
  (0xF, _, 0x1,   0xE) -> Just $ AddI x
  (0xF, _, 0x2,   0x9) -> Just $ SetISprite x
  (0xF, _, 0x3,   0x3) -> Just $ BCD x
  (0xF, _, 0x5,   0x5) -> Just $ RegDump x
  (0xF, _, 0x6,   0x5) -> Just $ RegLoad x
  _ -> Nothing
  where
  (_, x, y, _) = parseInstructionWord opcode
  r4  = opcode .&. 0b0000000000001111
  r8  = opcode .&. 0b0000000011111111
  r12 = opcode .&. 0b0000111111111111

eval :: VM -> Instruction -> VM
eval vm i = go (withPCupdate vm) i
  where
  withPCupdate vm@(VM {regPC = _regPC}) = vm { regPC = _regPC + 2 }
  go vm ClearScreen = vm { display = replicate 2048 0 }
  go vm (Goto x)    = vm { regI = x }
  go vm (SetI x)    = vm { regI = x }
  go vm (SetPC x)   = vm { regPC = x }
