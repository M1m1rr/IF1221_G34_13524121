/*ini bonus ya woilah  */

sembunyikanKartu(NomorUrut) :-
    urutan_pemain([Pemain|_]),
    simpan_kartu_pemain(Pemain, Tangan),
    panjang(Tangan, L),
    (L =< 1 ->
        write('Unable!'), nl,
        write('Kamu cuma punya 1 kartu!')
    ;
        cari_kartu_ke(NomorUrut, Tangan, KartuTerpilih),
        hapus_kartu(KartuTerpilih, Tangan, TanganBaru),
        retract(simpan_kartu_pemain(Pemain, Tangan)),
        assertz(simpan_kartu_pemain(Pemain, TanganBaru)),
        ( kartu_tersembunyi(Pemain, ListSembunyi) ->
            retract(kartu_tersembunyi(Pemain, ListSembunyi)),
            ListBaru = [KartuTerpilih | ListSembunyi]
        ;
            ListBaru = [KartuTerpilih]
        ),
        assertz(kartu_tersembunyi(Pemain, ListBaru)),
        konversi_kartu_ke_format(KartuTerpilih, KartuFormat),
        format('Kartu ~w berhasil disembunyikan.~n', [KartuFormat])
    ).

tampilkanKartu :-
    urutan_pemain([Pemain|_]),
    ( kartu_tersembunyi(Pemain, ListSembunyi), ListSembunyi \= [] ->
        simpan_kartu_pemain(Pemain, TanganLama),
        gabung_list(ListSembunyi, TanganLama, TanganBaru),
        retract(simpan_kartu_pemain(Pemain, TanganLama)),
        assertz(simpan_kartu_pemain(Pemain, TanganBaru)),
        retract(kartu_tersembunyi(Pemain, ListSembunyi)),
        assertz(kartu_tersembunyi(Pemain, [])),
        
        write('Semua kartu tersembunyi ditampilkan ke hand!'), nl
    ;
        write('Kamu tidak punya kartu tersembunyi!'), nl
    ).


/* tambahin juga tangkepnya */



tangkap(Target) :-
    urutan_pemain([Penuduh | _]),
    (Penuduh == Target ->
        write('apa coba?'), nl
    ;
        data_pemain(Target) ->
            proses_tangkap(Penuduh, Target)
        ;
            format('~w gak ikut main wo ~n', [Target])
    ).

proses_tangkap(Penuduh, Target) :-
    simpan_kartu_pemain(Target, TanganVisible),
    panjang(TanganVisible, L),
    
    (L == 1 ->
        (kartu_tersembunyi(Target, ListSembunyi), ListSembunyi \= [] ->
            format('Ada kartu yang dihide ~w! ~n', [Target]),
            format('Awoaawokawok tangkap tidak valid! ~w dapat 1 kartu penalti.~n', [Penuduh]),
            drawN(Penuduh, 1, _)
        ;
            (status_UNI(ListUNI), cek_anggota(Target, ListUNI) ->
                format('~w udah UNI! ~n', [Target])
            ;
                format('Tangkap! awokoawkwaok ~w lupa UNI dan mendapat 2 kartu penalti!~n', [Target]),
                drawN(Target, 2, _)
            )
        )
    ;
        format('Tangkap gagal! ~w masih punya lebih dari 1 kartu di tangannya!~n', [Target])
    ).

cek_anggota(X, [X|_]) :- !.
cek_anggota(X, [_|T]) :- 
    cek_anggota(X, T).