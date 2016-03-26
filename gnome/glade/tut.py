import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

builder = Gtk.Builder()
builder.add_from_file("./tut.glade")
builder.connect_signals({"onDeleteWindow": Gtk.main_quit,})

window = builder.get_object("window1")
window.show_all()

Gtk.main()
