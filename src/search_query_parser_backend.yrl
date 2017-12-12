Nonterminals exp.

Terminals
  '|' '&' ' ' '!' '(' ')' term.

Rootsymbol exp.

Left     5  '|'.
Left     10 '&'.
Left     15 ' '.
Nonassoc 20 '!'.

exp -> exp '&' exp : {'&', '$1', '$3'}.
exp -> exp '|' exp : {'|', '$1', '$3'}.
exp -> exp ' ' exp : {' ', '$1', '$3'}.
exp -> '(' exp ')' : '$2'.
exp -> '!' exp     : {'!', '$2'}.
exp -> term        : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
