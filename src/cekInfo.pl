

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

cetak_urutan(_, [Pemain]) :- 
    format(Pemain), nl, !.
cetak_urutan(_ , []):- !.
cetak_urutan(kanan, [Pemain | Sisa]) :-
    write(Pemain), 
    write(' -> '),
    cetak_urutan(kanan, Sisa).

cetak_urutan(kiri, [Pemain | Sisa]) :-
    write(Pemain), write(' <- '),
    cetak_urutan(kiri, Sisa).

cekInfo:-
    (discard_pile(Pile) -> format('Kartu discard top: ~w~n', [Pile]) ; format('Pile kosong~n', [])),
    arah(Arah),
    urutan_pemain(DaftarAcak),
    cetak_urutan(Arah, DaftarAcak),
    tampilkan_pemain(DaftarAcak, 1).
  
