## Icon Path

Gtk Icons can be found here at `/usr/share/icons/<theme>`

## Accessing programatically

```python
icon_name = 'folder-music-symbolic'
icon = Gtk.IconTheme.get_default().load_icon(icon_name, max(width, height) / 4, 0)
```
```c
GdkPixbuf *
gtk_icon_theme_load_icon (GtkIconTheme *icon_theme,
                          const gchar *icon_name,
                          gint size,
                          GtkIconLookupFlags flags,
                          GError **error);
```

## Reference

* [GtkIconTheme](https://developer.gnome.org/gtk3/stable/GtkIconTheme.html)
* [Icon theme spec](https://developer.gnome.org/icon-theme-spec/)

