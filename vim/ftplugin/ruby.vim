call signify#SignifyMatch("rubyOperator", "rubyLambdaOperator", "\"->\"", "→")
call signify#SignifyMatch("rubyOperator", "rubyHashRocketOperator", "\"=>\"", "⇒")
call signify#SignifyMatch("rubyOperator", "rubySpaceShipOperator", "\"<=>\"", "⇔")
call signify#SignifyMatch("rubyOperator", "rubyDifferentOperator", "\"!=\"", "≠")
call signify#SignifyMatch("rubyOperator", "rubyGreaterEqualOperator", "\">=\"", "≥")
call signify#SignifyMatch("rubyOperator", "rubyLesserEqualOperator", "\"<=\"", "≤")
call signify#SignifyMatch("rubyOperator", "rubyTimesOperator", "\"*\"", "×")
call signify#SignifyMatch("rubyOperator", "rubyOverOperator", "\"/\"", "÷")
call signify#SignifyKeyword("rubyKeyword", "rubyLambda", "lambda", "λ")
call signify#SignifyKeyword("rubyKeyword", "rubyProc", "proc", "π")

noremap <buffer> K :!zeal --query ruby:"<cword>"&<cr><cr>
