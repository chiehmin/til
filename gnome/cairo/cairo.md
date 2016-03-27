# Cairo

[Tutorial](http://cairographics.org/tutorial/)
[Pycario tutorial](http://cairographics.org/pycairo/tutorial/)
[zetcode tutorial](http://zetcode.com/gfx/cairo/cairolib/)

Cairo is a library for creating 2D **vector graphics**.

## Nouns

* Context: holding all states related to a drawing
	* [Context methods](http://www.cairographics.org/manual/cairo-cairo-t.html)
* Source: the "paint" eg: pen, ink. Four kinds of basic sources: 
	* colors
	* gradients
	* patterns [pattern methods](http://www.cairographics.org/manual/cairo-cairo-pattern-t.html)
	* images.
* Mask: A filter
* Path: Like a mask. Paths can be made up of straight lines and curves.  
	* [Path methods](http://www.cairographics.org/manual/cairo-Paths.html)
* Surface: The destination we are drawing to

![overview](https://en.wikipedia.org/wiki/File:Cairo%27s_drawing_model.svg)

## Verbs


## Examples
```c
#include <cairo.h>

int main(void)
{
	cairo_surface_t *surface;
	cairo_t *cr;

	surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 390, 60);
	cr = cairo_create(surface);

	cairo_set_source_rgb(cr, 0, 0, 0);
	cairo_select_font_face(cr, "Sans", CAIRO_FONT_SLANT_NORMAL,
			CAIRO_FONT_WEIGHT_NORMAL);
	cairo_set_font_size(cr, 40.0);

	cairo_move_to(cr, 10.0, 50.0);
	cairo_show_text(cr, "Hello Cairo");

	cairo_surface_write_to_png(surface, "hello_cairo.png");

	cairo_destroy(cr);
	cairo_surface_destroy(surface);

	return 0;

}
```
```shell
$ gcc hello_cairo.c `pkg-config --cflags --libs gtk+-3.0`
$ ./a.out
$ eog hello_cairo.png
```

## GTK with cairo
```c
#include <cairo.h>
#include <gtk/gtk.h>

static void do_drawing(cairo_t *);

static gboolean on_draw_event(GtkWidget *widget, cairo_t *cr, 
    gpointer user_data)
{      
  do_drawing(cr);

  return FALSE;
}

static void do_drawing(cairo_t *cr)
{
  cairo_set_source_rgb(cr, 0, 0, 0);
  cairo_select_font_face(cr, "Sans", CAIRO_FONT_SLANT_NORMAL,
      CAIRO_FONT_WEIGHT_NORMAL);
  cairo_set_font_size(cr, 40.0);

  cairo_move_to(cr, 10.0, 50.0);
  cairo_show_text(cr, "Disziplin ist Macht.");    
}


int main(int argc, char *argv[])
{
  GtkWidget *window;
  GtkWidget *darea;

  gtk_init(&argc, &argv);

  window = gtk_window_new(GTK_WINDOW_TOPLEVEL);

  darea = gtk_drawing_area_new();
  gtk_container_add(GTK_CONTAINER(window), darea);

  g_signal_connect(G_OBJECT(darea), "draw", 
      G_CALLBACK(on_draw_event), NULL); 
  g_signal_connect(window, "destroy",
      G_CALLBACK(gtk_main_quit), NULL);

  gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
  gtk_window_set_default_size(GTK_WINDOW(window), 400, 90); 
  gtk_window_set_title(GTK_WINDOW(window), "GTK window");

  gtk_widget_show_all(window);

  gtk_main();

  return 0;
}
```