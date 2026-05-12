
cocok(kartu(Warna, _), kartu(Warna, _)) :- !.
cocok(kartu(_, Sama), kartu(_, Sama)):- !.
cocok(kartu(hitam, _), kartu(_, _)):-!.
efek(kartu,(_, skip)):-
write('pemain berikutnya kehilangan giliran'), !.
efek(kartu(_, draw_two)):-
write('pemain berikutnya terkena draw 2'), !.
efek(kartu(_,draw_four)):-
write('pemain berikutnya terkena draw 4'), !.
efek(kartu(_,reverse)):-
write('order pemain terbalik'), !.
efek(_):-
.

mainkanKartu(Index) :-
giliran(Pemain),
efek_aktif(Efek),
tangan(Pemain, Indekskartu),
nth1(Index, Indekskartu, Kartupemain ), 
draw_pile(Kartumeja),
cocok(Kartupemain, Kartumeja),
select(Kartupemain, Indekskartu, Indekskartu1 ),
retract(tangan(Pemain, Indekskartu)),
assertz(tangan(Pemain, Indekskartu1)),
retract(draw_pile(Kartumeja)),
assertz(draw_pile(Kartupemain)),
format('~w memainkan kartu: ~w', [Pemain], [Kartupemain]),
efek(Kartupemain),
nextturn.



