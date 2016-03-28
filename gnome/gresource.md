# GResource

[docs](https://developer.gnome.org/gio/2.32/gio-GResource.html)

Define all resource(image, ui, raw files) needed by a programs in a file.

Resource bundles are created by the glib-compile-resources program which takes an xml file that describes the bundle, and a set of files that the xml references. These are combined into a binary resource bundle.

## GNOME Music
```xml
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/Music">
    <file preprocess="xml-stripblanks">AboutDialog.ui</file>
    <file alias="gtk/menus.ui" preprocess="xml-stripblanks">app-menu.ui</file>
    <file>application.css</file>
    <file>initial-state.png</file>
    <file preprocess="xml-stripblanks">AlbumWidget.ui</file>
    <file preprocess="xml-stripblanks">ArtistAlbumWidget.ui</file>
    <file preprocess="xml-stripblanks">ArtistAlbumsWidget.ui</file>
    <file preprocess="xml-stripblanks">PlayerToolbar.ui</file>
    <file preprocess="xml-stripblanks">SelectionToolbar.ui</file>
    <file preprocess="xml-stripblanks">headerbar.ui</file>
    <file preprocess="xml-stripblanks">TrackWidget.ui</file>
    <file preprocess="xml-stripblanks">NoMusic.ui</file>
    <file preprocess="xml-stripblanks">PlaylistControls.ui</file>
    <file preprocess="xml-stripblanks">PlaylistDialog.ui</file>
  </gresource>
</gresources>
```
```python
resource = Gio.resource_load(os.path.join(pkgdatadir, 'gnome-music.gresource'))
```
```c
GResource* g_resource_load (const gchar *filename, GError **error);
```