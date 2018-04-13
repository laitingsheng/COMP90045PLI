module PazParser where

import Debug.Trace (trace)
import Text.Parsec (
    Parsec,
    SourcePos,
    choice,
    eof,
    optionMaybe,
    optional,
    parse,
    tokenPrim,
    try
    )
import Data.Char
import Data.Map (Map)
import qualified Data.Map as Map
import Control.Monad (void)
import Control.Applicative (many) -- get <|> from here too if needed
import PazLexer (
    ASTLexicalToken,
    LexicalToken(..),
    ASTCharacterString,
    ASTIdentifier,
    ASTUnsignedInteger,
    ASTUnsignedReal
    )

-- define a parser which parses an incoming stream of ASTLexicalToken,
-- noting that ASTLexicalToken is a pair of SourcePos and LexicalToken
type Parser = Parsec [ASTLexicalToken] ()

-- since we are not processing characters we must define "satisfy" ourself,
-- tokenPrim takes a show function, an update function, and test function
satisfy ::
     -- the following type constraint is some kind of Haskell gobbledygook,
     -- to make it work we'd have to turn on the FlexibleContents feature:
     --(Stream s m ASTLexicalToken) =>
     (LexicalToken -> Bool) -> Parser LexicalToken
satisfy f =
     tokenPrim
         (\(_, x) -> show x)
         updatePosASTLexicalToken
         (\(_, x) -> if f x then Just x else Nothing)

-- updating the source position is simply extracing it from the coming
-- ASTLexicalToken in the input stream, if there is no next parseToken then
-- use current (i.e. last) parseToken, I am sure there would be a better way
updatePosASTLexicalToken ::
    SourcePos -> ASTLexicalToken -> [ASTLexicalToken] -> SourcePos
updatePosASTLexicalToken _ _ ((pos, _) : _) = pos
updatePosASTLexicalToken _ (pos, _) [] = pos

parseTokenEof :: Parser ()
parseTokenEof = eof

-- lexical tokens section
-- these are basically wrappers that check for each kind of lexical parseToken
-- already recognized by PazLexer.hs and then regurgitate it, those
-- starting with "parseToken" throw away the ASTLexicalToken, those starting
-- with "parse" unwrap the ASTLexicalToken and then the LexicalToken

parseTokenLeftParenthesis :: Parser ()
parseTokenLeftParenthesis =
    void (
        satisfy (
            \x ->
                case x of
                    LTLeftParenthesis -> True
                    otherwise -> False
            )
        )

parseTokenRightParenthesis :: Parser ()
parseTokenRightParenthesis =
    void (
        satisfy (
            \x ->
                case x of
                    LTRightParenthesis -> True
                    otherwise -> False
            )
        )

parseTokenTimes :: Parser ()
parseTokenTimes =
    void (
        satisfy (
            \x ->
                case x of
                    LTTimes -> True
                    otherwise -> False
            )
        )

parseTokenPlus :: Parser ()
parseTokenPlus =
    void (
        satisfy (
            \x ->
                case x of
                    LTPlus -> True
                    otherwise -> False
            )
        )

parseTokenComma :: Parser ()
parseTokenComma =
    void (
        satisfy (
            \x ->
                case x of
                    LTComma -> True
                    otherwise -> False
            )
        )

parseTokenMinus :: Parser ()
parseTokenMinus =
    void (
        satisfy (
            \x ->
                case x of
                    LTMinus -> True
                    otherwise -> False
            )
        )

parseTokenEllipsis :: Parser ()
parseTokenEllipsis =
    void (
        satisfy (
            \x ->
                case x of
                    LTEllipsis -> True
                    otherwise -> False
            )
        )

parseTokenDot :: Parser ()
parseTokenDot =
    void (
        satisfy (
            \x ->
                case x of
                    LTDot -> True
                    otherwise -> False
            )
        )

parseTokenDivideBy :: Parser ()
parseTokenDivideBy =
    void (
        satisfy (
            \x ->
                case x of
                    LTDivideBy -> True
                    otherwise -> False
            )
        )

parseTokenAssign :: Parser ()
parseTokenAssign =
    void (
        satisfy (
            \x ->
                case x of
                    LTAssign -> True
                    otherwise -> False
            )
        )

parseTokenColon :: Parser ()
parseTokenColon =
    void (
        satisfy (
            \x ->
                case x of
                    LTColon -> True
                    otherwise -> False
            )
        )

parseTokenSemicolon :: Parser ()
parseTokenSemicolon =
    void (
        satisfy (
            \x ->
                case x of
                    LTSemicolon -> True
                    otherwise -> False
            )
        )

parseTokenLessThanOrEqual :: Parser ()
parseTokenLessThanOrEqual =
    void (
        satisfy (
            \x ->
                case x of
                    LTLessThanOrEqual -> True
                    otherwise -> False
            )
        )

parseTokenNotEqual :: Parser ()
parseTokenNotEqual =
    void (
        satisfy (
            \x ->
                case x of
                    LTNotEqual -> True
                    otherwise -> False
            )
        )

parseTokenLessThan :: Parser ()
parseTokenLessThan =
    void (
        satisfy (
            \x ->
                case x of
                    LTLessThan -> True
                    otherwise -> False
            )
        )

parseTokenEqual :: Parser ()
parseTokenEqual =
    void (
        satisfy (
            \x ->
                case x of
                    LTEqual -> True
                    otherwise -> False
            )
        )

parseTokenGreaterThanOrEqual :: Parser ()
parseTokenGreaterThanOrEqual =
    void (
        satisfy (
            \x ->
                case x of
                    LTGreaterThanOrEqual -> True
                    otherwise -> False
            )
        )

parseTokenGreaterThan :: Parser ()
parseTokenGreaterThan =
    void (
        satisfy (
            \x ->
                case x of
                    LTGreaterThan -> True
                    otherwise -> False
            )
        )

parseTokenLeftBracket :: Parser ()
parseTokenLeftBracket =
    void (
        satisfy (
            \x ->
                case x of
                    LTLeftBracket -> True
                    otherwise -> False
            )
        )

parseTokenRightBracket :: Parser ()
parseTokenRightBracket =
    void (
        satisfy (
            \x ->
                case x of
                    LTRightBracket -> True
                    otherwise -> False
            )
        )

parseTokenAnd :: Parser ()
parseTokenAnd =
    void (
        satisfy (
            \x ->
                case x of
                    LTAnd -> True
                    otherwise -> False
            )
        )

parseTokenArray :: Parser ()
parseTokenArray =
    void (
        satisfy (
            \x ->
                case x of
                    LTArray -> True
                    otherwise -> False
            )
        )

parseTokenBegin :: Parser ()
parseTokenBegin =
    void (
        satisfy (
            \x ->
                case x of
                    LTBegin -> True
                    otherwise -> False
            )
        )

parseTokenBoolean :: Parser ()
parseTokenBoolean =
    void (
        satisfy (
            \x ->
                case x of
                    LTBoolean -> True
                    otherwise -> False
            )
        )

parseTokenDiv :: Parser ()
parseTokenDiv =
    void (
        satisfy (
            \x ->
                case x of
                    LTDiv -> True
                    otherwise -> False
            )
        )

parseTokenDo :: Parser ()
parseTokenDo =
    void (
        satisfy (
            \x ->
                case x of
                    LTDo -> True
                    otherwise -> False
            )
        )

parseTokenDownTo :: Parser ()
parseTokenDownTo =
    void (
        satisfy (
            \x ->
                case x of
                    LTDownTo -> True
                    otherwise -> False
            )
        )

parseTokenElse :: Parser ()
parseTokenElse =
    void (
        satisfy (
            \x ->
                case x of
                    LTElse -> True
                    otherwise -> False
            )
        )

parseTokenEnd :: Parser ()
parseTokenEnd =
    void (
        satisfy (
            \x ->
                case x of
                    LTEnd -> True
                    otherwise -> False
            )
        )

parseTokenFor :: Parser ()
parseTokenFor =
    void (
        satisfy (
            \x ->
                case x of
                    LTFor -> True
                    otherwise -> False
            )
        )

parseTokenFunction :: Parser ()
parseTokenFunction =
    void (
        satisfy (
            \x ->
                case x of
                    LTFunction -> True
                    otherwise -> False
            )
        )

parseTokenIf :: Parser ()
parseTokenIf =
    void (
        satisfy (
            \x ->
                case x of
                    LTIf -> True
                    otherwise -> False
            )
        )

parseTokenInteger :: Parser ()
parseTokenInteger =
    void (
        satisfy (
            \x ->
                case x of
                    LTInteger -> True
                    otherwise -> False
            )
        )

parseTokenNot :: Parser ()
parseTokenNot =
    void (
        satisfy (
            \x ->
                case x of
                    LTNot -> True
                    otherwise -> False
            )
        )

parseTokenOf :: Parser ()
parseTokenOf =
    void (
        satisfy (
            \x ->
                case x of
                    LTOf -> True
                    otherwise -> False
            )
        )

parseTokenOr :: Parser ()
parseTokenOr =
    void (
        satisfy (
            \x ->
                case x of
                    LTOr -> True
                    otherwise -> False
            )
        )

parseTokenProcedure :: Parser ()
parseTokenProcedure =
    void (
        satisfy (
            \x ->
                case x of
                    LTProcedure -> True
                    otherwise -> False
            )
        )

parseTokenProgram :: Parser ()
parseTokenProgram =
    void (
        satisfy (
            \x ->
                case x of
                    LTProgram -> True
                    otherwise -> False
            )
        )

parseTokenReal :: Parser ()
parseTokenReal =
    void (
        satisfy (
            \x ->
                case x of
                    LTReal -> True
                    otherwise -> False
            )
        )

parseTokenThen :: Parser ()
parseTokenThen =
    void (
        satisfy (
            \x ->
                case x of
                    LTThen -> True
                    otherwise -> False
            )
        )

parseTokenTo :: Parser ()
parseTokenTo =
    void (
        satisfy (
            \x ->
                case x of
                    LTTo -> True
                    otherwise -> False
            )
        )

parseTokenVar :: Parser ()
parseTokenVar =
    void (
        satisfy (
            \x ->
                case x of
                    LTVar -> True
                    otherwise -> False
            )
        )

parseTokenWhile :: Parser ()
parseTokenWhile =
    void (
        satisfy (
            \x ->
                case x of
                    LTWhile -> True
                    otherwise -> False
            )
        )

parseCharacterString :: Parser ASTCharacterString
parseCharacterString =
    do
        (LTCharacterString x) <-
            satisfy (
                \x ->
                    case x of
                        LTCharacterString _ -> True
                        otherwise -> False
                )
        return x

parseIdentifier :: Parser ASTIdentifier
parseIdentifier =
    do
        (LTIdentifier x) <-
            satisfy (
                \x ->
                    case x of
                        LTIdentifier _ -> True
                        otherwise -> False
                )
        return x

parseUnsignedInteger :: Parser ASTUnsignedInteger
parseUnsignedInteger =
    do
        (LTUnsignedInteger x) <-
            satisfy (
                \x ->
                    case x of
                        LTUnsignedInteger _ -> True
                        otherwise -> False
                )
        return x

parseUnsignedReal :: Parser ASTUnsignedReal
parseUnsignedReal =
    do
        (LTUnsignedReal x) <-
            satisfy (
                \x ->
                    case x of
                        LTUnsignedReal _ -> True
                        otherwise -> False
                )
        return x

-- end of lexical tokens section

type ASTStartSymbol = ASTProgram
parseStartSymbol :: Parser ASTStartSymbol
parseStartSymbol =
    trace
        "parseStartSymbol"
        (
            do
                x0 <-
                    parseProgram
                parseTokenEof
                return x0
            )

type ASTProgram = (ASTIdentifier, ASTVariableDeclarationPart, ASTProcedureDeclarationPart, ASTCompoundStatement)
parseProgram :: Parser ASTProgram
parseProgram =
    trace
        "parseProgram"
        (
            do
                parseTokenProgram
                x0 <-
                    parseIdentifier
                parseTokenSemicolon
                x1 <-
                    parseVariableDeclarationPart
                x2 <-
                    parseProcedureDeclarationPart
                x3 <-
                    parseCompoundStatement
                parseTokenDot
                return (x0, x1, x2, x3)
            )

type ASTProcedureDeclarationPart = [ASTProcedureDeclaration]
parseProcedureDeclarationPart :: Parser ASTProcedureDeclarationPart
parseProcedureDeclarationPart =
    trace
        "parseProcedureDeclarationPart"
        (
            many (
                try (
                    do
                        x0 <-
                            parseProcedureDeclaration
                        parseTokenSemicolon
                        return x0
                    )
                )
            )

-- your code starts here

type ASTStatement = Statement
data Statement =
    AssignmentStatement ASTAssignmentStatement |
    ProcedureStatement ASTProcedureStatement |
    CompoundStatement ASTCompoundStatement |
    IfStatement ASTIfStatement |
    WhileStatement ASTWhileStatement |
    ForStatement ASTForStatement |
    EmptyStatement
    deriving Show
parseStatement :: Parser ASTStatement
parseStatement =
    trace "parseStatement" (choice [
        try (
            do
                x <- parseAssignmentStatement
                return (AssignmentStatement x)
            ),
        try (
            do
                x <- parseProcedureStatement
                return (ProcedureStatement x)
            ),
        try (
            do
                x <- parseCompoundStatement
                return (CompoundStatement x)
            ),
        try (
            do
                x <- parseIfStatement
                return (IfStatement x)
            ),
        try (
            do
                x <- parseWhileStatement
                return (WhileStatement x)
            ),
        try (
            do
                x <- parseForStatement
                return (ForStatement x)
            ),
        return EmptyStatement
        ])

type ASTAssignmentStatement = (ASTVariableAccess, ASTExpression)
parseAssignmentStatement :: Parser ASTAssignmentStatement
parseAssignmentStatement =
    trace "parseAssignmentStatement" (
        do
            x0 <- parseVariableAccess
            parseTokenAssign
            x1 <- parseExpression
            return (x0, x1)
        )

type ASTProcedureStatement = (ASTIdentifier, Maybe ASTActualParameterList)
parseProcedureStatement :: Parser ASTProcedureStatement
parseProcedureStatement =
    trace "parseProcedureStatement" (
        do
            x0 <- parseIdentifier
            x1 <- optionMaybe (try parseActualParameterList)
            return (x0, x1)
        )

type ASTActualParameterList = (ASTExpression, [ASTExpression])
parseActualParameterList :: Parser ASTActualParameterList
parseActualParameterList =
    trace "parseActualParameterList" (
        do
            parseTokenLeftParenthesis
            x0 <- parseExpression
            x1 <- many (try (
                do parseTokenComma
                   parseExpression
                ))
            parseTokenRightParenthesis
            return (x0, x1)
        )

type ASTCompoundStatement = ASTStatementSequence
parseCompoundStatement :: Parser ASTCompoundStatement
parseCompoundStatement =
    trace "parseCompoundStatement" (
        do
            parseTokenBegin
            x0 <- parseStatementSequence
            parseTokenEnd
            return x0
        )

type ASTStatementSequence = (ASTStatement, [ASTStatement])
parseStatementSequence :: Parser ASTStatementSequence
parseStatementSequence =
    trace "parseStatementSequence" (
        do
            x0 <- parseStatement
            x1 <- many ( try (
                do parseTokenSemicolon
                   parseStatement
                ))
            return (x0, x1)
        )

type ASTIfStatement = (ASTExpression, ASTStatement, Maybe ASTStatement)
parseIfStatement :: Parser ASTIfStatement
parseIfStatement =
    trace "parseIfStatement" (
        do
            parseTokenIf
            x0 <- parseExpression
            parseTokenThen
            x1 <- parseStatement
            x2 <- optionMaybe (try (
                do parseTokenElse
                   parseStatement
                ))
            return (x0, x1, x2)
        )

type ASTWhileStatement = (ASTExpression, ASTStatement)
parseWhileStatement :: Parser ASTWhileStatement
parseWhileStatement =
    trace "parseWhileStatement" (
        do
            parseTokenWhile
            x0 <- parseExpression
            parseTokenDo
            x1 <- parseStatement
            return (x0, x1)
        )

type ASTForStatement = (ASTIdentifier, ASTExpression, ASTExpression, ASTStatement)
parseForStatement :: Parser ASTForStatement
parseForStatement =
    trace "parseForStatement" (
        do
            parseTokenFor
            x0 <- parseIdentifier
            parseTokenAssign
            x1 <- parseExpression
            choice [
                try parseTokenTo,
                parseTokenDownTo
                ]
            x2 <- parseExpression
            parseTokenDo
            x3 <- parseStatement
            return (x0, x1, x2, x3)
        )

type ASTExpression = (ASTSimpleExpression, Maybe ASTSimpleExpression)
parseExpression :: Parser ASTExpression
parseExpression =
    trace "parseExpression" (
        do
            x0 <- parseSimpleExpression
            x1 <- optionMaybe (try (
                do parseRelationalOperator
                   parseSimpleExpression
                ))
            return (x0, x1)
        )

type ASTRelationalOperator = ()
parseRelationalOperator :: Parser ASTRelationalOperator
parseRelationalOperator =
    trace "parseRelationalOperator" (choice [
        try parseTokenEqual,
        try parseTokenNotEqual,
        try parseTokenLessThan,
        try parseTokenGreaterThan,
        try parseTokenLessThanOrEqual,
        parseTokenGreaterThanOrEqual
        ])

type ASTSimpleExpression = (Maybe ASTSign, ASTTerm, [(ASTAddingOperator, ASTTerm)])
parseSimpleExpression :: Parser ASTSimpleExpression
parseSimpleExpression =
    trace "parseSimpleExpression" (
        do
            x0 <- optionMaybe (try (
                try parseSign
                ))
            x1 <- parseTerm
            x2 <- many (try (
                do
                    x0 <- parseAddingOperator
                    x1 <- parseTerm
                    return (x0, x1)
                ))
            return (x0, x1, x2)
        )

type ASTAddingOperator = ()
parseAddingOperator :: Parser ASTAddingOperator
parseAddingOperator =
    trace "parseAddingOperator" (choice [
        try parseTokenPlus,
        try parseTokenMinus,
        parseTokenOr
        ])

type ASTTerm = (ASTFactor, [(ASTMultiplyingOperator, ASTFactor)])
parseTerm :: Parser ASTTerm
parseTerm =
    trace "parseTerm" (
        do
            x0 <- parseFactor
            x1 <- many (try (
                do
                    x0 <- parseMultiplyingOperator
                    x1 <- parseFactor
                    return (x0, x1)
                ))
            return (x0, x1)
        )

type ASTMultiplyingOperator = ()
parseMultiplyingOperator :: Parser ASTMultiplyingOperator
parseMultiplyingOperator =
    trace "parseMultiplyingOperator" (choice [
        try parseTokenTimes,
        try parseTokenDivideBy,
        try parseTokenDiv,
        parseTokenAnd
        ])

type ASTFactor = Factor
data Factor =
    UnsignedConstant ASTUnsignedConstant |
    VariableAccess ASTVariableAccess |
    Expression ASTExpression |
    Factor Factor
    deriving Show
parseFactor :: Parser ASTFactor
parseFactor =
    trace "parseFactor" (choice [
        try (
            do
                x <- parseUnsignedConstant
                return (UnsignedConstant x)
            ),
        try (
            do
                x <- parseVariableAccess
                return (VariableAccess x)
            ),
        try (
            do
                parseTokenLeftParenthesis
                x0 <- parseExpression
                parseTokenRightParenthesis
                return (Expression x0)
            ),
        do
            parseTokenNot
            x <- parseFactor
            return (Factor x)
        ])

type ASTUnsignedConstant = UnsignedConstant
data UnsignedConstant =
    UnsignedNumber ASTUnsignedNumber |
    CharacterString ASTCharacterString
    deriving Show
parseUnsignedConstant :: Parser ASTUnsignedConstant
parseUnsignedConstant =
    trace "parseUnsignedConstant" (choice [
        try (
            do
                x <- parseUnsignedNumber
                return (UnsignedNumber x)
            ),
        do
            x <- parseCharacterString
            return (CharacterString x)
        ])

type ASTUnsignedNumber = UnsignedNumber
data UnsignedNumber =
    UnsignedInteger ASTUnsignedInteger |
    UnsignedReal ASTUnsignedReal
    deriving Show
parseUnsignedNumber :: Parser ASTUnsignedNumber
parseUnsignedNumber =
    trace "parseUnsignedNumber" (choice [
        try (
            do
                x <- parseUnsignedInteger
                return (UnsignedInteger x)
            ),
        do
            x <- parseUnsignedReal
            return (UnsignedReal x)
        ])

type ASTVariableAccess = VariableAccess
data VariableAccess =
    IndexedVariableAccess ASTIndexedVariable |
    OrdinaryVariableAccess ASTIdentifier
    deriving Show
parseVariableAccess :: Parser ASTVariableAccess
parseVariableAccess =
    trace "parseVariableAccess" (choice [
        try (
            do
                x <- parseIndexedVariable
                return (IndexedVariableAccess x)
            ),
        do
            x <- parseIdentifier
            return (OrdinaryVariableAccess x)
        ])

type ASTIndexedVariable = (ASTIdentifier, ASTExpression)
parseIndexedVariable :: Parser ASTIndexedVariable
parseIndexedVariable = trace "parseIndexedVariable" (
    do
        x0 <- parseIdentifier
        parseTokenLeftBracket
        x1 <- parseExpression
        parseTokenRightBracket
        return (x0, x1)
    )

-- your code ends here

type ASTProcedureDeclaration = (ASTIdentifier, (Maybe ASTFormalParameterList), ASTVariableDeclarationPart, ASTCompoundStatement)
parseProcedureDeclaration :: Parser ASTProcedureDeclaration
parseProcedureDeclaration =
    trace
        "parseProcedureDeclaration"
        (
            do
                parseTokenProcedure
                x0 <-
                    parseIdentifier
                x1 <-
                    optionMaybe (
                        try (
                            parseFormalParameterList
                            )
                        )
                parseTokenSemicolon
                x2 <-
                    parseVariableDeclarationPart
                x3 <-
                    parseCompoundStatement
                return (x0, x1, x2, x3)
            )

type ASTFormalParameterList = (ASTFormalParameterSection, [ASTFormalParameterSection])
parseFormalParameterList :: Parser ASTFormalParameterList
parseFormalParameterList =
    trace
        "parseFormalParameterList"
        (
            do
                parseTokenLeftParenthesis
                x0 <-
                    parseFormalParameterSection
                x1 <-
                    many (
                        try (
                            do
                                parseTokenSemicolon
                                x0 <-
                                    parseFormalParameterSection
                                return x0
                            )
                        )
                parseTokenRightParenthesis
                return (x0, x1)
            )

-- presence of "var" keyword should have type "Maybe ()" according to the
-- usual system, but the generator cannot handle this because it is stupid,
-- so we manually put in a type of "Bool" which is "True" if "var" present
type ASTFormalParameterSection = (Bool, ASTIdentifierList, ASTTypeDenoter)
parseFormalParameterSection :: Parser ASTFormalParameterSection
parseFormalParameterSection =
    trace
        "parseFormalParameterSection"
        (
            do
                x0 <-
                    optionMaybe (
                        try (
                            parseTokenVar
                            )
                        )
                x1 <-
                    parseIdentifierList
                parseTokenColon
                x2 <-
                    parseTypeDenoter
                return (
                    case x0 of
                        Just _ -> (True, x1, x2)
                        _ -> (False, x1, x2)
                    )
            )

type ASTIdentifierList = (ASTIdentifier, [ASTIdentifier])
parseIdentifierList :: Parser ASTIdentifierList
parseIdentifierList =
    trace
        "parseIdentifierList"
        (
            do
                x0 <-
                    parseIdentifier
                x1 <-
                    many (
                        try (
                            do
                                parseTokenComma
                                x0 <-
                                    parseIdentifier
                                return x0
                            )
                        )
                return (x0, x1)
            )

type ASTVariableDeclarationPart = (Maybe (ASTVariableDeclaration, [ASTVariableDeclaration]))
parseVariableDeclarationPart :: Parser ASTVariableDeclarationPart
parseVariableDeclarationPart =
    trace
        "parseVariableDeclarationPart"
        (
            optionMaybe (
                try (
                    do
                        parseTokenVar
                        x0 <-
                            parseVariableDeclaration
                        parseTokenSemicolon
                        x1 <-
                            many (
                                try (
                                    do
                                        x0 <-
                                            parseVariableDeclaration
                                        parseTokenSemicolon
                                        return x0
                                    )
                                )
                        return (x0, x1)
                    )
                )
            )

type ASTVariableDeclaration = (ASTIdentifierList, ASTTypeDenoter)
parseVariableDeclaration :: Parser ASTVariableDeclaration
parseVariableDeclaration =
    trace
        "parseVariableDeclaration"
        (
            do
                x0 <-
                    parseIdentifierList
                parseTokenColon
                x1 <-
                    parseTypeDenoter
                return (x0, x1)
            )

type ASTTypeDenoter = TypeDenoter
data TypeDenoter =
    OrdinaryTypeDenoter ASTTypeIdentifier |
    ArrayTypeDenoter ASTArrayType
    deriving(Show)
parseTypeDenoter :: Parser ASTTypeDenoter
parseTypeDenoter =
    trace
        "parseTypeDenoter"
        (
            choice
                [
                    try (
                        do
                            x <-
                                parseTypeIdentifier
                            return (OrdinaryTypeDenoter x)
                        ),
                    do
                        x <-
                            parseArrayType
                        return (ArrayTypeDenoter x)
                    ]
            )

type ASTTypeIdentifier = TypeIdentifier
data TypeIdentifier =
    IntegerTypeIdentifier |
    RealTypeIdentifier |
    BooleanTypeIdentifier
    deriving(Show)
parseTypeIdentifier :: Parser ASTTypeIdentifier
parseTypeIdentifier =
    trace
        "parseTypeIdentifier"
        (
            choice
                [
                    try (
                        do
                            parseTokenInteger
                            return IntegerTypeIdentifier
                        ),
                    try (
                        do
                            parseTokenReal
                            return RealTypeIdentifier
                        ),
                    do
                        parseTokenBoolean
                        return BooleanTypeIdentifier
                    ]
            )

type ASTArrayType = (ASTSubrangeType, ASTTypeIdentifier)
parseArrayType :: Parser ASTArrayType
parseArrayType =
    trace
        "parseArrayType"
        (
            do
                parseTokenArray
                parseTokenLeftBracket
                x0 <-
                    parseSubrangeType
                parseTokenRightBracket
                parseTokenOf
                x1 <-
                    parseTypeIdentifier
                return (x0, x1)
            )

type ASTSubrangeType = (ASTConstant, ASTConstant)
parseSubrangeType :: Parser ASTSubrangeType
parseSubrangeType =
    trace
        "parseSubrangeType"
        (
            do
                x0 <-
                    parseConstant
                parseTokenEllipsis
                x1 <-
                    parseConstant
                return (x0, x1)
            )

type ASTConstant = ((Maybe ASTSign), ASTUnsignedInteger)
parseConstant :: Parser ASTConstant
parseConstant =
    trace
        "parseConstant"
        (
            do
                x0 <-
                    optionMaybe (
                        try (
                            parseSign
                            )
                        )
                x1 <-
                    parseUnsignedInteger
                return (x0, x1)
            )

type ASTSign = Sign
data Sign =
    SignPlus |
    SignMinus
    deriving(Show)
parseSign :: Parser ASTSign
parseSign =
    trace
        "parseSign"
        (
            choice
                [
                    try (
                        do
                            parseTokenPlus
                            return SignPlus
                        ),
                    do
                        parseTokenMinus
                        return SignMinus
                    ]
            )
