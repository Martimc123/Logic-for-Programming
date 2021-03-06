npalavra_possivel_esp(P, Esp, Esps, Ltrs) :- \+ palavra_possivel_esp(P, Esp, Esps, Ltrs).

palavras_possiveis_esp(Ltrs,Esps,Esp,Pals) :-
    palavras_possiveis_esp(Ltrs,Esps,Esp,Pals,Ltrs,[]).

palavras_possiveis_esp(_,_,_,AC,[],AC) :- !.


palavras_possiveis_esp(Ltrs,Esps,Esp,Pals,[P|R],AC) :-
    palavra_possivel_esp(P, Esp, Esps, Ltrs),
    append(AC,[P],NAC),
    palavras_possiveis_esp(Ltrs,Esps,Esp,Pals,R,NAC).

palavras_possiveis_esp(Ltrs,Esps,Esp,Pals,[P|R],AC) :-
    npalavra_possivel_esp(P, Esp, Esps, Ltrs),
    palavras_possiveis_esp(Ltrs,Esps,Esp,Pals,R,AC).

palavras_possiveis_esp2(Letras, Espacos, Esp, Pals_Possiveis) :-
findall(Pal,palavra_possivel_esp(Pal,Esp,Espacos,Letras),Pals_Possiveis).
