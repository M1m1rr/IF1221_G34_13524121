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


/*helper buat anunya anu saveload*/
gabung_list([], L, L).
gabung_list([H|T], L, [H|GabungT]) :-
    gabung_list(T, L, GabungT).

tambah_txt(NamaLama, NamaBaru) :-
    name(NamaLama, ListLama),
    name('.txt', ListTxt),
    gabung_list(ListLama, ListTxt, ListGabung),
    name(NamaBaru, ListGabung).

konversi_kartu_ke_format(kartu(W, angka(X)), Hasil) :- Hasil = W-X, !.
konversi_kartu_ke_format(kartu(W, Tipe), Hasil) :- Hasil = W-Tipe.


format_ke_kartu(W-X, kartu(W, angka(X))) :- integer(X), !.
format_ke_kartu(W-Tipe, kartu(W, Tipe)).

ubah_list_kartu([], []).
ubah_list_kartu([Kartu|T], [Format|FormatT]) :-
    konversi_kartu_ke_format(Kartu, Format),
    ubah_list_kartu(T, FormatT).

kembalikan_list_kartu([], []).
kembalikan_list_kartu([Format|T], [Kartu|KartuT]) :-
    format_ke_kartu(Format, Kartu),
    kembalikan_list_kartu(T, KartuT).