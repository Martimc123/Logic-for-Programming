/* 97326 Martim Correia */

:- [codigo_comum].

% Neste predicado e usado o sort para ordenar a lista de palavras e
% depois percorre as listas de palavras e cada palavra que encontra
% aplica o predicado atom_chars e guarda-as num acumulador, sendo que
% quando chegar a lista vazia e devolvida a lista de lista de palavras
% ordenadas.

obtem_letras_palavras(LP,LETRAS) :- sort(LP,NLP),
                                    obtem_letras_palavras(NLP,LETRAS,[]).

obtem_letras_palavras([],LETRAS,LETRAS).

obtem_letras_palavras([P|R],LETRAS,L) :- atom_chars(P, NP),
                                         append(L,[NP],NL),
                                         obtem_letras_palavras(R,LETRAS,NL).

% Neste predicado percorre-se a lista e vai se adicionando os espacos a
% um acumulador, quando se encontra um # e devolvida a lista com o
% espaco caso o seu comprimento seja maior ou igual a 3, senao volta-se
% a procurar na lista ate encontrar um espaco com comprimento maior ou
% igual a 3.

espaco_fila(F,Result) :- espaco_fila(F,[],Result).

espaco_fila([],Acc,Acc) :- length(Acc,C),
                           C < 3,
                           false.

espaco_fila([],Acc,Acc) :- length(Acc,C),
                           C >= 3.

espaco_fila([P|R],Acc,Result) :-
   P \== #,
   !,
   append(Acc,[P],NextAcc),
   espaco_fila(R,NextAcc,Result).

espaco_fila([#|_],Acc,Acc) :-
   length(Acc,L),
   L >= 3.

espaco_fila([#|R],_,Result) :-
   espaco_fila(R,[],Result).

% Este predicado faz o mesmo que espaco_fila, mas em vez de ver um
% espaco, ve todos os espacos possiveis para uma lista.

espacos_fila(F,E) :- espacos_fila(F,E,[],[]).

espacos_fila([],E,ACL,ACE) :- length(ACE,C),
                                 C >= 3,
                                 append(ACL,[ACE],NACL),
                                 espacos_fila([],E,NACL,[]),!.
espacos_fila([],ACL,ACL,_) :- !.

espacos_fila([P|R],E,ACL,ACE) :- P \== #,!,
                                 append(ACE,[P],NACE),
                                 espacos_fila(R,E,ACL,NACE).

espacos_fila([P|R],E,ACL,ACE) :- P == #,
                                 length(ACE,C),
                                 C >= 3,!,
                                 append(ACL,[ACE],NACL),
                                 espacos_fila(R,E,NACL,[]).

espacos_fila([#|R],E,ACL,ACE) :- length(ACE,C),
                                 C < 3,!,
                                 espacos_fila(R,E,ACL,[]).

% Neste predicado, e adicionanda a matriz transporta deste predicado, ou
% seja, adicionas as colunas do puzzle a grelha.
% Apos isso e percorrida a grelha e atraves do predicado espacos fila
% sao devolvidos os espacos numa linha/coluna e adicionados ao contador.
% Quando a lista for vazia e devolvido todos os espacos na grelha.

espacos_puzzle(G,E) :- mat_transposta(G,TG),
                       append(G,TG,NG),
                       espacos_puzzle(NG,E,[]).

espacos_puzzle([],AC,AC).

espacos_puzzle([P|R],E,AC) :- espacos_fila(P,NP),
                              append(AC,NP,NAC),
                              espacos_puzzle(R,E,NAC).

% Neste predicado e verificado se existe um elemento numa lista igual ao
% elemento fornecido.

membereq(X, [H|_]) :-
    X == H,!.
membereq(X, [_|T]) :-
    membereq(X, T),!.

%Neste predicado e verificado se duas listas tem elementos em comum.

common_elements([H|_], L2) :-
    membereq(H, L2),!.
common_elements([_|T], L2) :-
    common_elements(T, L2),!.

non_common_elements(L1,L2) :- \+ common_elements(L1,L2).

% Neste predicado e percorrida a lista de espacos (E) e se espaco for
% igual ou nao tiver espacos em comum e percorrido a lista ate chegar a
% lista vazia, e quando chegar la devolve o que se encontra no
% acumulador.

espacos_com_posicoes_comuns(E,EL,EC) :-  espacos_com_posicoes_comuns(E,EL,EC,[]).

espacos_com_posicoes_comuns([],_,AC,AC) :- !.

espacos_com_posicoes_comuns([P|R],E1,EC,AC) :- P == E1,!,
                        espacos_com_posicoes_comuns(R,E1,EC,AC).

espacos_com_posicoes_comuns([P|R],E1,EC,AC) :-
                        common_elements(P,E1), P \== E1,!,
                        append(AC,[P],NAC),
                        espacos_com_posicoes_comuns(R,E1,EC,NAC).

espacos_com_posicoes_comuns([P|R],E1,EC,AC) :-
                        non_common_elements(P,E1),!,
                        espacos_com_posicoes_comuns(R,E1,EC,AC).

% Este predicado percorre a lista de espacos e ve se existe alguma
% palavra na lista de palavras(LP) que unifica com esse espaco.

espacos_pal_uni([],_).

espacos_pal_uni([E|RE],LP) :- member(E,LP),
                              espacos_pal_uni(RE,LP).

% Verifica se o espaco (Esp) e a palavra(Pal) tem o mesmo comprimento e se tiverem unifica-os
% apos isso sao unificados os espacos comuns(NEsps) com as palavras da
% lista de palavras.

palavra_possivel_esp(Pal, Esp, Esps, Letras) :-
    espacos_com_posicoes_comuns(Esps,Esp,NEsps),
    Pal = Esp,
    espacos_pal_uni(NEsps,Letras),!.

% Caso os espacos comuns ao Esp nao sejam unificaveis.

npalavra_possivel_esp(P, Esp, Esps, Ltrs) :- \+ palavra_possivel_esp(P, Esp, Esps, Ltrs).

% Converte o predicado palavras_possiveis_esp/4 num predicado palavras_possiveis_esp/6, com uma copia das letras e um acumulador

% apos isso percorre a lista de palavras e verifica se possivel para aquele espaco, e se for unifica com esse espaco e adiciona
% essa palavra ao acumulador e ve o resto da lista para ver se a proxima
% palavra tambem e

% Caso a palavra nao seja possivel para aquele espaco, entao ve se a
% palavra a seguir e ate a lista de palavras ser vazia, devolvendo o que
% esta dentro do acumulador no final.

palavras_possiveis_es(Ltrs,Esps,Esp,Pals) :-
    palavras_possiveis_es(Ltrs,Esps,Esp,Pals,Ltrs,[]).

palavras_possiveis_es(_,_,_,AC,[],AC).


palavras_possiveis_es(Ltrs,Esps,Esp,Pals,[P|RP],AC) :-
    palavra_possivel_esp(P, Esp, Esps, Ltrs),
    append(AC,P,NAC),
    palavras_possiveis_es(Ltrs,Esps,Esp,Pals,RP,NAC).

palavras_possiveis_es(Ltrs,Esps,Esp,Pals,[_|R],AC) :-
    palavras_possiveis_es(Ltrs,Esps,Esp,Pals,R,AC).


% Neste predicado sao encontradas todas as palavras possiveis para um
% espaco e devolve a lista com todas as palavras.

palavras_possiveis_esp_aux(Ltrs,Esps,Esp,Npals) :-
    findall(Pals,palavras_possiveis_es(Ltrs,Esps,Esp,Pals),Npals).

% Neste predicado sao encontradas todas as palavras possiveis para um
% espaco, e caso essas palavras sejam listas vazias entao sao removidas
% das palavras possiveis.

palavras_possiveis_esp(Ltrs,Esps,Esp,Npals2) :- palavras_possiveis_esp_aux(Ltrs,Esps,Esp,Npals),delete(Npals,[],Npals2).

% Neste predicado e percorrida a lista de espacos sao calculadas quais
% as palavras possiveis para cada espaco e de seguida e adicionado ao
% acumulador uma lista com o espaco e as respetivas palavras possiveis.
% Quando a lista for vazia e devolvida as palavras possiveis para todos
% os espacos.

palavras_possiveis(Letras,Espacos,Pals_Possiveis) :-
   palavras_possiveis(Letras,Espacos,Pals_Possiveis,Espacos,[]).

palavras_possiveis(_,_,AC,[],AC).

palavras_possiveis(Letras,Espacos,Pals_Possiveis,[P|R],AC) :-
   palavras_possiveis_esp(Letras,Espacos,P,Pals_Esp),
   append(AC,[[P,Pals_Esp]],NAC),
   palavras_possiveis(Letras,Espacos,Pals_Possiveis,R,NAC).

% Neste predicado e percorrida a lista de palavras e verifica se quais
% os elementos em comum em todas as palavras e qual o seu indice,
% devolvendo-se uma lista com parentises correspondentes a letra e ao
% respetivo indice.

letras_comuns(Lst_Pals, Letras_comuns) :-
    findall((L,I), foreach(member(X,Lst_Pals),nth1(L,X,I)), Letras_comuns).

% Este predicado faz o mesmo que o anterior so que devolve uma lista com
% listas que contem a letra e o respetivo indice das palavras.

letras_comuns_lst(Lst_Pals, Letras_comuns) :- findall([I,L], foreach(member(X,Lst_Pals),nth1(L,X,I)), Letras_comuns).

% Neste predicado sao unificadas as letras_comuns com um espaco

aux_lst(_,[]).

aux_lst(E,[P|R]) :-  nth1(2,P,Index),
                     nth1(1,P,ElP),
                     nth1(Index,E,ElP),
                     aux_lst(E,R).

% Neste predicado sao atribuidas a cada Palavra_possivel as letras
% comuns, sendo adicionada a Palavra possivel ao acumulador. Quando a
% lista de palavras_possiveis for vazia e devolvido a lista de palavras
% possiveis com todos as letras comuns unificadas aos espacos.

atribui_comuns(Pals) :- atribui_comuns(Pals,Pals).

atribui_comuns([],_).

atribui_comuns([P|R],Pals_uni) :- nth1(1,P,Esp),
                                  nth1(2,P,Pal),
                                  letras_comuns_lst(Pal,Letras),
                                  aux_lst(Esp,Letras),
                                  atribui_comuns(R,Pals_uni).

% Neste predicado e verificado na lista de palavras, quais as palavras
% sao unificaveis com um certo espaco, caso sejam unificaveis sao
% adicionadas a um acumulador. Quando chegar a lista vazia e devolvido
% as palavras que sao unificaveis.

retira_impossiveis_aux(Esp,Pals,Npal) :-
   retira_impossiveis_aux(Esp,Pals,Npal,[]).


retira_impossiveis_aux(_,[],AC,AC) :- !.

retira_impossiveis_aux(Esp,[P|R],Npal,AC) :- Esp \= P,!,
                                           retira_impossiveis_aux(Esp,R,Npal,AC).

retira_impossiveis_aux(Esp,[P|R],Npal,AC) :- append(AC,[P],NAC),!,
                                          retira_impossiveis_aux(Esp,R,Npal,NAC).

% Neste predicado e feita a verificacao de de cada palavra possivel e
% sao retiradas as palavras impossiveis, apos isso a palavra e
% adicionada ao acumulador. Quando a lista for vazia e devolvida a lista
% de palavras possiveis com as respetivas palavras impossiveis
% removidas.

retira_impossiveis(Pals, Novas_Pals) :- retira_impossiveis(Pals, Novas_Pals,[]).

retira_impossiveis([], Novas_Pals,Novas_Pals) :- !.

retira_impossiveis([P|R],Novas_Pals,AC) :-
                         nth1(1,P,Esp),
                         nth1(2,P,Pals),
                         retira_impossiveis_aux(Esp,Pals,Pals_fil),!,
                         append(AC,[[Esp,Pals_fil]],NAC),
                         retira_impossiveis(R,Novas_Pals,NAC).

% Neste predicado e percorrida a lista de palavras possiveis e se a
% palavra possivel so tiver uma palavra, ou seja, o comprimento da
% lista das palavras for 1, entao adiciona se a palavra ao acumulador.
% No final quando a lista de palavras possiveis for vazia e devolvida a
% lista de palavras que sao unicas.

obtem_unicas(Pals,Unicas) :- obtem_unicas(Pals,Unicas,[]).

obtem_unicas([],AC,AC) :- !.

obtem_unicas([P|R],Unicas,AC) :- nth1(2,P,Pal),
                                 length(Pal,C),
                                 C == 1,!,
                                 append(AC,Pal,NAC),
                                 obtem_unicas(R,Unicas,NAC).

obtem_unicas([P|R],Unicas,AC) :- length(P,C),
                                 C > 1,!,
                                 obtem_unicas(R,Unicas,AC).

% Neste predicado e percorrida a lista de palavras de uma palavra
% possivel e se a palavra for membro da lista de Npals (palavras
% unicas), entao essa palavra nao e adicionada ao acumulador, senao a
% palavra e adicionada ao acumulador. Quando a lista for vazia e
% devolvida a lista de palavras que nao sao membros de Npals, ou seja,
% que nao sao unicas.

retira_unicas_aux(Pals,Letras,NPals) :- retira_unicas_aux(Pals,Letras,NPals,[]).

retira_unicas_aux([],_,NAC,NAC) :- !.

retira_unicas_aux([P|R],Letras,NPals,AC) :- member(P,Letras),!,
                                         retira_unicas_aux(R,Letras,NPals,AC).

retira_unicas_aux([P|R],Letras,NPals,AC) :- !,append(AC,[P],NAC),
                                            retira_unicas_aux(R,Letras,NPals,NAC).


% Neste predicado sao obtidas as palavras unicas das palavras possiveis
% e convertido o predicado no predicado retira_unicas/4 em os novos os
% arguementos sao as palavras unicas e um acumulador.

% Apos isso, e verificada cada palavra possivel, se for unitaria e
% adicionada ao acumulador, senao sao retiradas as palavras que sejam
% membros das palavras unicas e sao adicionadas as palavras possiveis e
% respetivo espaco associado ao acumulador. Quando a lista de
% palavras possiveis for vazia e devolvido o a lista com as palavras
% possiveis.

retira_unicas(Pals_Poss, Novas_Pals) :-
   obtem_unicas(Pals_Poss,Unicas),
   retira_unicas(Pals_Poss,Novas_Pals,[],Unicas).

retira_unicas([],AC,AC,_) :- !.

retira_unicas([P|R],Novas_Pals,AC,Unicas) :-
       nth1(1,P,Esp),
       nth1(2,P,Pals),
       length(Pals,C),
       C > 1,!,
       retira_unicas_aux(Pals,Unicas,NPals),
       append(AC,[[Esp,NPals]],NAC),
       retira_unicas(R,Novas_Pals,NAC,Unicas).

retira_unicas([P|R],Novas_Pals,AC,Unicas) :- append(AC,[P],NAC),
                                        retira_unicas(R,Novas_Pals,NAC,Unicas).

% Neste predicado e convertido no inicio para um novo predicado
% simplifica/3 em que o novo argumento e um contador que corresponde ao
% comprimento da lista.
% Enquanto que o contador nao for 0 e aplicado os predicados
% atribui_comuns, retira_impossiveis e retira_unicas.
% Quando o contador for 0 devolvido as palavras possiveis inicializadas

simplifica(Pals,Novas_Pals_fin) :- length(Pals,C),
                                   simplifica(Pals,Novas_Pals_fin,C).
simplifica(Pals,Pals,0).

simplifica(Pals,Res,Cont) :- Cont > 0,
                                atribui_comuns(Pals),
                                retira_impossiveis(Pals,Novas_Pals),
                                retira_unicas(Novas_Pals,Unicas_Pals),
                                Ncont is Cont - 1,
                                simplifica(Unicas_Pals,Res,Ncont).

% Neste predicado e fornecido um puzzle e e aplicado o predicado nth1 de
% modo a obter a grelha e as palavras do puzzle. Apos isso e aplicado o
% predicado obtem_letras_palavras de modo a se obter a lista de listas
% de palavras do puzzle, e tambem e aplicado o predicado espacos puzzle
% de modo a obter-se os espacos do puzzle. De seguida, aplica-se o
% predicado palavras_possiveis para obter-se a lista de palavras
% possiveis para cada espaco. Para finalizar aplica-se o predicado
% simplifica, de modo, a simplicar o puzzle.

inicializa(Puz,NPals) :-
                      nth1(1,Puz,Palavras_Ini),
                      nth1(2,Puz,Grelha),
                      obtem_letras_palavras(Palavras_Ini,Letras),
                      espacos_puzzle(Grelha,Espacos),
                      palavras_possiveis(Letras, Espacos, Pals_Possiveis),
                      simplifica(Pals_Possiveis,NPals).

% Neste predicado e percorrida a lista de palavras possiveis, de modo, a
% obter-se as palavras que tenham mais do que uma palavra associada a um
% espaco, ou seja, as palavras que nao sejam unitarias.

% E invertida a lista porque o predicado mais_pequeno necessita que a
% lista esteja invertida para funcionar corretemente.

escolhe_menos_alternativas_aux(Pals_pos,Pals) :- reverse(Pals_pos,Pals2),
                              escolhe_menos_alternativas_aux(Pals2,Pals,[]).

escolhe_menos_alternativas_aux([],AC,AC) :- !.

escolhe_menos_alternativas_aux([P|R],Pals_fin,AC) :-
           nth1(2,P,Pals),
           length(Pals,C),
           C > 1,!,
           append(AC,[Pals],NAC),
           escolhe_menos_alternativas_aux(R,Pals_fin,NAC).

escolhe_menos_alternativas_aux([_|R],Pals_fin,AC) :-
           escolhe_menos_alternativas_aux(R,Pals_fin,AC).

% Neste predicado percorre se a lista de palavras possiveis
% (considerando que ela seja inicialmente inversa) e ve qual e a que tem
% um menor comprimento, devolvendo a lista correspondente.

mais_pequeno([L], L) :- !.

mais_pequeno([P|R], P) :- length(P, N),
                          mais_pequeno(R, C),
                          length(C, M),
                          N < M,!.

mais_pequeno([_|R], C) :- mais_pequeno(R, C),!.

% E convertido o predicado escolhe_menos_alternativas/2 no predicado
% escolhe_menos_alternativas/4 em que os novos argumentos sao um
% acumulador e a pal que consiste na primeira palavra_possivel em que a
% lista das palavras associadas tenha o menor comprimento.

% Apos isso e percorrida a lista de palavras possiveis ate encontar a
% palavra possivel que tenha as mesmas palavras que Pal, sendo
% adicionada ao acumulador quando for encontrada. Quando a lista de
% palavras_possiveis for vazia e devolvida a palavra possivel que se
% encontra no acumulador.

escolhe_menos_alternativas(Pals,Escolha) :-
   escolhe_menos_alternativas_aux(Pals,Npals),
   mais_pequeno(Npals,Pal),
   escolhe_menos_alternativas(Pals,Escolha,[],Pal).

escolhe_menos_alternativas([],AC,AC,_).

escolhe_menos_alternativas([P|_],Escolha,AC,Pal) :-
  nth1(1,P,Esp),
  nth1(2,P,Pals),
  Pals == Pal,!,
  append(AC,[Esp,Pals],NAC),
  escolhe_menos_alternativas([],Escolha,NAC,Pal).

escolhe_menos_alternativas([_|R],Escolha,AC,Pal) :-
   escolhe_menos_alternativas(R,Escolha,AC,Pal).

% No predicado exprimenta_pal e selecionado o espaco e a lista de
% palavras correspondente e unifica-se uma das palavras com o espaco
% e e substituido o espaco nas palavras_possiveis.

experimenta_pal(Escolha,Pals_Possiveis,Novas_Pals_Possiveis) :-
   nth1(1,Escolha,Esp),
   nth1(2,Escolha,Lst_Pals),
   member(Pal,Lst_Pals),
   Esp = Pal,
   select(Escolha,Pals_Possiveis,[Esp, [Pal]],Novas_Pals_Possiveis).

% No predicado resolve_aux e chamado primeiro o predicado
% escolhe_menos_alternativas, de modo a escolher o espaco por onde se
% comeca a resolver o puzzle,depois o exprimenta_pal para unificar uma
% palavra com o espaco e depois o simplifica de modo a simplificar o
% puzzle. No final quando as palavras recebidas forem iguais as palavras
% a devolver e nao existem mais alternativas o predicado acaba.

resolve_aux(Pals_Possiveis,Pals_fin2) :-
   escolhe_menos_alternativas(Pals_Possiveis,Pal),!,
   experimenta_pal(Pal,Pals_Possiveis,Npals),
   simplifica(Npals,Pal_fin),
   resolve_aux(Pal_fin,Pals_fin2).

resolve_aux(Pals_Possiveis,Pals_Possiveis).

% No predicado resolve e chamado o predicado inicializa, de modo, a
% inicializar o puzzle, apos isso o puzzle e resolvido e escrito com os
% predicados resolve_aux e escreve grelha.

resolve(Puz) :-
   inicializa(Puz, Pals_Possiveis),
   resolve_aux(Pals_Possiveis, Novas_Pals_Possiveis),
   escreve_Grelha(Novas_Pals_Possiveis).




























