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


validasi_jumlah1(N, N) :- N >= 1, N =< 2, !.
validasi_jumlah1(_, ValidN) :-
    write('No, No, No'), nl,
    write('MODE CUMAN ADA 2'), nl,
    write('Masukkan Mode apa: '),
    read(Baru), validasi_jumlah1(Baru, ValidN).



bagitim([],[], []).
bagitim([Pemain], [Pemain], []).
bagitim([Pemain1, Pemain2| Sisa], [Pemain1|Sisa1], [Pemain2|Sisa2]):-
    bagitim(Sisa,Sisa1, Sisa2).

jika_turnamen(2):-
    urutan_pemain(DaftarAcak),
    bagitim(DaftarAcak, Tim1, Tim2),
    infoteam(DaftarAcak),
    write('Membentuk tim secara acak...'), nl,
    assertz(team1(Tim1)),
    assertz(team2(Tim2)),
    format('Tim 1: ~w ~n', [Tim1]),
    format('Tim 2: ~w ~n', [Tim2]).
    


jika_turnamen(1):- !.

 infoteam([]).
 infoteam([Pemain]):-
    assertz(tim(Pemain, team1)).

infoteam([Pemain1, Pemain2|Sisa]):-
    assertz(tim(Pemain1, team1)),
    assertz(tim(Pemain2, team2)),
    infoteam(Sisa).

tulis_semua_tim([]).
tulis_semua_tim([Pemain | Sisa]) :-
    (tim(Pemain, Tim) ->
        write('tim('), writeq(Pemain), write('):'), writeq(Tim), write('.'), nl
    ;
        true
    ),
    tulis_semua_tim(Sisa).