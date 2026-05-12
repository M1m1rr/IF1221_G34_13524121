/* ==========        Rules       ========== */

/* ==========   1. Start Game    ========== */

startGame :-
    write('======================================='), nl,
    write('======== Anu Uni Anukan Uninya ========'), nl,
    write('======================================='), nl,

    write('Masukkan jumlah player: '),
    read(N),
    /* CEK KONDISI NAMA SAMA ATAU KURANG/LEBIH DARI NPLAYER NANTI DISINI */
    inputPlayerkeN(N),

    write('======================================='), nl,
    write('==========   Game Starts!    ==========').


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
:- dynamic(pemain/1).
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

