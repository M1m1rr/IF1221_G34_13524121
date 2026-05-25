tangkap(Target) :-
    urutan_pemain([PemainAktif | _]),
    (status_uni(Target, lupa_uni) ->
        format('~w tertangkap tidak menyerukan UNI.~n', [Target]),
        format('~w mendapatkan 2 kartu penalti.~n~n', [Target]),
        retract(sisa_deck([KartuSatu, KartuDua | SisaDeck])),
        assertz(sisa_deck(SisaDeck)),
        retract(simpan_kartu_pemain(Target, TanganTargetLama)),
        assertz(simpan_kartu_pemain(Target, [KartuSatu, KartuDua | TanganTargetLama])),
        retractall(status_uni(Target, _)),
        giliran_berikutnya, !
    ;
        format('Perintah tangkap tidak valid! ~w tidak melanggar aturan.~n', [Target]),
        format('~w mendapatkan 1 kartu penalti.~n', [PemainAktif]),
        retract(sisa_deck([KartuPenalti | SisaDeck])),
        assertz(sisa_deck(SisaDeck)),
        retract(simpan_kartu_pemain(PemainAktif, TanganPenuduhLama)),
        assertz(simpan_kartu_pemain(PemainAktif, [KartuPenalti | TanganPenuduhLama])),
        !
    ).
