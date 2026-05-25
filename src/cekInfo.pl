hitung_elemen([], 0).
hitung_elemen([_|Tail], Jumlah) :-
    hitung_elemen(Tail, Jumlah_Sisa),
    Jumlah is Jumlah_Sisa + 1.

tampilkan_pemain([], _).
tampilkan_pemain([Pemain | SisaPemain], X) :-
    format('Nama pemain ~w: ~w~n', [X, Pemain]), 
    (tangan(Pemain, Index) -> 
        hitung_elemen(Index, Jumlah),
        format('Jumlah kartu: ~w~n', [Jumlah])
    ;   format('Jumlah kartu: 0 (Tidak ada kartu)~n', [])
    ),
    X1 is X + 1,
    tampilkan_pemain(SisaPemain, X1).

cekInfo:-
    (draw_pile(Pile) -> format('Kartu discard top: ~w~n', [Pile]) ; format('Pile kosong~n', [])),
    (urutan_pemain(DaftarAcak) -> 
        format('Urutan pemain: ~w~n', [DaftarAcak]),
        tampilkan_pemain(DaftarAcak)
    ;   write('Daftar pemain tidak ditemukan~n')
    ).
