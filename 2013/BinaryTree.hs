data BinaryTree = Node BinaryTree BinaryTree Poly | Leaf Poly deriving (Show)

-- Eq za contains
data Poly = Brojce Integer | Stringce String deriving (Eq)

-- Order \in {Inorder, Preorder, Postorder}
data BinarySearchOrder = Preorder | Inorder | Postorder

-- Instanciraj show za Poly, namesto 'Stringce "asdf"' kje prikaze "asdf", namesto 'Brojce 3' kje prikaze 3.
instance Show Poly where { show (Brojce x) = show x; show (Stringce x) = show x }

contains :: Poly -> BinaryTree -> Bool
contains i1 (Leaf i2) = i1 == i2
contains i1 (Node left right i2) = i1 == i2 || contains i1 left || contains i1 right

treeToList :: BinarySearchOrder -> BinaryTree -> [Poly]
treeToList _ (Leaf x) = [x]
treeToList p (Node l r x) =
  let l' = treeToList p l
      r' = treeToList p r
  in case p of
    Preorder  -> [x] ++ l'  ++ r'
    Inorder   -> l'  ++ [x] ++ r'
    Postorder -> l'  ++ r'  ++ [x]

root = Node root_levo root_desno (Brojce 1)
root_levo = Node root_levo1 root_desno1 (Brojce 2)
root_desno = Node root_levo2 root_desno2 (Brojce 5)
root_levo1 = Leaf (Brojce 3)
root_desno1 = Leaf (Stringce "cetvorce")
root_levo2 = Leaf (Brojce 6)
root_desno2 = Leaf (Brojce 7)