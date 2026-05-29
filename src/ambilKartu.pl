ambilKartu :-
    giliran(Pemain),
    efek_aktif(Efek),
    jumlahAmbil(Efek, N),
    drawN(Pemain, N, KartuDiambil),
    retract(efek_aktif(_)),
    assertz(efek_aktif(none)),
    printAmbil(Pemain, N, KartuDiambil),
    nextTurn.

jumlahAmbil(none, 1).
jumlahAmbil(draw_two, 2).
jumlahAmbil(wild_draw_four, 4).

drawN(_, 0, []) :- !.
drawN(Pemain, N, [Kartu|Rest]) :-
    N > 0,
    retract(draw_pile([Kartu|SisaPile])),
    assertz(draw_pile(SisaPile)),
    retract(tangan(Pemain, TanganLama)),
    assertz(tangan(Pemain, [Kartu|TanganLama])),
    N1 is N - 1,
    drawN(Pemain, N1, Rest).

printAmbil(Pemain, 1, [Kartu]) :-
    format('~w mendapatkan kartu: ', [Pemain]),
    printKartu(Kartu),
    write('.'), nl.
printAmbil(Pemain, N, _) :-
    N > 1,
    format('~w mendapatkan ~w kartu.~n', [Pemain, N]).