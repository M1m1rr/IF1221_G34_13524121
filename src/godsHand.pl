/* Ini bonus ya woi */

godsHand :-
    urutan_pemain(Urutan),
    (cek_syarat_godshand(Urutan) ->
        lcg(100, Rnd),
        ( Rnd < 15 ->
            eksekusi_godsHand(Urutan)
        ;
            true
        )
    ;
        true 
    ).

cek_syarat_godshand([]):- fail.
cek_syarat_godshand([Pemain | Sisa]) :-
    simpan_kartu_pemain(Pemain, Kartu),
    panjang(Kartu, L),
    ( L > 1 -> 
        true 
    ; 
        cek_syarat_godshand(Sisa) 
    ).

eksekusi_godsHand(Urutan) :-
    pilih_korban(Urutan, Korban),
    pilih_penerima(Urutan, Korban, Penerima),
    simpan_kartu_pemain(Korban, TanganKorban),
    panjang(TanganKorban, L_Tangan),
    lcg(L_Tangan, IdxKartu),
    ambil_elemen(IdxKartu, TanganKorban, KartuTerpilih, SisaTanganKorban),
    simpan_kartu_pemain(Penerima, TanganPenerima),
    TanganBaruPenerima = [KartuTerpilih | TanganPenerima],

    retract(simpan_kartu_pemain(Korban, TanganKorban)),
    assertz(simpan_kartu_pemain(Korban, SisaTanganKorban)),
    retract(simpan_kartu_pemain(Penerima, TanganPenerima)),
    assertz(simpan_kartu_pemain(Penerima, TanganBaruPenerima)),
    
    write('Tuhan telah berkehendak!'), nl,
    konversi_kartu_ke_format(KartuTerpilih, KartuFormat),
    format('Kartu ~w milik ~w berpindah ke tangan ~w!~n~n awokawokwawokoakw', [KartuFormat, Korban, Penerima]),
    Urutan =[Giliran | _],
    format('Giliran ~w.~n', [Giliran]).

pilih_korban(Daftar, Korban) :-
    panjang(Daftar, L),
    lcg(L, Idx),
    ambil_elemen(Idx, Daftar, Kandidat, _),
    simpan_kartu_pemain(Kandidat, Kartu),
    panjang(Kartu, Jml),
    (Jml > 0 -> 
        Korban = Kandidat 
    ; 
        pilih_korban(Daftar, Korban) 
    ).

pilih_penerima(Daftar, Korban, Penerima) :-
    panjang(Daftar, L),
    lcg(L, Idx),
    ambil_elemen(Idx, Daftar, Kandidat, _),
    (Kandidat \= Korban -> 
        Penerima = Kandidat 
    ; 
        pilih_penerima(Daftar, Korban, Penerima) 
    ).