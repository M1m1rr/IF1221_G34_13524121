<<<<<<< Updated upstream
cek( [], _).
cek([Kepala|Sisa], Kartumeja):-
  cocok(Kepala, Kartumeja), !.

cek([_|Sisa], Kartumeja) :-
  cek(Sisa, Kartumeja).

cekkartu(DaftarAcak, Kartumeja) :-
  giliran(Pemain), 
  (cek(DaftarAcak, Kartumeja) ->
    (format('Tantangan berhasil! ~w mendapatkan 4 kartu tambahan.~n', [Pemain]),
    ambilKartu, ambilKartu, ambilKartu, ambilKartu);

    (nextturn, format('Tantangan gagal! ~w akan mendapat 6 kartu tambahan.~n', [Pemain]),
    ambilKartu, ambilKartu, ambilKartu, ambilKartu, ambilKartu, ambilKartu)).



cocok(Pile, kartu(hitam, draw_four)):- !.

tantang:-
  giliran(Pemain),
  write('tantangan dilakukan!!'),
  draw_pile(Pile),
  cocok(Pile, kartu(hitam, draw_four)),
  draw_pile(Kartumeja),
  urutan_pemain(DaftarAcak),
  format('memeriksa kartu ~w', [Pemain]), /* anggap a pemain udh ganti ke pemain sebelumnya*/
  cekkartu(DaftarAcak, Kartumeja).

=======
tantang :-
    (efek_aktif(wild_draw_four)
    ->urutan_pemain([Penantang, Pelaku | _]),
    simpan_kartu_pemain(Pelaku, TanganPelaku),
    warna_aktif(Warna),
    discard_pile(kartu(_, TipeDiscard)),
    (adaKartuCocok(TanganPelaku, Warna, TipeDiscard)
        ->format('Tantangan berhasil! ~w mendapatkan 4 kartu.~n', [Pelaku]),
        drawN(Pelaku, 4, _),
        retract(efek_aktif(_)),
        assertz(efek_aktif(none)),
        giliran_berikutnya
        ;format('Tantangan gagal! ~w mendapatkan 6 kartu.~n', [Penantang]),
        drawN(Penantang, 6, _),
        retract(efek_aktif(_)),
        assertz(efek_aktif(none)),
        giliran_berikutnya
        )
    ;write('Tidak ada wild_draw_four yang bisa ditantang.'), nl
    ).
>>>>>>> Stashed changes

