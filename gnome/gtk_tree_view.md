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
