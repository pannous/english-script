using Gtk
 
new Window with
    title = "Hello, World!"
    border width = 10
    window position = WindowPosition.CENTER
    default size 350 times 70
    window.destroy.connect();
 
add new Label("Hello, World!") to window

on window destroy do Gtk.main_quit
window.show_all 
run Gtk main