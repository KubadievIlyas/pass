import sys
from PyQt6.QtWidgets import QApplication
from db.database import Database
from db.models import Request
from gui.main_window import MainWindow

def main():
    app = QApplication(sys.argv)
    db = Database()
    request_model = Request(db)
    window = MainWindow(request_model)
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()