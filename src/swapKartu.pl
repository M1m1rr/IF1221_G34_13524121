swapKartu(Indeks1, Indeks2):-
    urutan_pemain([Pemain|_]),
    mode_main(Mode),
    Mode =:= 2,
    tim(Pemain, Tim),
    tim(Pemain2, Tim),
    Pemain2 \= Pemain,
    simpan_kartu_pemain(Pemain, Tangan),
    simpan_kartu_pemain(Pemain2, Tangan2),
    hitung_elemen(Tangan, Jumlah),
    hitung_elemen(Tangan2, Jumlah2),
    Jumlah >=2,
    Jumlah2>=2,
    Indeks1 >=1,
    Indeks2 >=1,
    Indeks1 =<Jumlah,
    Indeks2 =<Jumlah2,
    cari_kartu_ke(Indeks1, Tangan, Kartu1),
    cari_kartu_ke(Indeks2, Tangan2, Kartu2),
    hapus_kartu(Kartu1, Tangan, Sisa1),
    hapus_kartu(Kartu2, Tangan2, Sisa2),
    gabung_list(Sisa1, [Kartu2], TanganBaru),
    gabung_list(Sisa2, [Kartu1], TanganBaru2),
    retract(simpan_kartu_pemain(Pemain, Tangan)),
    retract(simpan_kartu_pemain(Pemain2, Tangan2)),
    assertz(simpan_kartu_pemain(Pemain, TanganBaru)),
    assertz(simpan_kartu_pemain(Pemain2, TanganBaru2)),
    format('~w berhasil menukar kartu ~w dengan kartu ~w milik ~w ~n', [Pemain, Kartu1, Kartu2, Pemain2]),
    write('pertukaran kartu berhasil.'), nl,
    giliran_berikutnya.

    

    