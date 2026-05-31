tangkap(Target) :-
    urutan_pemain([Penuduh | _]),
    ( Penuduh == Target ->
        write('apa coba?'), nl
    ; \+ simpan_kartu_pemain(Target, _) ->
        format('~w ga ikut main wo ~n', [Target])
    ; 
        proses_tangkap(Penuduh, Target)
    ).

proses_tangkap(Penuduh, Target) :-
    simpan_kartu_pemain(Target, TanganVisible),
    panjang(TanganVisible, L),
    
    (L == 1 ->
        (kartu_tersembunyi(Target, ListSembunyi), ListSembunyi \= [] ->
            format('Ada kartu yang disembunyikan oleh ~w!~n', [Target]),
            format('Aowkaowkoakw ~w salah tangkap! dapat 1 kartu penalti.~n', [Penuduh]),
            drawN(Penuduh, 1, _)
        ; status_UNI(Target, lupa_uni) ->
            format('Tangkap! ~w tertangkap belum UNI!~n', [Target]),
            format('~w dapat 2 kartu penalti.~n~n', [Target]),
            drawN(Target, 2, _),
            retractall(status_UNI(Target, _)) 
        ;
            format('Aowkawokaowk ~w sudah UNI!~n', [Target]),
            format('~w dapat 1 kartu penalti!~n', [Penuduh]),
            drawN(Penuduh, 1, _)
        )
    ;
        format('Gagal! ~w masih punya lebih dari 1 kartu!~n', [Target])
    ).