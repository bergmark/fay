module Fay.Compiler.Records where

import Control.Applicative
import Data.Maybe
import Language.Haskell.Exts
import Data.Map (Map)
import qualified Data.Map as M
import Data.Set (Set)
import qualified Data.Set as S
import Data.Default

newtype RTMap = RTMap (Map QName [QName])
  deriving (Show)
instance Default RTMap where
  def = RTMap (M.empty)

newtype RMap = RMap (Map QName [QName])
  deriving (Show)
instance Default RMap where
  def = RMap (M.empty)

recordFields :: Name -> RMap -> Maybe [QName]
recordFields name (RMap m) = M.lookup (UnQual name) $ m

typeToRecs' :: Name -> RTMap -> [QName]
typeToRecs' name (RTMap m) = fromMaybe [] . M.lookup (UnQual name) $ m

typeToFields' :: Name -> RTMap -> RMap -> [QName]
typeToFields' typ types records = do
  let (RMap allrecs) = records
      typerecs = typeToRecs' typ types in
    concatMap snd . filter ((`elem` typerecs) . fst) $ M.toList allrecs

addRecordType :: Name -> [Name] -> RTMap -> RTMap
addRecordType n ns (RTMap m) = RTMap $ M.insert (UnQual n) (map UnQual ns) m

addRecord :: Name -> [Name] -> RMap -> RMap
addRecord n ns (RMap m) = RMap $ M.insert (UnQual n) (map UnQual ns) m


recordTypesTest :: RTMap -> Map QName [QName]
recordTypesTest (RTMap m) = m

recordTest :: RMap -> Map QName [QName]
recordTest (RMap m) = m
