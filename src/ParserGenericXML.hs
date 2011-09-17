{-# LANGUAGE FlexibleContexts, RankNTypes #-}
module ParserGenericXML where

import Text.ParserCombinators.UU
import Text.ParserCombinators.UU.BasicInstances
import Text.ParserCombinators.UU.Utils

import NTree

-- | funcion principal para el parser xml
parser :: FilePath -> String -> NTree
parser fn inp = runParser fn p inp
    where p :: Parser NTree
          p = pSpaces *> pXML <* pSpaces

-- | Parser que reconoce un tag normal/especial o texto
pXML :: Parser NTree
pXML = pText <|> pTagged <|> pSpecialTag

-- | Parser para reconocer un tag con inicio y fin
pTagged :: Parser NTree
pTagged 
    = do (tag,attrs) <- pTagInit
         elems       <- pList_ng pXML
         pTagEnd tag
         return $ buildTag elems tag attrs

-- | Parser para reconocer un tag especial (sin final)
pSpecialTag :: Parser NTree
pSpecialTag 
    = buildTag [] <$ pSymbol "<" <*> pIdentifier <*> pAttributes <* pSymbol "/" <* pSym '>'

-- | Parser para atributos de xml
pAttributes :: Parser [(String, String)]
pAttributes 
    = pListSep pSpaces pAttr
    where pAttr :: Parser (String, String)
          pAttr = (,) <$> pIdentifier <* pSymbol "=" <*> pQuotedString

-- | Parser para el tag de inicio
pTagInit :: Parser (String, [(String, String)])
pTagInit 
    = (,) <$ pSymbol "<" <*> pIdentifier <*> pAttributes <* pSym '>'

-- | Parser para el tag final
pTagEnd :: String -> Parser String
pTagEnd tag 
    = pSymbol "<" *> pSymbol "/" *> (lexeme (pToken tag)) <* pSym '>'

-- Parser para reconocer cualquier texto dentro de un tag
pText :: Parser NTree
pText = buildText <$> pList1 (pSatisfy fcmp (Insertion "a" 'a' 5))
    where fcmp c = c /= '<'

-- | Parser para reconocer un nombre de tag o atributo
pIdentifier :: Parser String
pIdentifier 
    = lexeme $ pList1 (pLetter <|> pDigit)

-- | funciones constructoras de NTres, NTag
buildTag elems tag attrs 
    = NTree (NTag tag attrs) elems

-- | funciones constructoras de NTres, NText
buildText str 
    = NTree (NText str) []

