<<<<<<< Updated upstream

putar_list(Input, Hasil) :-
    rekursi_putar(Input, [], Hasil).
rekursi_putar([], Accumulator, Accumulator).
rekursi_putar([H|T], Accumulator, Hasil) :-
    rekursi_putar(T, [H|Accumulator], Hasil).
=======
kartu_aksi(kartu(_, skip)).
kartu_aksi(kartu(_, draw_two)).
kartu_aksi(kartu(_, wild_draw_four)).
kartu_aksi(kartu(_, reverse)).
kartu_aksi(kartu(_, wild)).

list_warna(X, [X|_]) :- !.
list_warna(X, [_|T]) :-
    list_warna(X, T).

>>>>>>> Stashed changes
cocok(kartu(Warna, _), kartu(Warna, _)) :- !.
cocok(kartu(_, Sama), kartu(_, Sama)):- !.
cocok(kartu(hitam, _), kartu(_, _)):-!.
efek(kartu,(_, skip)):-
    write('pemain berikutnya kehilangan giliran'), 
    nextTurn,
    nextTurn,!.
efek(kartu(_, draw_two)):-
    write('pemain berikutnya terkena draw 2'), 
    nextTurn,
    ambilKartu,
    ambilKartu,
    nextTurn,!.
efek(kartu(_,draw_four)):-
    write('pemain berikutnya terkena draw 4'),
    ambilKartu,
    ambilKartu,
    ambilKartu,
    ambilKartu,
    nextTurn, !.
efek(kartu(_,reverse)):-
    write('order pemain terbalik'), 
    putar_list(DaftarAcak, DaftarAcak1),
    retract(urutan_pemain(DaftarAcak)),
    assertz(urutan_pemain(DaftarAcak1)).
    nextTurn,!.

efek(_):-
    nextTurn,!
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
    assertz(draw_pile(Kartumeja)),
    retract(draw_pile(Kartumeja)),
    assertz(draw_pile(Kartupemain)),
    format('~w memainkan kartu: ~w', [Pemain], [Kartupemain]),
    urutan_pemain(DaftarAcak),
    efek(Kartupemain).
