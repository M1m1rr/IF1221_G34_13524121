hitung_elemen([], 0).
hitung_elemen([_|Tail], Jumlah) :-
    hitung_elemen(Tail, Jumlah_Sisa),
    Jumlah is Jumlah_Sisa + 1.

printplayer([], _).
printplayer(DaftarAcak):-
    printplayer(DaftarAcak, 1).
printplayer([Pemain|SisaPemain], X) :-
    format('Nama pemain ~w: ~w~n', [X, Pemain]),
    tangan(Pemain, Index),
    hitung_elemen(Index, Jumlah),
    format('Jumlah kartu: ~w~n', [Jumlah]),
    X1 is X + 1,
    printplayer(SisaPemain, X1).

cekInfo :-
    draw_pile(Pile),
    format('Kartu discard top: ~w~n', [Pile]),
    urutan_pemain(DaftarAcak),
    format('Urutan pemain: ~w~n', [DaftarAcak]),
    printplayer(DaftarAcak),
    giliran(Turn),
    format('Giliran: ~w~n', [Turn]).