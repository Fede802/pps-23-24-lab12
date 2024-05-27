%-----------------------------------------------------------------------------------------Ex 1-----------------------------------------------------------------------------------------
%map (+L, +Mapper , -Lo)
%where Mapper = mapper (I,O, UNARY_OP )
%e.g. Mapper = mapper (X, Y, Y is X+1)
%Examples:
%map([10,20,30], mapper(X, Y, Y is X + 1), L). -> yes, L/[11,21,31]
map([], _, []) .
map([H|T], M, [H2|T2]) :-
	map(T, M, T2), copy_term(M, mapper(H, H2, OP)), call(OP).

map2(L, M, R) :- M =.. [mapper, Arg1, Arg2, Arg3], fold_right(L, _, fold_function([Arg2|Acc], Arg1, Arg2, Arg3), R).	%???

%filter(+L, +filter_function, -Lo)
%Examples:
%filter([10,20,30], filter_function(X, X > 20), L). -> yes, L/[30]
filter([], _, []).
filter([H|T], F, [H|T2]) :- filter(T, F, T2), copy_term(F, filter_function(H, OP)), call(OP),!.
filter([H|T], F, T2) :- filter(T, F, T2).

%reduce(+L, +reduce_function, -R)
%Examples:
%reduce([10,20,30], reduce_function(Acc, El, R, R is Acc + El), R). -> yes, R/60
reduce([E], _, E).
reduce([H|T], RF, R) :- reduce(T, RF, PR), copy_term(RF, reduce_function(PR, H, R, OP)), call(OP).

reduce2([H|T], RF, R) :- RF =.. [reduce_function, Arg1, Arg2, Arg3, Arg4], fold_left(T, H, fold_function(Arg1, Arg2, Arg3, Arg4), R).

%fold_left(+L, +Acc, +fold_function(), -R)
%Examples:
%fold_left([10,20,30], 0, fold_function(Acc, El, R, R is Acc + El), R). -> yes, R/60
fold_left([], Acc, _, Acc).
fold_left([H|T], Acc, FF, R) :- copy_term(FF, fold_function(Acc, H, IR, OP)), call(OP), fold_left(T, IR, FF, R).

%fold_right(+L, +Acc, +fold_function(), -R)
%Examples:
%fold_right([10,20,30], 0, fold_function(Acc, El, R, R is Acc + El), R). -> yes, R/60
fold_right([], Acc, _, Acc).
fold_right([H|T], Acc, FF, R) :- fold_right(T, Acc, FF, IR), copy_term(FF, fold_function(IR, H, R, OP)), call(OP). 
