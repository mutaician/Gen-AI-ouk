"""Session logging utilities for ParkTimer"""
import os
import time


def log_session_to_csv(activity: str, timer_minutes: int, completed: bool, 
                       reason: str, remarks: str, roast: str) -> None:
    """Log a productivity session to CSV file"""
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
    
    # Create CSV header if file doesn't exist
    if not os.path.exists("sessions.csv"):
        with open("sessions.csv", "w") as f:
            f.write("Timestamp,Activity,Duration (min),Completed,Reason,Remarks,Roast\n")
    
    # Escape quotes in strings for CSV
    activity_safe = activity.replace('"', '""')
    reason_safe = reason.replace('"', '""')
    remarks_safe = remarks.replace('"', '""')
    roast_safe = roast.replace('"', '""')
    
    # Write session data
    with open("sessions.csv", "a") as f:
        f.write(f'"{timestamp}","{activity_safe}",{timer_minutes},{completed},"{reason_safe}","{remarks_safe}","{roast_safe}"\n')
    
