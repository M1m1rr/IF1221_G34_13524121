/* ==========        Rules       ========== */
:- dynamic(data_pemain/1).
:- dynamic(seed/1).
:- dynamic(urutan_pemain/1).

seed(123456789). 

startGame :-
    retractall(data_pemain(_)),
    retractall(seed(_)), assertz(seed(123456789)),
    retractall(urutan_pemain(_)),

    write('======================================='), nl,
    write('======== Anu Uni Anukan Uninya ========'), nl,
    write('======================================='), nl,

    write('======================================='), nl,
    write('==========   Game Starts!    =========='),nl,nl,
    
    write('Masukkan jumlah pemain (2-4): '),
    read(N),
    validasi_jumlah(N, ValidN),
    input_pemain(1, ValidN), nl,
    pindahkan_ke_list(DaftarAsli),
    acak_pemain(DaftarAsli, DaftarAcak),
    assertz(urutan_pemain(DaftarAcak)),
    
    DaftarAcak = [PemainPertama|_],
    write('Urutan pemain: '), nl,
    tampilkan_pemain(DaftarAcak), nl,

    temp_kartu,
    kumpulkan_deck(DeckAwal),

    write('--- Membagikan Kartu ---'), nl, 
    bagikan_kartu(DaftarAcak, DeckAwal, DeckSisaSetelahBagi),

    discard_pile(DeckSisaSetelahBagi, DiscardAwal, DeckFinal),
    format('Kartu di meja (Discard Pile): ~w', [DiscardAwal]), nl,
    panjang(DeckFinal, SisaTotal),
    format('Sisa kartu di dalam deck: ~d', [SisaTotal]), nl,nl,

    format('Giliran ~w', [PemainPertama]), nl, nl,
    
    write('1 '), write('2 '), write('3 . . .'), nl,
    write('U  N  I !!!'), !.

panjang([], 0).
% Jika ada isi, hitung ekornya (T) lalu tambah 1
panjang([_|T], L) :-
    panjang(T, L_Sisa),
    L is L_Sisa + 1.

lcg(Max, Index) :-
    retract(seed(OldSeed)),
    NextSeed is (1103515245 * OldSeed + 10001) mod 2147483647,
    assertz(seed(NextSeed)),
    Index is NextSeed mod Max.

/*pemain*/
acak_pemain([], []).
acak_pemain(Asli, [Terpilih|SisaAcak]) :-
    panjang(Asli, L),
    lcg(L, Indeks),
    ambil_elemen(Indeks, Asli, Terpilih, SisaAsli),
    acak_pemain(SisaAsli, SisaAcak).

ambil_elemen(0, [H|T], H, T) :- !.
ambil_elemen(I, [H|T], Terpilih, [H|Sisa]) :-
    I1 is I - 1,
    ambil_elemen(I1, T, Terpilih, Sisa).

pindahkan_ke_list([]) :- \+ data_pemain(_), !.
pindahkan_ke_list([Nama|Sisa]) :-
    retract(data_pemain(Nama)),
    pindahkan_ke_list(Sisa).

validasi_jumlah(N, N) :- N >= 2, N =< 4, !.
validasi_jumlah(_, ValidN) :-
    write('No, No, No'), nl,
    write('Permainan hanya terdiri dari 2-4 pemain!'), nl,
    write('Masukkan jumlah pemain (2-4): '),
    read(Baru), validasi_jumlah(Baru, ValidN).

input_pemain(I, N) :- I > N, !.
input_pemain(I, N) :-
    format('Siapa pemain ke-~d: ', [I]),
    read(Nama),
    (data_pemain(Nama) ->  write('Hmm, setiap pemain harus berbeda. Ulangi!'), nl, input_pemain(I, N) 
    ; 
    assertz(data_pemain(Nama)), 
    I1 is I + 1, 
    input_pemain(I1, N)).

tampilkan_pemain([]).
tampilkan_pemain([H|T]) :-
    format('~w ', [H]), nl,
    tampilkan_pemain(T).

tampilkan_giliran([]).

/*kartu*/
temp_kartu :-
    kartu(W, K),
    assertz(temp_deck(W, K)), fail.
temp_kartu.

kumpulkan_deck([]) :- \+ temp_deck(_, _), !.
kumpulkan_deck([kartu(W, K)|Sisa]) :-
    retract(temp_deck(W, K)),
    kumpulkan_deck(Sisa).

tujuh_kartu(0, Deck, [], Deck) :- !.
tujuh_kartu(N, DeckIn, [Kartu|SisaTangan], DeckOut) :-
    panjang(DeckIn, L),
    lcg(L, Indeks),
    ambil_elemen(Indeks, DeckIn, Kartu, DeckSisa),
    N1 is N - 1,
    tujuh_kartu(N1, DeckSisa, SisaTangan, DeckOut).

bagikan_kartu([], Deck, Deck).
bagikan_kartu([Pemain|SisaPemain], DeckLama, DeckFinal) :-
    tujuh_kartu(7, DeckLama, ListKartu, DeckBaru),
    assertz(simpan_kartu_pemain(Pemain, ListKartu)),
    format('Daftar kartu ~w : ~w', [Pemain, ListKartu]), nl, nl,
    bagikan_kartu(SisaPemain, DeckBaru, DeckFinal).

/*DAFTAR KARTU YANG TIDAK BOLEH JADI KARTU AWAL*/
is_aksi(skip).
is_aksi(reverse).
is_aksi(draw_two).
is_aksi(wild).
is_aksi(draw_four).
is_aksi(mimic).

discard_pile(DeckLama, KartuTerbuang, DeckBaru) :-
    panjang(DeckLama, L),
    lcg(L, Indeks),
    ambil_elemen(Indeks, DeckLama, kartu(Warna, Tipe), DeckSisa),
    (is_aksi(Tipe) -> write('Kartu discard yang terambil top adalah kartu aksi, mengambil ulang...'), nl,
    discard_pile([kartu(Warna, Tipe)|DeckSisa], KartuTerbuang, DeckBaru)
    ;   
    KartuTerbuang = kartu(Warna, Tipe),
    DeckBaru = DeckSisa,
    assertz(discard_pile(KartuTerbuang))).

/* ==========        Turn       ========== */

mainkanKartu :-
    write('Kartu dimainkan!').

ambilKartu :-
    write('Kartu diambil!').

tantang :-
    format('~w ditantang!', []).

uni :-
    write('Uni!').

tangkap :-
    write('tangkap').

/* ==========     Misc       ========== */

lihatCommand :-
    write('Tersedia: anukan').

lihatKartu :-
    write('Belum nyampe').

cekInfo :-
    write('cemara menderai sampai jauh').

/* ==========     End Game    ========== */

saveGame :-
    write('Saved!').

loadGame :-
    write('Loaded!').

/* ==========        Facts      ========== */

kartu(merah, angka(0)).
kartu(merah, angka(1)).
kartu(merah, angka(2)).
kartu(merah, angka(3)).
kartu(merah, angka(4)).
kartu(merah, angka(5)).
kartu(merah, angka(6)).
kartu(merah, angka(7)).
kartu(merah, angka(8)).
kartu(merah, angka(9)).

kartu(kuning, angka(0)).
kartu(kuning, angka(1)).
kartu(kuning, angka(2)).
kartu(kuning, angka(3)).
kartu(kuning, angka(4)).
kartu(kuning, angka(5)).
kartu(kuning, angka(6)).
kartu(kuning, angka(7)).
kartu(kuning, angka(8)).
kartu(kuning, angka(9)).

kartu(hijau, angka(0)).
kartu(hijau, angka(1)).
kartu(hijau, angka(2)).
kartu(hijau, angka(3)).
kartu(hijau, angka(4)).
kartu(hijau, angka(5)).
kartu(hijau, angka(6)).
kartu(hijau, angka(7)).
kartu(hijau, angka(8)).
kartu(hijau, angka(9)).

kartu(biru, angka(0)).
kartu(biru, angka(1)).
kartu(biru, angka(2)).
kartu(biru, angka(3)).
kartu(biru, angka(4)).
kartu(biru, angka(5)).
kartu(biru, angka(6)).
kartu(biru, angka(7)).
kartu(biru, angka(8)).
kartu(biru, angka(9)).

kartu(merah, skip).
kartu(kuning, skip).
kartu(hijau, skip).
kartu(biru, skip).

kartu(merah, reverse).
kartu(kuning, reverse).
kartu(hijau, reverse).
kartu(biru, reverse).

kartu(merah, draw_two).
kartu(kuning, draw_two).
kartu(hijau, draw_two).
kartu(biru, draw_two).

kartu(hitam, wild).
kartu(hitam, draw_four).
