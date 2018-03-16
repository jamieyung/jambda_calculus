{
module Parser where

import Expr (Expr(..), Args(..))
import Lexer (lexer)
import Token (Token(..))
}

%name parser
%tokentype { Token }
%error { parseError }

%token 
    'λ'             { TokenLambda }
    '.'             { TokenPeriod }
    '('             { TokenLParen }
    ')'             { TokenRParen }
    T               { TokenTrue }
    F               { TokenFalse }
    op              { TokenOp $$ }
    ' '             { TokenSpace }
    var             { TokenVar $$ }
    int             { TokenInt $$ }

%right ' '
%left op

%%

Expr    : var                       { Var $1 }
        | int                       { Int $1 }
        | T                         { Bool True }
        | F                         { Bool False }
        | op Expr                   { Op $1 $2 }
        | '(' Expr ')'              { Brack $2 }
        | Expr ' ' Expr             { App $1 $3 }
        | 'λ' Args '.' Expr         { Lam $2 $4 }

Args    : var                       { ArgsOne $1 }
        | var ' ' Args              { ArgsCons $1 $3 }

{
parseError :: [Token] -> a
parseError _ = error "Parse error"
}
