cari_kartu_ke(1, [H|_], H) :- !.
cari_kartu_ke(Index, [_|T], Hasil) :-
    Index > 1,
    IndexSisa is Index - 1,
    cari_kartu_ke(IndexSisa, T, Hasil).

hapus_kartu(X, [X|T], T) :- !.
hapus_kartu(X, [H|T], [H|T1]) :-
    hapus_kartu(X, T, T1

putar_list(Input, Hasil) :-
    rekursi_putar(Input, [], Hasil).
rekursi_putar([], Accumulator, Accumulator).
rekursi_putar([H|T], Accumulator, Hasil) :-
    rekursi_putar(T, [H|Accumulator], Hasil).
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
   retractz(efek_aktif(Efek)),
   assertz(efek_aktif(draw_two)),
    nextTurn,!.
efek(kartu(_,draw_four)):-
    write('pemain berikutnya terkena draw 4'),
    retractz(efek_aktif(Efek)),
   assertz(efek_aktif(draw_four)),
    nextTurn, !.
efek(kartu(_,reverse)):-
    write('order pemain terbalik'), 
    urutan_pemain(DaftarAcak)
    putar_list(DaftarAcak, DaftarAcak1),
    retract(urutan_pemain(DaftarAcak)),
    assertz(urutan_pemain(DaftarAcak1)),
    nextTurn,!.

efek(_):-
    nextTurn,!
.
mainkanKartu(Index) :-
    giliran(Pemain),
    efek_aktif(Efek)
    simpan_kartu_pemain(Pemain, Indekskartu),
    nth1(Index, Indekskartu, Kartupemain ), 
    discard_pile(Kartumeja),
    cocok(Kartupemain, Kartumeja),
    select(Kartupemain, Indekskartu, Indekskartu1 ),
    retract(simpan_kartu_pemain(Pemain, Indekskartu)),
    assertz(simpan_kartu_pemain(Pemain, Indekskartu1)),
    assertz(discard_pile(Kartumeja)),
    retract(discard_pile(Kartumeja)),
    assertz(discard_pile(Kartupemain)),
    format('~w memainkan kartu: ~w', [Pemain], [Kartupemain]),
    urutan_pemain(Pemain|_),
    efek(Kartupemain).



