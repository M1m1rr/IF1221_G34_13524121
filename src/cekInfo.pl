<<<<<<< Updated upstream
hitung_elemen([], 0).
hitung_elemen([_|Tail], Jumlah) :-
    hitung_elemen(Tail, Jumlah_Sisa),
    Jumlah is Jumlah_Sisa + 1.


printplayer([], _).
printplayer(DaftarAcak):-
    printplayer(DaftarAcak, 1).
=======
tampilkan_pemain([], _).
tampilkan_pemain([Pemain | SisaPemain], X) :-
    format('Nama pemain ~w: ~w~n', [X, Pemain]), 
    (simpan_kartu_pemain(Pemain, Index) -> 
        hitung_elemen(Index, Jumlah),
        format('Jumlah kartu: ~w~n', [Jumlah])
    ;   format('Jumlah kartu: 0 (Tidak ada kartu)~n', [])
    ),
    X1 is X + 1,
    tampilkan_pemain(SisaPemain, X1).
>>>>>>> Stashed changes

printplayer([Pemain | SisaPemain], X):-
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
    format('Urutan pemain:~w', [DaftarAcak]),
    printplayer(DaftarAcak).
    
giliran(Turn).


