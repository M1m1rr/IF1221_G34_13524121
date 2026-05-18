putar_list(Input, Hasil) :-
    rekursi_putar(Input, [], Hasil).

rekursi_putar([], Accumulator, Accumulator).
rekursi_putar([H|T], Accumulator, Hasil) :-
    rekursi_putar(T, [H|Accumulator], Hasil).

cocok(kartu(Warna, _), kartu(Warna, _)) :- !.
cocok(kartu(_, Sama), kartu(_, Sama)):- !.
cocok(kartu(hitam, _), kartu(_, _)):-!.

efek(kartu(_, skip)):-
    write('pemain berikutnya kehilangan giliran'), 
    nextturn,
    nextturn,!.
efek(kartu(_, draw_two)):-
    write('pemain berikutnya terkena draw 2'), 
    nextturn,
    ambilKartu,
    ambilKartu,
    nextturn,!.
efek(kartu(_,draw_four)):-
    write('pemain berikutnya terkena draw 4'),
    ambilKartu,
    ambilKartu,
    ambilKartu,
    ambilKartu,
    nextturn, !.
efek(kartu(_,reverse)):-
    write('order pemain terbalik'), 
    putar_list(DaftarAcak, DaftarAcak1),
    retract(urutan_pemain(DaftarAcak)),
    assertz(urutan_pemain(DaftarAcak1)).
    nextturn,!.

efek(_):-
    nextturn,!.

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