import time;
import os;
import sys;
import from timer_utils { display_timer, play_completion_sound, stop_completion_sound }
import from session_logger { log_session_to_csv }
import from rich.console { Console }
import from rich.panel { Panel }
import from rich.text { Text }

glob console = Console();

impl ProductivitySession.start_session {
    # Check for API key first
    if not os.getenv("GOOGLE_API_KEY") {
        console.print("\n[bold red]ERROR:[/bold red] Missing GOOGLE_API_KEY environment variable!");
        console.print("ParkTimer requires a Google API key to generate AI feedback.\n");
        console.print("[yellow]Please set your API key:[/yellow]");
        console.print("  [cyan]export GOOGLE_API_KEY='your-api-key-here'[/cyan]");
        console.print("\nOr add it to your .env file.");
        sys.exit(1);
    }
    
    # Header with branding
    title = Text("ParkTimer", style="bold magenta");
    subtitle = Text("Beat Parkinson's Law - Work expands, but your time doesn't", style="italic cyan");
    header_text = Text.assemble(title, "\n", subtitle);
    console.print(Panel(header_text, border_style="magenta"));
    
    console.print("\n[bold cyan]=== Productivity Session ===[/bold cyan]");
    
    # Get activity with validation
    self.activity = "";
    while self.activity.strip() == "" {
        self.activity = input("Enter the activity: ");
        if self.activity.strip() == "" {
            console.print("[bold red]Error:[/bold red] Activity cannot be empty. Please try again.");
        }
    }
    
    # Get timer with validation
    self.timer_minutes = 0;
    while self.timer_minutes <= 0 {
        timer_str = input("Set timer in minutes: ");
        try {
            self.timer_minutes = int(timer_str);
            if self.timer_minutes <= 0 {
                console.print("[bold red]Error:[/bold red] Timer must be a positive number. Please try again.");
            }
        } except ValueError {
            console.print("[bold red]Error:[/bold red] Please enter a valid number.");
            self.timer_minutes = 0;
        }
    }
    
    # Confirm timer start
    console.print("");
    start = input(f"Start {self.timer_minutes} minute timer for '{self.activity}'? (y/n): ");
    
    if start.lower() == 'y' {
        # Run timer with progress display
        display_timer(self.timer_minutes);
        
        # Play completion sound in loop
        play_completion_sound();
        
        # Assessment with styled UI
        console.print("");
        assessment_header = Text("Assessment Time", style="bold yellow");
        console.print(Panel(assessment_header, border_style="yellow"));
        
        completed_str = input("\n[?] Did you accomplish the activity? (yes/no): ");
        
        # Stop the sound after user responds
        stop_completion_sound();
        
        self.completed = completed_str.lower() == "yes";
        self.reason = input("[?] Why or why not?: ");
        
        # Generate feedback
        console.print("\n[bold cyan]Generating feedback...[/bold cyan]");
        self.remarks = generate_remarks(self.completed, self.reason);
        
        # Display remarks in styled panel
        remarks_text = Text(self.remarks, style="italic");
        console.print(Panel(remarks_text, title="[bold]Remarks[/bold]", border_style="cyan"));
        
        # Optional roast
        want_roast = input("\n[?] Would you like a roast? (y/n): ");
        if want_roast.lower() == 'y' {
            console.print("[bold cyan]Generating roast...[/bold cyan]");
            self.roast = generate_roast(self.activity, self.completed, self.reason);
            roast_text = Text(self.roast, style="bold red");
            console.print(Panel(roast_text, title="[bold]Roast[/bold]", border_style="red"));
        } else {
            self.roast = "N/A";
        }
        
        # Log session to CSV
        log_session_to_csv(self.activity, self.timer_minutes, self.completed, 
                          self.reason, self.remarks, self.roast);
        
        # Success message
        console.print("\n[bold green]Session logged successfully to sessions.csv![/bold green]");
    } else {
        console.print("[yellow]Timer cancelled.[/yellow]");
    }
    
    disengage;
}