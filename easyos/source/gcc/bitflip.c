// ref: https://unix.stackexchange.com/questions/104585/bit-wise-complement-with-dd
// pipe in and pipe out. flips every bit.

#include <stdio.h>
#include <unistd.h>
#include <inttypes.h>

#define BUFSZ 4096

int main (void) {
    unsigned char buffer[BUFSZ];
    int i, check;
    uint64_t total = 0;

    while ((check = read(0, buffer, BUFSZ)) > 0) {
        for (i = 0; i < check; i++) buffer[i] = ~buffer[i];
        write(1, buffer, check);
        total += check;
    }

    fprintf(stderr, "bitflip processed %lu bytes.\n", total);
    return 0;
}
