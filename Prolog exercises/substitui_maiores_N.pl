substitui_maiores_N(N,S,L1,L2) :- substitui_maiores_N(N,S,L1,L2,[]).

substitui_maiores_N(_,_,[],Aux,Aux) :- !.

substitui_maiores_N(N,S,[P|R],L2,Aux) :- P > N,!,
                                         append(Aux,[S],Naux),
                                         substitui_maiores_N(N,S,R,L2,Naux).

substitui_maiores_N(N,S,[P|R],L2,Aux) :- P =< N,!,
                                         append(Aux,[P],Naux),
                                         substitui_maiores_N(N,S,R,L2,Naux).
