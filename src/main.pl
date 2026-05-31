/* ==========        Rules       ========== */

:- include('ambilKartu.pl').
:- include('lihatKartu.pl').
:- include('lihatCommand.pl').
:- include('cekInfo.pl').
:- include('mainKartu.pl').
:- include('tantang.pl').
:- include('uni.pl').
:- include('endGame.pl').
:- include('helper.pl').
:- include('gameSaveLoad.pl').
:- include('godsHand.pl').
:- include('sembunyiKartu.pl').
:- include('swapKartu.pl').

/* ==========   1. Start Game    ========== */

startGame :-
    retractall(data_pemain(_)),
    random(67676767, 78787878, SeedAcak),
    retractall(seed(_)), assertz(seed(SeedAcak)),
    retractall(urutan_pemain(_)),
    asserta(status_game(normal)),
    retractall(status_UNI(_, _)),
    retractall(arah(_)), assertz(arah(kanan)),

    write('======================================='), nl,
    write('======== Anu Uni Anukan Uninya ========'), nl,
    write('======================================='), nl,

    write('======================================='), nl,
    write('==========   Game Start!     =========='),nl,nl,

    write('Ada 2 Mode permainan'), nl,
    write('1.Klasik'), nl,
    write('2.turnamen'), nl,
    read(Mode),
    validasi_jumlah1(Mode, ValidM),
    assertz(mode_main(ValidM)),
    format('permainan dimulai dalam Mode ~w ~n', [ValidM]),
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
    jika_turnamen(Mode),
  
    temp_kartu,
    kumpulkan_deck(Deck_urut),
    acak_deck(Deck_urut, Deck_acak),

    write('--- Membagikan Kartu ---'), nl, 
    bagikan_kartu(DaftarAcak, Deck_acak, DeckSisaSetelahBagi),

    discard_pile(DeckSisaSetelahBagi, DiscardAwal, DeckFinal),
    retractall(sisa_deck(_)),
    assertz(sisa_deck(DeckFinal)),
    retractall(efek_aktif(_)),
    assertz(efek_aktif(none)),
    format('Kartu di meja (Discard Pile): ~w', [DiscardAwal]), nl,
    panjang(DeckFinal, SisaTotal),
    format('Sisa kartu di dalam deck: ~d', [SisaTotal]), nl,nl,
    format('Giliran ~w, silahkan masukkan perintah!', [PemainPertama]), nl, !.

panjang([], 0).
panjang([_|T], L) :-
    panjang(T, L_Sisa),
    L is L_Sisa + 1.

lcg(Max, Index) :-
    retract(seed(OldSeed)),
    NextSeed is (19748448777 * OldSeed + 10001) mod 2147483647,
    assertz(seed(NextSeed)),
    Index is NextSeed mod Max.

acak_deck([], []).
acak_deck([Tunggal], [Tunggal]) :- !.
acak_deck(Asli, [Terpilih | SisaAcak]) :-
    panjang(Asli, L),
    lcg(L, Indeks),
    ambil_elemen(Indeks, Asli, Terpilih, SisaAsli),
    acak_deck(SisaAsli, SisaAcak).

/*pemain*/
acak_pemain([], []).
acak_pemain([Tunggal], [Tunggal]) :- !.
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
    (is_aksi(Tipe) -> write('Kartu discard top yang terambil adalah kartu aksi, mengambil ulang...'), nl,
    discard_pile([kartu(Warna, Tipe)|DeckSisa], KartuTerbuang, DeckBaru)
    ;   
    KartuTerbuang = kartu(Warna, Tipe),
    DeckBaru = DeckSisa,
    assertz(discard_pile(KartuTerbuang))).

append_element([], Element, Element).
append_element([Head|Tail], Element, [Head|NewTail]) :-
    append_element(Tail, Element, NewTail).

pisahkan_terakhir([X], X, []) :- !.
pisahkan_terakhir([H|T], Terakhir, [H|Sisa]) :-
    pisahkan_terakhir(T, Terakhir, Sisa).

peluang_godsHand :-
    lcg(100, Rnd),
    ( Rnd < 15 -> 
        godsHand
    ; 
        true 
    ).

giliran_berikutnya :-
    sisa_deck([]), !,
    write('Draw pile habis! Permainan berakhir dengan seri atau penentuan berdasarkan poin.'), nl,
    endGame.
giliran_berikutnya :-
    simpan_kartu_pemain(_, []), !,
    endGame.
giliran_berikutnya :-
    arah(kanan),
    retract(urutan_pemain([PemainSekarang | PemainLainnya])),    
    append_element(PemainLainnya, [PemainSekarang], UrutanBaru),
    assertz(urutan_pemain(UrutanBaru)),
    UrutanBaru = [PemainSelanjutnya | _],
    format('Giliran ~w telah selesai.', [PemainSekarang]), nl,
    format('Sekarang giliran: ~w!', [PemainSelanjutnya]), nl,
    peluang_godsHand, !.
    
giliran_berikutnya :-
    arah(kiri),
    retract(urutan_pemain(ListLama)),
    pisahkan_terakhir(ListLama, PemainSelanjutnya, SisaPemain),
    UrutanBaru = [PemainSelanjutnya | SisaPemain],
    assertz(urutan_pemain(UrutanBaru)),
    ListLama = [PemainSekarang | _],
    format('Giliran ~w telah selesai.', [PemainSekarang]), nl,
    format('Sekarang giliran: ~w!', [PemainSelanjutnya]), nl,
    peluang_godsHand,  !.

/* ==========        Turn       ========== */


/* ==========     Misc       ========== */

/* ==========   Buat Sendiri    ==========*/
inputPlayerkeN(0) :- !.
inputPlayerkeN(N) :-
    N > 0,
    format('Nama pemain ke-~w ', [N]),
    read(Nama),
    (pemain(Nama) -> 
        format('Hei ~w! main cuma bisa 1 kali!.~n~n', [Nama]),
        inputPlayerkeN(N)
    ; 
        assertz(pemain(Nama)),
        N1 is N - 1,
        inputPlayerkeN(N1)).

/* ==========       Dinamik     ========== */
:- dynamic(data_pemain/1).
:- dynamic(giliran/1).
:- dynamic(tangan/2).
:- dynamic(draw_pile/1).
:- dynamic(efek_aktif/1).
:- dynamic(status_game/1).
:- dynamic(urutan_pemain/1).
:- dynamic(seed/1).
:- dynamic(temp_deck/2).
:- dynamic(simpan_kartu_pemain/2).
:- dynamic(discard_pile/1).
:- dynamic(sisa_deck/1).
:- dynamic(format/1).
:- dynamic(kartu_efek/1).
:- dynamic(arah/1).
:- dynamic(status_UNI/1).
:- dynamic(kartu_tersembunyi/2).
:- dynamic(discard_sebelumnya/1).
:- dynamic(mode_main/1).
:- dynamic(team1/1).
:- dynamic(team2/1).
:- dynamic(tim/2).

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
kartu(hitam, wild_draw_four).
kartu(hitam, mimic).