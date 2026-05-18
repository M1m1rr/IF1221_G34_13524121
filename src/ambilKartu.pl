ambilKartu :-
    urutan_pemain([Pemain|_]),
    efek_aktif(Efek),
    jumlahAmbil(Efek, N),
    drawN(Pemain, N, KartuDiambil),
    retract(efek_aktif(_)),
    assertz(efek_aktif(none)),
    printAmbil(Pemain, N, KartuDiambil),
    giliran_berikutnya.

jumlahAmbil(none, 1).
jumlahAmbil(draw_two, 2).
jumlahAmbil(wild_draw_four, 4).

drawN(_, 0, []) :- !.
drawN(Pemain, N, [Kartu|Rest]) :-
    N > 0,
    retract(sisa_deck(Deck)),
    panjang(Deck, L),
    lcg(L, Indeks),
    ambil_elemen(Indeks, Deck, Kartu, SisaDeck),
    assertz(sisa_deck(SisaDeck)),
    retract(simpan_kartu_pemain(Pemain, TanganLama)),
    assertz(simpan_kartu_pemain(Pemain, [Kartu|TanganLama])),
    N1 is N - 1,
    drawN(Pemain, N1, Rest).

printAmbil(Pemain, 1, [Kartu]) :-
    format('~w mendapatkan kartu: ', [Pemain]),
    printKartu(Kartu),
    write('.'), nl.
printAmbil(Pemain, N, _) :-
    N > 1,
    format('~w mendapatkan ~w kartu.~n', [Pemain, N]).