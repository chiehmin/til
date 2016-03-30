# GtkTreeView

[tutorial](https://developer.gnome.org/gtk3/stable/TreeWidget.html)

## Models
* GtkListStore: A flat data structure for model
	* [docs](https://developer.gnome.org/gtk3/stable/GtkListStore.html)
* GtkTreeStore: Each field can have its sub-field
	* [docs](https://developer.gnome.org/gtk3/stable/GtkTreeStore.html)

## View

* GtkTreeView: the only view widget to deal with

* GtkTreeViewColumn: A column that can pack multiple fields from model.
* [GtkCellRenderer](https://developer.gnome.org/gtk3/stable/GtkCellRenderer.html): Used to render each column
	* GtkCellRendererText
    * GtkCellRendererPixbuf
    * GtkCellRendererProgress
    * GtkCellRendererSpinner
    * GtkCellRendererToggle

```
#include <gtk/gtk.h>

static void
print_hello (GtkWidget *widget,
             gpointer   data)
{
  g_print ("Hello World\n");
}

static void
activate (GtkApplication *app,
          gpointer        user_data)
{
  GtkWidget *window;
  GtkListStore *store;
  GtkTreeIter iter;
  GtkWidget *tree;
  GtkCellRenderer *renderer;
  GtkTreeViewColumn *column;

  window = gtk_application_window_new (app);
  gtk_window_set_title (GTK_WINDOW (window), "Window");
  gtk_window_set_default_size (GTK_WINDOW (window), 200, 200);

  store = gtk_list_store_new (2, G_TYPE_STRING, G_TYPE_BOOLEAN);

  gtk_list_store_append(store, &iter);
  gtk_list_store_set(store, &iter, 0, "Hello", -1);

  tree = gtk_tree_view_new_with_model (GTK_TREE_MODEL (store));
  renderer = gtk_cell_renderer_text_new ();
  column = gtk_tree_view_column_new_with_attributes ("title",
                                                   renderer,
                                                   "text", 0,
                                                   NULL);
  gtk_tree_view_append_column (GTK_TREE_VIEW (tree), column);

  gtk_container_add (GTK_CONTAINER (window), tree);
  gtk_widget_show_all (window);
}

int
main (int    argc,
      char **argv)
{
  GtkApplication *app;
  int status;

  app = gtk_application_new ("org.gtk.example", G_APPLICATION_FLAGS_NONE);
  g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
  status = g_application_run (G_APPLICATION (app), argc, argv);
  g_object_unref (app);

  return status;
}
```
