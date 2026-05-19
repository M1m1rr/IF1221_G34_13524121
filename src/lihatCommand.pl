cek_kartu_cocok([], _) :- fail.
cek_kartu_cocok([KepalaKartu | _], KartuMeja) :-
    cocok(KepalaKartu, KartuMeja), !.
cek_kartu_cocok([_ | EkorKartu], KartuMeja) :-
    cek_kartu_cocok(EkorKartu, KartuMeja).

lihatCommand :-
    status_game(terkena_draw_four), !,
    write('Aksi utama yang tersedia:'), nl,
    write('1. ambilKartu'), nl,
    write('2. tantang'), nl, nl,
    aksi_pendukung.

lihatCommand :-
    status_game(terkena_draw_two), !,
    write('Aksi utama yang tersedia:'), nl,
    write('1. ambilKartu'), nl, nl,
    aksi_pendukung.

lihatCommand :-
    status_game(normal),
    urutan_pemain([PemainAktif | _]),
    simpan_kartu_pemain(PemainAktif, ListKartuTangan),
    discard_pile(KartuMeja),
    cek_kartu_cocok(ListKartuTangan, KartuMeja), !,
    write('Aksi utama yang tersedia:'), nl,
    write('1. mainkanKartu(NomorUrutKartuDiTangan)'), nl,
    write('2. ambilKartu'), nl,
    write('3. uni(NomorUrutKartuDiTangan)'), nl,
    write('4. tangkap(NamaPemain)'), nl, nl,
    aksi_pendukung.

lihatCommand :-
    status_game(normal), !,
    write('Aksi utama yang tersedia:'), nl,
    write('1. ambilKartu'), nl, 
    write('2. tangkap(NamaPemain)'), nl, nl,
    aksi_pendukung.

aksi_pendukung :-
    write('Aksi pendukung yang tersedia:'), nl,
    write('1. lihatCommand'), nl,
    write('2. lihatKartu'), nl,
    write('3. cekInfo'), nl.
