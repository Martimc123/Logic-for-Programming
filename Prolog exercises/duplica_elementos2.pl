duplica_elementos_rec([],[]).

duplica_elementos_rec([P|R],[P,P|L2]) :- duplica_elementos_rec(R,L2).

duplica_elementos_ite(L1,L2) :- duplica_elementos_ite(L1,L2,[]).

duplica_elementos_ite([],L2,L2).

duplica_elementos_ite([P|R],L2,AC) :- append(AC,[P,P],NAC),
                                      duplica_elementos_ite(R,L2,NAC).

