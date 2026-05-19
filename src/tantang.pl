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


