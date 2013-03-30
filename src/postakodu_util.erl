-module (postakodu_util).

-export ([join/2]).

join(List, Delimiter) ->
	join(List, Delimiter, []).

join([], _Delimiter, Result) ->
	lists:reverse(Result);
join([H | T], Delimiter, Result) when T =:= [] ->
	join(T, Delimiter, [H  | Result]);
join([H | T], Delimiter, Result) ->
	join(T, Delimiter, [Delimiter , H  | Result]).