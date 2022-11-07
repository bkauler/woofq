/* Barry Kauler 2021 bkhome.org License: GPLv2
 * based upon code found here:
 * https://stackoverflow.com/questions/17518610/how-to-get-a-screen-pixels-color-in-x11 
 * optional, "x y" coordinates on commandline, will return pixel colour.
 * without commandline coords, will return colour at 10,10 coords.
 * how to compile:
 *  cc -o getpixelcolor getpixelcolor.c `pkg-config --libs --cflags x11`
 * um, this is enough:
 *  cc -o getpixelcolor getpixelcolor.c -lX11
*/

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    XColor c;
    Display *d = XOpenDisplay((char *) NULL);
    if (d == NULL) { return 1; }

    int x=10;  // Pixel x 
    int y=10;  // Pixel y

    if (argc==3) {
        x=atoi(argv[1]);
        y=atoi(argv[2]);
    }

    XImage *image;
    image = XGetImage (d, XRootWindow (d, XDefaultScreen (d)), x, y, 1, 1, AllPlanes, XYPixmap);
    if (image == NULL) {
        XCloseDisplay(d);
        return 2;
    }
    
    c.pixel = XGetPixel (image, 0, 0);
    XFree (image);
    XQueryColor (d, XDefaultColormap(d, XDefaultScreen (d)), &c);
    
    XCloseDisplay(d);
    
    //print colour of pixel in format #rrggbb
    printf("#%06X\n", c.pixel);
    fflush(stdout);

    return 0;
}
