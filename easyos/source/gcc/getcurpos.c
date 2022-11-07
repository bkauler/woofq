/*
   Print the current coordinates of the mouse pointer to stdout

   Copyright (C) 2007 by Robert Manea  <rob dot manea at gmail dot com>

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
   */


#include<stdio.h>
#include<stdlib.h>
#include<X11/Xlib.h>

int main(int argc, char *argv[])
{
	XEvent e;
	Display *d = XOpenDisplay(NULL);

	if(!d)
		return EXIT_FAILURE;

	/* get info about current pointer position */
	XQueryPointer(d, RootWindow(d, DefaultScreen(d)),
			&e.xbutton.root, &e.xbutton.window,
			&e.xbutton.x_root, &e.xbutton.y_root,
			&e.xbutton.x, &e.xbutton.y,
			&e.xbutton.state);

	printf("%d %d\n", e.xbutton.x, e.xbutton.y);

	XCloseDisplay(d);

	return EXIT_SUCCESS;
}

