

-- UUAGC 0.9.38.6 (NTree.ag)
module NTree where
-- NRoot -------------------------------------------------------
data NRoot  = NRoot (NTree ) 
            deriving ( Show)
-- NTree -------------------------------------------------------
data NTree  = NTree (Node ) (NTrees ) 
            deriving ( Show)
-- NTrees ------------------------------------------------------
type NTrees  = [NTree ]
-- Node --------------------------------------------------------
data Node  = NTag (String) (([(String, String)])) 
           | NText (String) 
           deriving ( Show)