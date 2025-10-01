import from byllm { Model }
import time;

glob llm = Model(model_name="gemini/gemini-2.5-flash", verbose=False);

def generate_remarks(completed: bool, reason: str) -> str by llm();
def generate_roast(activity: str, completed: bool, reason: str) -> str by llm();

walker ProductivitySession {
    has activity: str = "";
    has timer_minutes: int = 0;
    has completed: bool = False;
    has reason: str = "";
    has remarks: str = "";
    has roast: str = "";

    can start_session with `root entry;
}

with entry {
    root spawn ProductivitySession();
}