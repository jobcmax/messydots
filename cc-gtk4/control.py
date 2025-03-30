import os
import sys
import gi

from ctypes import CDLL
CDLL('libgtk4-layer-shell.so')

gi.require_version('Gtk', '4.0')
gi.require_version('Gtk4LayerShell', '1.0')

from gi.repository import Gtk, Gdk, GLib
from gi.repository import Gtk4LayerShell as LayerShell
import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from listener import *

class MainWindow(Gtk.Window):
    def __init__(self):
        super().__init__()
        
        # window stuff
        self.set_size_request(360, 50)
        self.set_name("window")
        
        # import stylesheet
        style_provider = Gtk.CssProvider()
        style_provider.load_from_path(os.path.dirname(os.path.realpath(__file__)) + "/" +"style.css")
        Gtk.StyleContext.add_provider_for_display(Gdk.Display().get_default(),
                                                  style_provider, 
                                                  Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        LayerShell.init_for_window(self)
        
        # self position
        LayerShell.set_layer(self, LayerShell.Layer.TOP)
        LayerShell.set_margin(self, LayerShell.Edge.TOP, 4)
        LayerShell.set_margin(self, LayerShell.Edge.RIGHT, 8) # why doesnt 4 work?
        LayerShell.set_anchor(self, LayerShell.Edge.TOP, True)
        LayerShell.set_anchor(self, LayerShell.Edge.RIGHT, True)
        LayerShell.auto_exclusive_zone_enable(self)
        
        # widgets
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        vbox.add_css_class("vbox")
        self.set_child(vbox)
        
        # battery
        hbox1 = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=16)
        hbox1.add_css_class("hbox1")
        bat_icon = Gtk.Label()
        bat_icon.add_css_class("bat_icon")
        bat_life_label = Gtk.Label()
        
        def update_bat():
            bat_value, bat_status, bat_life = bat()
            
            # reset class
            bat_icon.remove_css_class("full_bat")
            bat_icon.remove_css_class("mid_bat")
            bat_icon.remove_css_class("low_bat")
            
            if bat_value > 70:
                bat_icon.add_css_class("full_bat")
            elif bat_value >= 20:
                bat_icon.add_css_class("mid_bat")
            elif bat_value <= 20:
                bat_icon.add_css_class("low_bat")
            else:
                return
                
            if bat_status == "Charging":
                bat_icon.set_text("󰂄")
            elif bat_status == "Discharging" or bat_status == "Not charging":
                bat_icon.set_text("󰁹")
            
            bat_life_label.set_text(bat_life)
            return True

        GLib.timeout_add(1000, update_bat)
        hbox1.append(bat_icon)
        hbox1.append(bat_life_label)
        vbox.append(hbox1)
        
        
        # brightness
        hbox2 = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        hbox2.add_css_class("hbox2")
        
        bright_icon = Gtk.Label()
        bright_icon.set_text("󰃠")
        bright_icon.add_css_class("bright_icon")
        
        bright_slider = Gtk.Scale.new_with_range(
            Gtk.Orientation.HORIZONTAL, 0, 100, 1
        )
        bright_slider.add_css_class("bright_slider")
        bright_slider.set_hexpand(True)
        bright_value, set_bright = bright()
        bright_slider.connect("value-changed", set_bright)
        
        def update_bright():
            bright_value, set_bright = bright() # update value, this looks stupid idk why
            bright_slider.set_value(bright_value)
            return True
        
        GLib.timeout_add(500, update_bright)
        hbox2.append(bright_icon)
        hbox2.append(bright_slider)
        vbox.append(hbox2)
        
        
        # volume
        hbox3 = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        hbox3.add_css_class("hbox3")
        
        vol_icon = Gtk.Label()
        vol_icon.add_css_class("vol_icon")
        vol_icon.set_cursor_from_name("pointer")
        click_controller = Gtk.GestureClick()
        
        def toggle_mute(self, *args):
            run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
            update_vol()
            
        click_controller.connect("pressed", toggle_mute, vol_icon)
        vol_icon.add_controller(click_controller)
        vol_slider = Gtk.Scale.new_with_range(
            Gtk.Orientation.HORIZONTAL, 0, 100, 1
        )
        vol_slider.add_css_class("vol_slider")
        vol_slider.set_hexpand(True)
        vol_value, vol_muted, set_vol = vol()
        vol_slider.connect("value-changed", set_vol)
        
        def update_vol():
            vol_value, vol_muted, set_vol = vol() # update value, this looks stupid idk why
            vol_slider.set_value(vol_value)
            
            if vol_muted == True:
                vol_icon.set_text("󰖁")
            elif vol_value >= 65:
                vol_icon.set_text("󰕾")
            elif vol_value >= 35:
                vol_icon.set_text("󰖀")
            elif vol_value <= 35:
                vol_icon.set_text("󰕿")
            else:
                return
                
            return True
        
        GLib.timeout_add(500, update_vol)
        hbox3.append(vol_icon)
        hbox3.append(vol_slider)
        vbox.append(hbox3)
            
# initialize window and start service
def on_activate(app):
    window = MainWindow()
    window.set_application(app)
    window.present()
    window.set_visible(False)
    window.visible = window.get_visible()
    
    # dbus stuff
    class Service(dbus.service.Object):
        def __init__(self):
            self.bus = dbus.SessionBus()
            name = dbus.service.BusName('widget.control.service', bus=self.bus)
            dbus.service.Object.__init__(self, name, '/widget/control/service')
        
        @dbus.service.method('widget.control.service')
        def toggle(self):
            window.visible = not window.visible
            window.set_visible(window.visible)
            return str(window.get_visible())
        
    DBusGMainLoop(set_as_default=True)
    MyService = Service()

app = Gtk.Application()
app.connect('activate', on_activate) 
app.run(sys.argv)
