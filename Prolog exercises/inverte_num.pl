inverte(N, Inv) :- inverte(N, Inv,0).

inverte(0,Inv,Inv) :- !.

inverte(N,Inv,AC) :- Digito is N mod 10,
                     Novo_N is N // 10,
                     Ac_num is AC * 10 + Digito,
                     inverte(Novo_N,Inv,Ac_num),!.
