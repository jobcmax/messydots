import os
import subprocess
import dbus
import sys

def run(sh):
    Output = subprocess.run([sh],shell=True, capture_output=True, text=True).stdout.strip()
    return Output

def bat():
    check_value = r"""
        cat /sys/class/power_supply/BAT?/capacity 2>/dev/null | head -1
    """
    
    check_status = r""" 
        cat /sys/class/power_supply/BAT?/status | head -1
    """
    
    check_life = r"""
        upower -i $(upower -e | grep 'BAT') | grep -E "time to" | sed 's/^[^\.]\+\://' | sed -e 's/^ *//g' -e 's/ *$//g'
    """

    value = int(run(check_value))
    status = run(check_status)
    life = run(check_life)
    
    life = life.replace(".", ",")
    life = life.replace("hours", "Hours")
    life = life.replace("minutes", "Minutes")
    life = life.replace("seconds", "Seconds")
    
    if value == 100 and status == "Not charging":
        life = "Fully charged"
    elif life == "":
        life = "Hold on..."
    elif status == "Discharging":
        life = life + " " + "remaining"
    elif status == "Charging":
        life = life + " " + "until full"
    
    return value, status, life
    
def bright():
    check_value = r"""
        brightnessctl i | grep -oP '\(\K[^%\)]+'
    """
    value = int(run(check_value))
    
    def set_bright(scale):
        bright_value = int(scale.get_value())
        run(f"brightnessctl set {bright_value}%")

    return value, set_bright
    
def vol():
    check_value = r"""
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
    """
    
    check_muted = r"""
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}'
    """
    value = int(run(check_value))
    muted = run(check_muted)
    
    if muted == "[MUTED]":
        muted = True
    elif muted == "":
        muted = False
    
    def set_vol(scale):
        vol_value = int(scale.get_value())
        run(f"amixer set Master {vol_value}%")
    
    return value, muted, set_vol
