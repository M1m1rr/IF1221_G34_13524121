tantang :-
    (efek_aktif(wild_draw_four)
    ->  urutan_pemain([Penantang | _]),          
        pelaku_wild(Pelaku),                  
        simpan_kartu_pemain(Pelaku, TanganPelaku),
        discard_sebelumnya(kartu(Warna, Tipe)),
        (adaKartuCocok(TanganPelaku, Warna, Tipe)
        ->  format('Tantangan berhasil! ~w mendapatkan 4 kartu.~n', [Pelaku]),
            drawN(Pelaku, 4, _),
            retract(efek_aktif(_)),
            assertz(efek_aktif(none)),
            retractall(pelaku_wild(_)),
            giliran_berikutnya
        ;   format('Tantangan gagal! ~w mendapatkan 6 kartu.~n', [Penantang]),
            drawN(Penantang, 6, _),
            retract(efek_aktif(_)),
            assertz(efek_aktif(none)),
            retractall(pelaku_wild(_)),
            giliran_berikutnya
        )
    ;   write('Tidak ada wild_draw_four yang bisa ditantang.'), nl
    ).

adaKartuCocok([kartu(hitam, wild_draw_four)|Rest], Warna, Tipe) :- !,
    adaKartuCocok(Rest, Warna, Tipe).
adaKartuCocok([kartu(W, _)|_], W, _) :- !.
adaKartuCocok([kartu(_, angka(N))|_], _, angka(N)) :- !.
adaKartuCocok([_|Rest], Warna, Tipe) :-
    adaKartuCocok(Rest, Warna, Tipe).