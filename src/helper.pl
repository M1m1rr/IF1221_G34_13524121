hitung_elemen([], 0).
hitung_elemen([_|Tail], Jumlah) :-
    hitung_elemen(Tail, Jumlah_Sisa),
    Jumlah is Jumlah_Sisa + 1.



cari_kartu_ke(1, [H|_], H) :- !.
cari_kartu_ke(Index, [_|T], Hasil) :-
    Index > 1,
    IndexSisa is Index - 1,
    cari_kartu_ke(IndexSisa, T, Hasil).

hapus_kartu(X, [X|T], T) :- !.
hapus_kartu(X, [H|T], [H|T1]) :-
    hapus_kartu(X, T, T1).