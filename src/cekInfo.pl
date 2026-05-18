hitung_elemen([], 0).
hitung_elemen([_|Tail], Jumlah) :-
    hitung_elemen(Tail, Jumlah_Sisa),
    Jumlah is Jumlah_Sisa + 1.


printplayer([], _).
printplayer(DaftarAcak):-
printplayer(DaftarAcak, 1).
printplayer([Pemain| SisaPemain], X):-
format('Nama pemain ~w: ~w', [X,Pemain]),
tangan(Pemain, Index),
hitung_elemen(Index, Jumlah),
format('Jumlah kartu: ~w', [Jumlah]),
X1 is X+1,
printplayer(SisaPemain, X1).

cekInfo:-
draw_pile(Pile),
format('kartu discard top: ~w', [Pile]),
daftarAcak(DaftarAcak),
format('Urutan pemain:~w' [DaftarAcak]),
printplayer(DaftarAcak).
giliran(Turn),


