# OOP in gobject

### Interface

[docs](https://developer.gnome.org/gobject/stable/gtype-non-instantiable-classed.html)

```c
#define G_DECLARE_INTERFACE(ModuleObjName, module_obj_name, MODULE, OBJ_NAME, PrerequisiteName)
```
* ModuleObjName: The name of the new type, in camel case (like GtkWidget)
* module_obj_name: The name of the new type in lowercase, with words separated by '_' (like 'gtk_widget')
* MODULE: The name of the module, in all caps (like 'GTK')
* OBJ_NAME: The bare name of the type, in all caps (like 'WIDGET')
* PrerequisiteName: the name of the prerequisite type, in camel case (like GtkWidget)

[G_DECLARE_INTERFACE macro](https://developer.gnome.org/gobject/stable/gobject-Type-Information.html#G-DECLARE-INTERFACE:CAPS)

```c
#ifndef _my_model_h_
#define _my_model_h_

#define MY_TYPE_MODEL my_model_get_type ()
GDK_AVAILABLE_IN_3_12
G_DECLARE_INTERFACE (MyModel, my_model, MY, MODEL, GObject)

struct _MyModelInterface
{
  GTypeInterface g_iface;

  gpointer (* get_item)  (MyModel *model);
};

gpointer my_model_get_item (MyModel *model);

...

#endif
```

This results in the following things happening:
* the usual my_model_get_type() function is declared with a return type of GType
* the MyModelInterface type is defined as a typedef to struct _MyModelInterface, which is left undefined. You should do this from the header file directly after you use the macro.
* the MY_MODEL() cast is emitted as static inline functions along with the MY_IS_MODEL() type checking function and MY_MODEL_GET_IFACE() function.
* g_autoptr() support being added for your type, based on your prerequisite type.
