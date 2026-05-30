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
    write(Pemain), nl, !.
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
    team1(Anggota1),
    team2(Anggota2),
    format('Tim 1 : ~w ~n', [Anggota1]),
    format('Tim 2 : ~w ~n', [Anggota2]),
    arah(Arah),
    urutan_pemain(DaftarAcak),
    cetak_urutan(Arah, DaftarAcak),
    tampilkan_pemain(DaftarAcak, 1).
  