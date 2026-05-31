saveGame :-
    efek_aktif(Efek),
    Efek \= none, !,
    write('Unable!.'), nl,
    write('Selesaikan dulu efek kartu sebelumnya!!!.'), nl.

saveGame :-
    write('Save file name: '),
    read(InputName),
    tambah_txt(InputName, FileName),
    tell(FileName),
    mode_main(Mode),
    write('mode_main:'), writeq(Mode), write('.'), nl,
    (Mode =:= 2 ->
        (team1(Tim1) -> write('team1:'), writeq(Tim1), write('.'), nl ; true),
        (team2(Tim2) -> write('team2:'), writeq(Tim2), write('.'), nl ; true),
        urutan_pemain(UrutanPemain),
        tulis_semua_tim(UrutanPemain)
    ; 
        true 
    ),
    urutan_pemain(Urutan),
    write('urutan_pemain:'), writeq(Urutan), write('.'), nl,
    Urutan = [Giliran | _],
    write('giliran:'), writeq(Giliran), write('.'), nl,
    discard_pile(DiscardTop),
    konversi_kartu_ke_format(DiscardTop, DiscardFormat),
    write('discard_top:'), writeq(DiscardFormat), write('.'), nl,
    DiscardTop = kartu(WarnaAktif, _),
    write('warna_aktif:'), writeq(WarnaAktif), write('.'), nl,
    sisa_deck(Deck),
    ubah_list_kartu(Deck, DeckFormat),
    write('sisa_deck:'), writeq(DeckFormat), write('.'), nl,
    seed(Seed),
    write('seed:'), writeq(Seed), write('.'), nl,
    arah(Arah),
    write('arah_permainan:'), writeq(Arah), write('.'), nl,
    write('status_UNI:[].'), nl,
    tulis_semua_kartu(Urutan),
    /*write('data kartu tersembunyi: '), nl, */
    tulis_semua_kartu_tersembunyi(Urutan),
    told, 
    format('Saved to ~w.~n !', [FileName]).

tulis_semua_kartu([]).
tulis_semua_kartu([Pemain | Sisa]) :-
    simpan_kartu_pemain(Pemain, ListKartu),
    ubah_list_kartu(ListKartu, ListFormat),
    write('kartu('), writeq(Pemain), write('):'), writeq(ListFormat), write('.'), nl,
    tulis_semua_kartu(Sisa).

tulis_semua_kartu_tersembunyi([]).
tulis_semua_kartu_tersembunyi([Pemain | Sisa]) :-
    (kartu_tersembunyi(Pemain, ListSembunyi) ->
        ubah_list_kartu(ListSembunyi, ListFormat)
    ;
        ListFormat = []
    ),
    write('sembunyi('), writeq(Pemain), write('):'), writeq(ListFormat), write('.'), nl,
    tulis_semua_kartu_tersembunyi(Sisa).

loadGame :-
    write('Input save file name: '),
    read(InputName),
    tambah_txt(InputName, FileName),
    
    ( file_exists(FileName) -> 
        mulai_load(FileName)
    ; 
        write('404 not Found!'), nl
    ).

mulai_load(FileName) :-
    see(FileName),    
    retractall(urutan_pemain(_)),
    retractall(discard_pile(_)),
    retractall(arah(_)),
    retractall(simpan_kartu_pemain(_, _)),
    retractall(kartu_tersembunyi(_, _)),
    retractall(mode_main(_)),
    retractall(team1(_)),
    retractall(team2(_)),
    retractall(tim(_, _)),
    baca_file_state,
    seen,
    retractall(efek_aktif(_)),
    assertz(efek_aktif(none)),

    format('Loaded from ~w.~n', [FileName]),
    urutan_pemain([GiliranSaatIni | _]),
    format('Melanjutkan giliran ~w.~n !', [GiliranSaatIni]).

baca_file_state :-
    read(Term),
    proses_term(Term).

proses_term(end_of_file) :- !. 
proses_term(Term) :-
    proses_state(Term),
    baca_file_state.


proses_state(urutan_pemain : ListUrutan) :- assertz(urutan_pemain(ListUrutan)).
proses_state(giliran : _) :- true.
proses_state(discard_top : KartuFormat) :- 
    format_ke_kartu(KartuFormat, Kartu),
    assertz(discard_pile(Kartu)).
proses_state(warna_aktif : _) :- true.
proses_state(arah_permainan : Arah) :- assertz(arah(Arah)).
proses_state(status_UNI : _) :- true.
proses_state(kartu(Pemain) : ListFormat) :- 
    kembalikan_list_kartu(ListFormat, ListKartu),
    assertz(simpan_kartu_pemain(Pemain, ListKartu)).
proses_state(mode_main : Mode) :- 
    assertz(mode_main(Mode)).
proses_state(team1 : ListTeam1) :- 
    assertz(team1(ListTeam1)).
proses_state(team2 : ListTeam2) :- 
    assertz(team2(ListTeam2)).
proses_state(tim(Pemain) : Tim) :- 
    assertz(tim(Pemain, Tim)).
proses_state(_) :- true.

/*buat hide card y*/
proses_state(sembunyi(Pemain) : ListFormat) :- 
    kembalikan_list_kartu(ListFormat, ListKartu),
    assertz(kartu_tersembunyi(Pemain, ListKartu)).