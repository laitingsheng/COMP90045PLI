module PazPrettify (prettyPrint) where

import Control.Monad (when)
import Data.Maybe (fromJust, isJust)
import PazLexer
import PazParser

notnull :: [a] -> Bool
notnull = not . null

---------- Variable Declaration Part

printIdentifierList :: ASTIdentifierList -> IO ()
printIdentifierList (x, xs) = do
    putStr x
    -- print the rest of ids, adding ", " to separate and ": " for ending
    sequence_ (map (\x -> putStr (", " ++ x)) xs)

printTypeIdentifier :: ASTTypeIdentifier -> IO ()
printTypeIdentifier ti =
    case ti of
        IntegerTypeIdentifier ->
            putStr "integer"
        RealTypeIdentifier ->
            putStr "real"
        BooleanTypeIdentifier ->
            putStr "boolean"

printSubrangeType :: ASTSubrangeType -> IO ()
printSubrangeType (l, r) = do
    -- no space for subrange
    printConstant l
    putStr ".."
    printConstant r

printArrayType :: ASTArrayType -> IO ()
printArrayType (st, ti) = do
    putStr "array["
    printSubrangeType st
    putStr "] of "
    printTypeIdentifier ti

printTypeDenoter :: ASTTypeDenoter -> IO ()
printTypeDenoter td =
    case td of
        OrdinaryTypeDenoter ti ->
            printTypeIdentifier ti
        ArrayTypeDenoter at ->
            printArrayType at

printVariableDeclaration :: ASTVariableDeclaration -> IO ()
printVariableDeclaration (il, td) = do
    printIdentifierList il
    putStr ": "
    printTypeDenoter td

printVariableDeclarationPart :: ASTVariableDeclarationPart -> IO ()
printVariableDeclarationPart (Just vdp) = do
    putStrLn "var"
    let (hvd, tvds) = vdp
    printvd hvd
    sequence_ (map printvd tvds)
    where
        spaces = replicate 4 ' '
        -- print the indentation and end by ";"
        printvd vd = do
            putStr spaces
            printVariableDeclaration vd
            putStrLn ";"
printVariableDeclarationPart Nothing =
    return ()

----------

---------- Procedure Declaration Part

printFormalParameterSection :: ASTFormalParameterSection -> IO ()
printFormalParameterSection (b, il, td) = do
    when b (putStr "var ")
    printVariableDeclaration (il, td)

printFormalParameterList :: ASTFormalParameterList -> IO ()
printFormalParameterList (hfps, tfpss) = do
    putChar '('
    printFormalParameterSection hfps
    -- parameters separated by "; "
    sequence_ (map (\fps -> do
        putStr "; "
        printFormalParameterSection fps
        ) tfpss)
    putChar ')'

printProcedureDeclaration :: ASTProcedureDeclaration -> IO ()
printProcedureDeclaration (pid, mfpl, vdp, cs) = do
    putStr ("procedure " ++ pid)
    -- can have zero parameters
    case mfpl of
        Just fpl ->
            printFormalParameterList fpl
        Nothing ->
            return ()
    putStrLn ";"
    printVariableDeclarationPart vdp
    -- the compound statement needs to align with the procedure
    printCompoundStatement 0 cs

printProcedureDeclarationPart :: ASTProcedureDeclarationPart -> IO ()
printProcedureDeclarationPart pdp = do
    sequence_ (map (\pd -> do
        -- one blank line between two procedures
        putChar '\n'
        printProcedureDeclaration pd
        putStr ";\n"
        ) pdp)

----------

---------- Compound Statement

----- Expression

-- duplicate functions for different ASTSign from lexer and parser

printLexerSign :: PazLexer.ASTSign -> IO ()
printLexerSign s =
    case s of
        PazLexer.SignPlus ->
            putChar '+'
        PazLexer.SignMinus ->
            putChar '-'

printParserSign :: PazParser.ASTSign -> IO ()
printParserSign s =
    case s of
        PazParser.SignPlus ->
            putChar '+'
        PazParser.SignMinus ->
            putChar '-'

--

printConstant :: ASTConstant -> IO ()
printConstant (ms, ui) = do
    when (isJust ms) (printParserSign (fromJust ms))
    putStr ui

printAddingOperator :: ASTAddingOperator -> IO ()
printAddingOperator ao =
    case ao of
        OperatorAdd ->
            putChar '+'
        OperatorMinus ->
            putChar '-'
        OperatorOr ->
            putStr "or"

printMultiplyingOperator :: ASTMultiplyingOperator -> IO ()
printMultiplyingOperator mo =
    case mo of
        OperatorTimes ->
            putChar '*'
        OperatorDivideBy ->
            putChar '/'
        OperatorDiv ->
            putStr "div"
        OperatorAnd ->
            putStr "and"

printScaleFactor :: ASTScaleFactor -> IO ()
printScaleFactor (ms, ds) = do
    when (isJust ms) (printLexerSign (fromJust ms))
    putStr ds

printUnsignedReal :: ASTUnsignedReal -> IO ()
printUnsignedReal (ds, mds, msf) = do
    putStr (ds)
    when (isJust mds) (putStr ("." ++ (fromJust mds)))
    when (isJust msf) (do
        putChar 'e'
        printScaleFactor (fromJust msf)
        )

printUnsignedNumber :: ASTUnsignedNumber -> IO ()
printUnsignedNumber un =
    case un of
        UnsignedInteger ui ->
            putStr ui
        UnsignedReal ur ->
            printUnsignedReal ur

printCharacterString :: ASTCharacterString -> IO ()
printCharacterString cs = do
    putChar q
    putStr cs
    putChar q
    where
        -- determine if single quotation mark is in the string
        q = if any (== '\'') cs then '"' else '\''

printUnsignedConstant :: ASTUnsignedConstant -> IO ()
printUnsignedConstant uc =
    case uc of
        UnsignedNumber un ->
            printUnsignedNumber un
        CharacterString cs ->
            printCharacterString cs

printRelationalOperator :: ASTRelationalOperator -> IO ()
printRelationalOperator ro =
    case ro of
        OperatorEqual ->
            putChar '='
        OperatorNotEqual ->
            putStr "<>"
        OperatorLessThan ->
            putChar '<'
        OperatorGreaterThan ->
            putChar '>'
        OperatorLessThanOrEqual ->
            putStr "<="
        OperatorGreaterThanOrEqual ->
            putStr ">="

printIndexedVariableAccess :: ASTIndexedVariable -> IO ()
printIndexedVariableAccess (vid, e) = do
    putStr vid
    putChar '['
    -- no need to add paranthesis
    printExpression False e
    putChar ']'

printVariableAccess :: ASTVariableAccess -> IO ()
printVariableAccess va =
    case va of
        IndexedVariableAccess iv ->
            printIndexedVariableAccess iv
        OrdinaryVariableAccess vid ->
            putStr vid

printFactor :: Bool -> ASTFactor -> IO ()
printFactor para f =
    case f of
        -- no need to add paranthesis
        UnsignedConstant uc ->
            printUnsignedConstant uc
        VariableAccess va ->
            printVariableAccess va

        -- this means a "not" is parsed previously
        Factor f -> do
            putStr "not "
            -- force paranthesis if it is expression
            printFactor True f

        -- need of paranthesis determined by the parameter
        Expression e -> do
            printExpression para e

-- for (*, /, div, or) operators
printTerm :: Bool -> ASTTerm -> IO ()
printTerm para (f, mofs) = do
    when para (putChar '(')
    printFactor ipara f
    sequence_ (map printmof mofs)
    when para (putChar ')')
    where
        -- if in a form of expression * expression, force paranthesis
        ipara = notnull mofs
        printmof (mo, f) = do
            putChar ' '
            printMultiplyingOperator mo
            putChar ' '
            printFactor ipara f

-- for (+, -, or) operators
printSimpleExpression :: Bool -> ASTSimpleExpression -> IO ()
printSimpleExpression para (ms, t, aots) = do
    when para (putChar '(')
    when (isJust ms) (printParserSign (fromJust ms))
    printTerm False t
    sequence_ (map printaot aots)
    when para (putChar ')')
    where
        printaot (ao, t) = do
            putChar ' '
            printAddingOperator ao
            putChar ' '
            printTerm False t

-- for relational operator
printExpression :: Bool -> ASTExpression -> IO ()
printExpression para (se, mrose) = do
    -- lowest operator precedence, all other types have no paranthesis
    when para (putChar '(')
    printSimpleExpression False se
    when (isJust mrose) (do
        let (ro, se) = fromJust mrose
        putChar ' '
        printRelationalOperator ro
        putChar ' '
        printSimpleExpression False se
        )
    when para (putChar ')')

-----

----- Statement

printAssignmentStatement :: Int -> ASTAssignmentStatement -> IO ()
printAssignmentStatement ind (va, e) = do
    putStr (replicate ind ' ')
    printVariableAccess va
    putStr " := "
    printExpression False e

printActualParameterList :: ASTActualParameterList -> IO ()
printActualParameterList (e, es) = do
    putChar '('
    printExpression False e
    sequence_ (map (\e -> do
        putStr ", "
        printExpression False e
        ) es)
    putChar ')'

printProcedureStatement :: Int -> ASTProcedureStatement -> IO ()
printProcedureStatement ind (pid, mapl) = do
    putStr (replicate ind ' ' ++ pid)
    when (isJust mapl) (printActualParameterList (fromJust mapl))

printIfStatement :: Int -> ASTIfStatement -> IO ()
printIfStatement ind (e, s, ms) = do
    let spaces = replicate ind ' '
    putStr spaces
    putStr "if "
    printExpression False e
    putStrLn " then"
    printStatement (ind + 4) s
    when (isJust ms) (do
        putChar '\n'
        putStr spaces
        putStrLn "else"
        printStatement (ind + 4) (fromJust ms)
        )

printWhileStatement :: Int -> ASTWhileStatement -> IO ()
printWhileStatement ind (e, s) = do
    putStr (replicate ind ' ' ++ "while ")
    printExpression False e
    putStrLn " do"
    printStatement (ind + 4) s

printForRangeOperator :: ASTForRangeOperator -> IO ()
printForRangeOperator fro =
    case fro of
        To ->
            putStr "to"
        DownTo ->
            putStr "downto"

printForStatement :: Int -> ASTForStatement -> IO ()
printForStatement ind (fid, e1, fro, e2, s) = do
    putStr (replicate ind ' ' ++ "for " ++ fid ++ " := ")
    printExpression False e1
    putChar ' '
    printForRangeOperator fro
    putChar ' '
    printExpression False e2
    putStr " do\n"
    printStatement (ind + 4) s

printStatement :: Int -> ASTStatement -> IO ()
printStatement ind s =
    case s of
        AssignmentStatement as ->
            printAssignmentStatement ind as
        ProcedureStatement ps ->
            printProcedureStatement ind ps
        CompoundStatement cs ->
            -- begin should indent with previous
            printCompoundStatement (ind - 4) cs
        IfStatement is ->
            printIfStatement ind is
        WhileStatement ws ->
            printWhileStatement ind ws
        ForStatement fs ->
            printForStatement ind fs
        EmptyStatement ->
            return ()

printStatementSequence :: Int -> ASTStatementSequence -> IO ()
printStatementSequence ind (s, ss) = do
    printStatement ind s
    sequence_ (map (\s -> do
        putStr ";\n"
        printStatement ind s
        ) ss)

printCompoundStatement :: Int -> ASTCompoundStatement -> IO ()
printCompoundStatement ind cs = do
    putStr spaces
    putStrLn "begin"
    printStatementSequence (ind + 4) cs
    putChar '\n'
    putStr spaces
    putStr "end"
    where
        spaces = replicate ind ' '

-----

---------

--------- main prettify function

prettyPrint :: ASTProgram -> IO ()
prettyPrint (pid, vdp, pdp, cs) = do
    -- program declaration
    putStrLn ("program " ++ pid ++ ";")

    -- variable declarations, global
    printVariableDeclarationPart vdp

    -- procedure declarations
    printProcedureDeclarationPart pdp

    -- compound statement
    putChar '\n'
    printCompoundStatement 0 cs
    putStrLn ".\n"

---------
