from PyQt6.QtWidgets import (
    QDialog, QVBoxLayout, QHBoxLayout, QLabel,
    QLineEdit, QComboBox, QSpinBox, QPushButton,
    QTableWidget, QTableWidgetItem, QMessageBox,
    QDialogButtonBox, QHeaderView
)
from PyQt6.QtCore import Qt
from db.database import Database


class CreateRequestDialog(QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.products = []
        self.selected_products = []
        self.setup_ui()

    def setup_ui(self):
        self.setWindowTitle("Новая заявка")
        self.setMinimumWidth(600)

        layout = QVBoxLayout(self)

        layout.addWidget(QLabel("Информация о партнере:"))
        self.partner_input = QLineEdit()
        self.partner_input.setPlaceholderText("Введите название компании")
        layout.addWidget(QLabel("Название:"))
        layout.addWidget(self.partner_input)

        layout.addWidget(QLabel("Добавить продукт:"))

        hbox = QHBoxLayout()
        self.product_combo = QComboBox()
        self.load_products()
        hbox.addWidget(self.product_combo)

        self.quantity_spin = QSpinBox()
        self.quantity_spin.setMinimum(1)
        self.quantity_spin.setMaximum(100)
        hbox.addWidget(QLabel("Количество:"))
        hbox.addWidget(self.quantity_spin)

        btn_add = QPushButton("Добавить")
        btn_add.clicked.connect(self.add_product)
        hbox.addWidget(btn_add)

        btn_remove = QPushButton("Удалить продукт")
        btn_remove.clicked.connect(self.remove_selected_product)
        hbox.addWidget(btn_remove)

        layout.addLayout(hbox)

        self.products_table = QTableWidget(0, 3)
        self.products_table.setHorizontalHeaderLabels(["Продукт", "Кол-во", "Сумма"])
        self.products_table.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        self.products_table.setSelectionBehavior(QTableWidget.SelectionBehavior.SelectRows)
        self.products_table.setSelectionMode(QTableWidget.SelectionMode.SingleSelection)
        layout.addWidget(self.products_table)

        buttons = QDialogButtonBox(
            QDialogButtonBox.StandardButton.Ok |
            QDialogButtonBox.StandardButton.Cancel
        )
        buttons.accepted.connect(self.validate_data)
        buttons.rejected.connect(self.reject)
        layout.addWidget(buttons)

    def load_products(self):
        try:
            db = Database()
            with db.get_cursor() as cursor:
                cursor.execute("SELECT product_id, product_name, min_partner_price FROM products")
                self.products = cursor.fetchall()

            self.product_combo.clear()
            for product in self.products:
                self.product_combo.addItem(
                    f"{product['product_name']} - {product['min_partner_price']:.2f} руб.",
                    product['product_id']
                )
        except Exception as e:
            QMessageBox.critical(self, "Ошибка", f"Не удалось загрузить продукты: {str(e)}")
            self.products = []

    def add_product(self):
        if not self.products:
            return

        product_id = self.product_combo.currentData()
        product_text = self.product_combo.currentText()
        product_name = product_text.split(" - ")[0]
        try:
            price = float(product_text.split(" - ")[1].split(" руб.")[0])
        except Exception:
            price = 0.0
        quantity = self.quantity_spin.value()
        total = price * quantity

        for p in self.selected_products:
            if p['id'] == product_id:
                p['quantity'] += quantity
                for row in range(self.products_table.rowCount()):
                    if self.products_table.item(row, 0).text() == product_name:
                        self.products_table.setItem(row, 1, QTableWidgetItem(str(p['quantity'])))
                        new_total = p['price'] * p['quantity']
                        self.products_table.setItem(row, 2, QTableWidgetItem(f"{new_total:.2f} руб."))
                        break
                return

        row = self.products_table.rowCount()
        self.products_table.insertRow(row)
        self.products_table.setItem(row, 0, QTableWidgetItem(product_name))
        self.products_table.setItem(row, 1, QTableWidgetItem(str(quantity)))
        self.products_table.setItem(row, 2, QTableWidgetItem(f"{total:.2f} руб."))

        self.selected_products.append({
            'id': product_id,
            'name': product_name,
            'quantity': quantity,
            'price': price
        })

    def remove_selected_product(self):
        selected = self.products_table.selectionModel().selectedRows()
        if not selected:
            QMessageBox.warning(self, "Ошибка", "Выберите продукт для удаления")
            return
        row = selected[0].row()
        product_name = self.products_table.item(row, 0).text()

        self.selected_products = [p for p in self.selected_products if p['name'] != product_name]

        self.products_table.removeRow(row)

    def validate_data(self):
        if not self.partner_input.text().strip():
            QMessageBox.warning(self, "Ошибка", "Введите название партнера")
            return
        if not self.selected_products:
            QMessageBox.warning(self, "Ошибка", "Добавьте хотя бы один продукт")
            return
        self.accept()
