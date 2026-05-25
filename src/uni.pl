uni(Indeks) :-
    urutan_pemain([PemainAktif | _]),
    simpan_kartu_pemain(PemainAktif, ListKartuTangan),
    (ambil_kartu_ke_n(Indeks, ListKartuTangan, KartuPilihan, ListKartuBaru) ->
        panjang(ListKartuBaru, JumlahSisa),
        (JumlahSisa \= 1 ->
            format('Perintah UNI tidak valid! Kartu tidak membuat tanganmu tersisa 1.~n', []),
            write('Kamu mendapatkan penalti 1 kartu acak dan giliranmu hangus!'), nl,
            retract(sisa_deck([KartuPenalti | SisaDeck])),
            assertz(sisa_deck(SisaDeck)),
            retract(simpan_kartu_pemain(PemainAktif, ListKartuTangan)),
            assertz(simpan_kartu_pemain(PemainAktif, [KartuPenalti | ListKartuTangan])),
            retractall(status_uni(PemainAktif, _)),
            giliran_berikutnya, !
        ;
            discard_pile(KartuMeja),
            (cocok(KartuPilihan, KartuMeja) ->
                retract(simpan_kartu_pemain(PemainAktif, ListKartuTangan)),
                assertz(simpan_kartu_pemain(PemainAktif, ListKartuBaru)),
                retract(discard_pile(KartuMeja)),
                assertz(discard_pile(KartuPilihan)),
                KartuPilihan = kartu(Warna, Jenis),
                format('~w memainkan kartu: ~w-~w.~n', [PemainAktif, Warna, Jenis]),
                format('~w menyerukan UNI!~n', [PemainAktif]),
                retractall(status_uni(PemainAktif, _)),
                assertz(status_uni(PemainAktif, sudah_uni)),
                efek(KartuPilihan),
                !
            ;
                write('Kartu tidak cocok! Silakan pilih kartu lain.'), nl, fail
            )
        )
    ;
        write('Nomor urut kartu tidak valid!'), nl, fail
    ).
