# AssemblyProj3
C++ function as assembly code: int max(int* array, int size)  
------------------------------------------------------------
ENG
- Write a program that loads an array from the KP1 peripheral using the interrupt mechanism. You need a string
place in memory starting from address 1000h. The peripheral first sends the number of array elements (array size),
and after that the elements. After receiving, it is necessary to call the function int max(int* array, int
size), the first parameter is the address of the array, and the second is the number of elements in the array. The return value of the function is
the largest number in the sequence. The function leaves the return value in register R0. After calling the function max
the largest element should be sent to the peripheral KP1
In addition to the main program, it is necessary to write an interrupt routine corresponding to the peripheral KP1 and
function max.
- The main program should be placed starting from address 100h, and the interrupt routine from address 2000h.
The table of interrupt routines has already been loaded into memory, and the KP1 peripheral has already been assigned the number of inputs inside
entry to the register

SRB
- Napisati program koji učitava niz sa periferije KP1 korišćenjem mehanizma prekida. Niz treba
smestiti u memoriju počev od adrese 1000h. Periferija prvo šalje broj elemenata niza (veličinu niza),
a nakon toga elemente. Nakon prijema potrebno je pozvati funkciju int max(int* array, int
size), prvi parametar je adresa niza, a drugi broj elemenata u nizu. Povratna vrednost funkcije je
najveći broj u nizu. Povratnu vrednost funkcija ostavlja u registru R0. Nakon poziva funkcije max
treba poslati najveći element periferiji KP1
Pored glavnog programa, potrebno je napisati prekidnu rutinu koja odgovara periferiji KP1 i
funkciju max.
- Glavni program treba smestiti počev od adrese 100h, a prekidnu rutinu od adrese 2000h.
Tabela prekidnih rutina je već učitana u memoriju, a periferiji KP1 je već postavljen broj ulaza unutar
entry registru
