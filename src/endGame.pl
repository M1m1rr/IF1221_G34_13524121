
nilai(kartu(_, angka(1)), 1).
nilai(kartu(_, angka(2)), 2).
nilai(kartu(_, angka(3)), 3).
nilai(kartu(_, angka(4)), 4).
nilai(kartu(_, angka(5)), 5).
nilai(kartu(_, angka(6)), 6).
nilai(kartu(_, angka(7)), 7).
nilai(kartu(_, angka(8)), 8).
nilai(kartu(_, angka(9)), 9).
nilai(kartu(_, angka(0)), 1).
nilai(kartu(_, reverse), 10).
nilai(kartu(_, draw_two), 10).
nilai(kartu(_, skip), 10).
nilai(kartu(_, mimic), 20).
nilai(kartu(_, wild), 20).
nilai(kartu(_, wild_draw_four), 20).

listSkor([], []).
listSkor([Pemain|Sisa], [[Skor, JK, Pemain]| Listsisa]):- 
    simpan_kartu_pemain(Pemain, Indeks),
    hitung_elemen(Indeks, JK),
    totPoin(Pemain, Skor, Indeks),
    listSkor(Sisa, Listsisa ).

peringkat(Pemain, [], [Pemain]).
peringkat([Skor1, JK1, Nama1], [[Skor2, JK2, Nama2]|Sisa], [[Skor1, JK1, Nama1], [Skor2, JK2, Nama2]|Sisa]) :-
    Skor1 < Skor2, !.
peringkat([Skor, JK1, Nama1], [[Skor, JK2, Nama2]|Sisa], [[Skor, JK1, Nama1], [Skor, JK2, Nama2]|Sisa]) :-
    JK1 < JK2, !.
peringkat(PemainBaru, [PemainLama|Sisa], [PemainLama|HasilSisa]) :-
    peringkat(PemainBaru, Sisa, HasilSisa).

urutkan_peringkat([], []).
urutkan_peringkat([Pemain|Sisa], Listterurut):-
    urutkan_peringkat(Sisa, List),
    peringkat(Pemain, List, Listterurut).

cetakKartu(kartu(Warna, angka(X))):-
    format('~w-~w', [Warna, X]), !.
cetakKartu(kartu(Warna, Atribut)):-
    format('~w-~w', [Warna, Atribut] ).

totPoin(_, 0, []).
totPoin(Pemain, Sum, [Indeks|Sisa]):-
 nilai(Indeks, Point),
 totPoin(Pemain, Sum1, Sisa),
 Sum is Sum1 + Point.

hitungSkor([]).
hitungSkor([Pemain|Sisa]):-
    simpan_kartu_pemain(Pemain, Indekskartu),
    totPoin(Pemain, Sum, Indekskartu),
    format('~w (~w poin)', [Pemain, Sum]),
    hitungSkor(Sisa).

cetakSkor(_, [Indeks]):-
   cetakKartu(Indeks), !.



cetakSkor(Pemain, [Indeks|Sisakartu]):-
    cetakKartu(Indeks),
    write('+'),
    cetakSkor(Pemain, Sisakartu).

cetakPoint(_, [Indeks]):-
    nilai(Indeks, Nilai),
    format('~w', [Nilai]), !.

cetakPoint(Pemain, [Indeks|Sisakartu]):-
    nilai(Indeks, Nilai),
    format('~w+', [Nilai]),
    cetakPoint(Pemain, Sisakartu).

showPointPemain(Pemain, []):-
    format('~w : kartu habis = 0', [Pemain]), !.

showPointPemain(Pemain, Indeks):-
    format('~w:', [Pemain]),
    cetakSkor(Pemain, Indeks),
    write('='),
    cetakPoint(Pemain, Indeks),
    write('='),
    totPoin(Pemain, Sum, Indeks),
    format('~w', [Sum]).


showallPointPemain([]).
showallPointPemain([Pemain|Sisa]):-
    simpan_kartu_pemain(Pemain, Indeks),
    showPointPemain(Pemain, Indeks),
    format(' ~n', []),
    showallPointPemain(Sisa).

printPemain([], _).
printPemain([[Skor, _JK, Nama]|Sisa], W):-
    format('~w. ~w (~w poin)~n', [W, Nama, Skor]),
    W1 is W+1,
    printPemain(Sisa, W1).
    
endGame:-
    simpan_kartu_pemain(Pemenang, []),
    urutan_pemain(Urut),
    format('Permainan selesai! ~w menghabiskan semua kartunya!~n', [Pemenang]),
    format('Berikut perhitungan poin sisa kartu~n', []),
    showallPointPemain(Urut),
    listSkor(Urut, List),
    urutkan_peringkat(List, Hasil),
    printPemain(Hasil, 1),
    format('Selamat, ~w menjadi pemenang!', [Pemenang]).