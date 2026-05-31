kartu_aksi(kartu(_, skip)).
kartu_aksi(kartu(_, draw_two)).
kartu_aksi(kartu(_, wild_draw_four)).
kartu_aksi(kartu(_, reverse)).
kartu_aksi(kartu(_, wild)).

list_warna(X, [X|_]) :- !.
list_warna(X, [_|T]) :-
    list_warna(X, T).

ambil_kartu_ke_n(1, [Kepala | Ekor], Kepala, Ekor) :- !.
ambil_kartu_ke_n(Indeks, [Kepala | Ekor], KartuTerpilih, [Kepala | SisaKartu]) :-
    Indeks > 1,
    IndeksBerikutnya is Indeks - 1,
    ambil_kartu_ke_n(IndeksBerikutnya, Ekor, KartuTerpilih, SisaKartu).

cocok(kartu(Warna, _), kartu(Warna, _)) :- !.
cocok(kartu(_, Sama), kartu(_, Sama)):- !.
cocok(kartu(hitam, _), kartu(_, _)):-!.

efek(kartu(_, wild)):-
    write('Pilih warna baru (merah/kuning/hijau/biru): '),
    read(Input),
    (list_warna(Input, [merah, kuning, hijau, biru]) -> 
        Warna = Input,
        format('Warna diubah menjadi ~w.~n', [Warna])
    ; 
        write('Warna tidak valid!'), nl, efek(kartu(_, wild))
    ),
    retract(discard_pile(_)),
    assertz(discard_pile(kartu(Warna, wild))),
    giliran_berikutnya, !.

efek(kartu(_, skip)):-
    retractall(status_game(_)), assertz(status_game(normal)),
    arah(Arah),
    retract(urutan_pemain(UrutanLama)),
    (Arah == kanan ->
        UrutanLama = [PemainSekarang | PemainLainnya],
        append_element(PemainLainnya, [PemainSekarang], UrutanBaru)
    ;
        pisahkan_terakhir(UrutanLama, Terakhir, Sisa),
        UrutanBaru = [Terakhir | Sisa]
    ),
    assertz(urutan_pemain(UrutanBaru)),
    UrutanBaru = [PemainDiSkip | _],
    format('Pemain ~w kehilangan giliran!~n', [PemainDiSkip]),
    giliran_berikutnya, !.
/* aku rombak skip ya ucup*/

efek(kartu(_, draw_two)):-
    write('pemain berikutnya terkena draw 2.'), nl,
    retractall(status_game(_)), assertz(status_game(terkena_draw_two)),
    retractall(efek_aktif(_)),
    assertz(efek_aktif(draw_two)),
    giliran_berikutnya,!.
    
efek(kartu(_,wild_draw_four)):-
    write('pemain berikutnya terkena draw 4.'),nl,
    retractall(status_game(_)), assertz(status_game(terkena_draw_four)),
    retractall(efek_aktif(_)),
    assertz(efek_aktif(wild_draw_four)),
    write('Pilih warna baru (merah/kuning/hijau/biru): '),
    read(Input),
    (list_warna(Input, [merah, kuning, hijau, biru]) -> 
        Warna = Input,
        format('Warna diubah menjadi ~w.~n', [Warna])
    ; 
        write('Warna tidak valid!'), nl, efek(kartu(_, wild))
    ),
    retract(discard_pile(_)),
    assertz(discard_pile(kartu(Warna, wild_draw_four))),
    giliran_berikutnya, !.
efek(kartu(_,reverse)):-
    write('order pemain terbalik'), 
    (retract(arah(kanan)) -> 
        assertz(arah(kiri))
    ; 
        retract(arah(kiri)),
        assertz(arah(kanan))
    ),
    giliran_berikutnya, !.
   
efek(kartu(_, mimic)):-
    (kartu_efek(Kartu)->
        format('kartu mimic menyalin efek ~w.~n', [Kartu]),
        retract(discard_pile(_)),
        assertz(discard_pile(Kartu)),

        efek(Kartu)
    ;
        efek(kartu(hitam, wild))
    ).
    

efek(_):-
    retractall(status_game(_)), assertz(status_game(normal)),
    giliran_berikutnya,!
.
mainkanKartu(_) :-
    efek_aktif(Efek),
    (Efek== draw_two ; Efek == wild_draw_four),
    format('woi Lu kena efek ~w harus ambil kartu gabisa mainkan kartu~n', [Efek]), !.
mainkanKartu(Index) :-
    urutan_pemain([Pemain|_]),
    simpan_kartu_pemain(Pemain, Indekskartu),
    cari_kartu_ke(Index, Indekskartu, Kartupemain ), 
    discard_pile(Kartumeja),
    retractall(discard_sebelumnya(_)),
    assertz(discard_sebelumnya(Kartumeja)),
    cocok(Kartupemain, Kartumeja),
    (kartu_aksi(Kartupemain)->
        retractall(kartu_efek(_)),
        assertz(kartu_efek(Kartupemain))
    ;
        true
    ),
    hapus_kartu(Kartupemain, Indekskartu, Indekskartu1 ),
    retract(simpan_kartu_pemain(Pemain, Indekskartu)),
    assertz(simpan_kartu_pemain(Pemain, Indekskartu1)),
    retract(discard_pile(Kartumeja)),
    assertz(discard_pile(Kartupemain)),
    format('~w memainkan kartu: ~w.~n', [Pemain, Kartupemain]),
    efek(Kartupemain).