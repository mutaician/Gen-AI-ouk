"""Timer utility functions for ParkTimer"""
import time
import os

# Suppress pygame welcome message
os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = "1"
import pygame

from rich.console import Console
from rich.progress import Progress, BarColumn, TextColumn, TimeRemainingColumn
from rich.panel import Panel
from rich.text import Text

console = Console()


def display_timer(total_minutes: int) -> None:
    """Display a beautiful progress bar timer that counts down"""
    # Header
    header = Text("Timer Started!", style="bold green")
    console.print(Panel(header, border_style="green"))
    
    total_seconds = total_minutes * 60
    
    with Progress(
        TextColumn("[bold blue]{task.description}"),
        BarColumn(bar_width=40, style="cyan", complete_style="green"),
        TextColumn("[bold]{task.fields[time_remaining]}"),
        console=console,
    ) as progress:
        task = progress.add_task(
            "Focus time", 
            total=total_seconds,
            time_remaining="00:00"
        )
        
        for elapsed in range(total_seconds + 1):
            remaining = total_seconds - elapsed
            mins = remaining // 60
            secs = remaining % 60
            
            progress.update(
                task, 
                completed=elapsed,
                time_remaining=f"{mins:02d}:{secs:02d}"
            )
            
            if elapsed < total_seconds:
                time.sleep(1)
    
    # Completion message
    complete_msg = Text("Timer Complete!", style="bold yellow")
    console.print(Panel(complete_msg, border_style="yellow"))


def play_completion_sound() -> None:
    """Play timer completion sound in loop"""
    pygame.mixer.init()
    pygame.mixer.music.load("p3nkem0mchp-timer-sfx-1.mp3")
    pygame.mixer.music.play(-1)  # -1 means loop infinitely


def stop_completion_sound() -> None:
    """Stop the timer completion sound"""
    pygame.mixer.music.stop()
    pygame.mixer.quit()
