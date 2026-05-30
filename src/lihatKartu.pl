lihatKartu :-
    urutan_pemain([Pemain|_]),
    simpan_kartu_pemain(Pemain, Tangan),
    write('Berikut kartu yang anda miliki.'), nl,
    printTangan(Tangan, 1).

printTangan([], _):- !.
printTangan([Kartu|Rest], N) :-
    format('~w. ', [N]),
    printKartu(Kartu),
    nl,
    N1 is N + 1,
    printTangan(Rest, N1).

printKartu(kartu(W, angka(N))) :-
    format('~w-~w', [W, N]), !.
printKartu(kartu(W, J)) :-
    J \= angka(_),
    format('~w-~w', [W, J]).