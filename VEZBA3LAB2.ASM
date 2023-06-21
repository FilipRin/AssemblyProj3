! inicijalizacija simulacije
onkp false, x.1, x.1
kpreg 1.1, r0, x.a
kpreg 1.1, r1, x.11
kpreg 1.1, r2, x.53
kpreg 1.1, r3, x.22
kpreg 1.1, r4, x.24
kpreg 1.1, r5, x.23
kpreg 1.1, r6, x.ad
kpreg 1.1, r7, x.78
kpreg 1.1, r8, x.35
kpreg 1.1, r9, x.12
kpreg 1.1, ra, x.64
reg pc, x.100
reg ivtp, x.0
dc x.2000, x.1
kpreg 1.1, interrupt, x.1
! kraj inicijalizacije

! resenje
! glavni program
org x.100
ldimm x.1, ra 	! fleg da li se radi o ulazu ili izlazu (1 ulaz, 0 izlaz)

! startovanje KP1
clr rb		! fleg da li je primljena velicina niza
ldimm x.1000, r5	! u r5 pokazivac na niz
clr rc		! semafor, da li je primljen niz
ldimm x.f, r1 	! u r1 konstanta za starovanje KP1
stmem x.f100, r1 	! upis u kontrolni registar KP1

ldimm x.1, rd	
wait1: cmp rc, rd	! ceka se da se primi niz
bneq wait1

! priprema steka za poziv funkcije max(int* array, int size)
! parametri sa desna na levo se stavljaju na stek
push rf
ldimm x.1000, r0
push r0
! poziv funkcije
jsr max
! nakon poziva funkcije ocistiti stek od argumenata
pop rc
pop rc	! sa steka su skinuta dva argumenta

clr rc		! semafor, da li je poslat najveci element
clr ra		! fleg da se sada radi o izlazu
ldimm x.2, r4	! broj podataka za slanje uvecan za 1
ldimm x.e, r1 	! u r1 konstanta za starovanje KP1
stmem x.f100, r1 	! upis u kontrolni registar KP1

ldimm x.1, rd	
wait2: cmp rc, rd	! ceka se da se posalje najveci element
bneq wait2

! kraj glavnog programa
halt

! funkcija int max(int* array, int size)
! pre poziva na steku se moraju postaviti parametri funkcije sa desna na levo
max:
! cuvaju se registri koji se menjaju
push r4		! koristi se r4 kao bazni registar
mvrpl r4, sp	! u r4 sp, na steku imamo sada
			! r4, retPC, array i size
			
push r1		! koristi se r1 
push r2		! koristi se r2
push r3		! koristi se r3

ldrid [r4]x.2, r1	! r4 + 2 je adresa na kojoj se nalazi argument array, r1 = array
ldrid [r4]x.3, r2 ! r4 + 3 je adresa na kojoj se nalazi argument size, r2 = size

ldrid [r1]x.0, r0	! u r0 se cuva najveci element
loop:
inc r1		! prelazi se na sledeci element
dec r2		! smanjuje se brojac
beql izadji		! proslo se kroz ceo niz
ldrid [r1]x.0, r3	! u r3 naredni element
cmp r0, r3		
blss noviMax	! nadjen je veci element
jmp loop		! nazad na ispitivanje sledeceg elementa

noviMax:
mvrrl r0, r3	! u r0 upisuje novi najveci element iz r3
jmp loop		! nazad na ispitivanje sledeceg elementa

! izlaz iz funkcije
izadji:
			! u obrnutom redosledu skidamo registre
pop r3
pop r2
pop r1
pop r4
rts


! prekidna rutina KP1
org x.2000
			! neke registre koji se menjaju u prekidnoj rutini, a potrebni su i van nje cuvati na steku
push r0		! koristi se kao pomocni registar pa se cuva na steku
ldimm x.1, r0
cmp ra, r0		! da li se radi ulaz ili izlaz
bneq izlaz		! radi se o izlazu

! ulaz
cmp rb, r0		! da li je primljena velicina niza
beql primiElement	! skoci na prijem sledeceg elementa
! primanje velicine niza
ldmem x.f103, r4	! broj elemenata niza u r4, sluzi kao brojac
mvrrl rf, r4	! u rf se cuva velicina niza, bice potrebna kada se poziva funkcija max
inc r4		! brojac uvecan za 1
ldimm x.1, rb	! rb na vrednost 1 jer je primljena velicina niza
jmp kraj
! prijem elemenata
primiElement:
dec r4		! smanjuje se brojac
beql iskljuci	! svi elementi su primljeni, iskljucuje se periferija
ldmem x.f103, r0	! citanje jednog elementa
stri [r5], r0	! smestanje elementa u memoriju
inc r5		! povecavanje pokazivaca
jmp kraj		! skok na povratak iz prekidne rutine

! izlaz
izlaz:
dec r4		! smanjimo brojac
beql iskljuci	! ako je poslat podatak
pop r0		! na pocetku je registar r0 stavljen na stek
stmem x.f103, r0	! salje se periferiji najveci element
push r0		! vratimo r0 jer se na kraju skida sa steka
jmp kraj		! skok na kraj

! iskljucivanje KP1
iskljuci:
stmem x.f100, r4	! u r4 je nula pa se koristi za iskljucivanje KP1
ldimm x.1, rc	! postavlja se semafor, prenos zavrsen

! kraj
kraj: pop r0
rti
