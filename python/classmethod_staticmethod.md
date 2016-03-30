# classmethod vs staticmethod

[stackoverflow discussion](http://stackoverflow.com/questions/136097/what-is-the-difference-between-staticmethod-and-classmethod-in-python)

### Singleton usage in GNOME Music
```
@classmethod
def get_default(cls, tracker=None):
    if cls.instance:
        return cls.instance
    else:
        cls.instance = Playlists()
    return cls.instance
```