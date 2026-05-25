:- include('endGame.pl').
:- include('helper.pl').
:- dynamic(urutan_pemain/1).
:- dynamic(simpan_kartu_pemain/2).

run_test :-
    % 1. Bersihkan data memori
    retractall(urutan_pemain(_)),
    retractall(simpan_kartu_pemain(_, _)),

    % 2. Set urutan pemain
    assertz(urutan_pemain([adinda, william, razi])),

    % 3. Set kartu William (biru-3 dan hijau-2)
    

    % 4. Set kartu Adinda (kosong)
    assertz(simpan_kartu_pemain(adinda, [])),
    assertz(simpan_kartu_pemain(william, [kartu(biru, angka(3)), kartu(hijau, angka(2))])),
    % 5. Set kartu Razi
    assertz(simpan_kartu_pemain(razi, [kartu(biru, angka(3))])),
    endGame.