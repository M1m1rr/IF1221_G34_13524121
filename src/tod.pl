% Load file utama (pastikan nama file sesuai)
:- include('main.pl').
:- include('mainKartu.pl').

% --- SETUP DATA DUMMY ---
% Setup state awal agar fungsi bisa berjalan
setup_test :-
    retractall(urutan_pemain(_)),
    retractall(simpan_kartu_pemain(_,_)),
    retractall(discard_pile(_)),
    
    assertz(urutan_pemain([pemain1, pemain2])),
    assertz(simpan_kartu_pemain(pemain1, [kartu(merah, wild_draw_four), kartu(biru, reverse), kartu(biru, draw_two)])),
    assertz(discard_pile(kartu(biru, angka(0)))),
    assertz(kartu_efek(kartu(merah, skip))).

% --- KUMPULAN TEST ---

% Tes fungsi cocok
test_cocok :-
    (cocok(kartu(merah, angka(5)), kartu(merah, angka(0))) -> write('Test Cocok: OK'), nl ; write('Test Cocok: GAGAL'), nl).

% Tes fungsi mainkanKartu (indeks 2 = kartu skip)
test_mainkan_kartu :-
    setup_test,
    write('Menjalankan mainkanKartu(2)...'), nl,
    (mainkanKartu(2) -> write('Test MainkanKartu: OK'), nl ; write('Test MainkanKartu: GAGAL'), nl),
    listing(discard_pile).

% Tes fungsi efek mimic
test_mimic :-
    setup_test,
    write('Menjalankan Mimic...'), nl,
    % Indeks 3 adalah mimic
    (mainkanKartu(3) -> write('Test Mimic: OK'), nl ; write('Test Mimic: GAGAL'), nl).