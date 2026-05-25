cari_kartu_ke(1, [H|_], H) :- !.
cari_kartu_ke(Index, [_|T], Hasil) :-
    Index > 1,
    IndexSisa is Index - 1,
    cari_kartu_ke(IndexSisa, T, Hasil).

hapus_kartu(X, [X|T], T) :- !.
hapus_kartu(X, [H|T], [H|T1]) :-
    hapus_kartu(X, T, T1).

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
   retract(urutan_pemain([PemainSekarang | PemainLainnya])),    
    append_element(PemainLainnya, [PemainSekarang], UrutanBaru),
    UrutanBaru = [PemainSelanjutnya | _],
    assertz(urutan_pemain(UrutanBaru)),
    giliran_berikutnya.
efek(kartu(_, draw_two)):
    write('pemain berikutnya terkena draw 2'), 
   assertz(efek_aktif(draw_two)),
    giliran_berikutnya,!.
efek(kartu(_,draw_four)):-
    write('pemain berikutnya terkena draw 4'),
   assertz(efek_aktif(draw_four)),
    giliran_berikutnya, !.
efek(kartu(_,reverse)):-
    write('order pemain terbalik'), 
    urutan_pemain(DaftarAcak),
    putar_list(DaftarAcak, DaftarAcak1),
    retract(urutan_pemain(DaftarAcak)),
    assertz(urutan_pemain(DaftarAcak1)),
    giliran_berikutnya,!.

efek(_):-
    giliran_berikutnya,!
.
mainkanKartu(Index) :-
    urutan_pemain([Pemain|_]),
    simpan_kartu_pemain(Pemain, Indekskartu),
    cari_kartu_ke(Index, Indekskartu, Kartupemain ), 
    discard_pile(Kartumeja),
    cocok(Kartupemain, Kartumeja),
    hapus_kartu(Kartupemain, Indekskartu, Indekskartu1 ),
    retract(simpan_kartu_pemain(Pemain, Indekskartu)),
    assertz(simpan_kartu_pemain(Pemain, Indekskartu1)),
    retract(discard_pile(Kartumeja)),
    assertz(discard_pile(Kartupemain)),
    format('~w memainkan kartu: ~w.~n', [Pemain, Kartupemain]),
    efek(Kartupemain).



