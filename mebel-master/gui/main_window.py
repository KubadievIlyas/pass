from PyQt6.QtWidgets import (
    QMainWindow, QVBoxLayout, QWidget, QPushButton,
    QMessageBox, QDialog, QHBoxLayout, QLabel,
    QScrollArea, QFrame
)
from PyQt6.QtGui import QIcon
from PyQt6.QtCore import Qt, pyqtSignal
import os
import traceback
from typing import Optional, Dict, Any


class MainWindow(QMainWindow):
    request_selected = pyqtSignal(int)

    def __init__(self, request_model):
        super().__init__()
        self.request_model = request_model
        self.selected_card = None
        self._setup_ui()
        self._load_requests()

    # ui
    def _setup_ui(self):
        self.setWindowTitle("Управление заявками")
        self.setWindowIcon(QIcon("icon.png"))
        self.resize(1024, 600)

        central = QWidget()
        self.setCentralWidget(central)
        layout = QVBoxLayout(central)
        layout.setContentsMargins(10, 10, 10, 10)
        layout.setSpacing(15)

        scroll = QScrollArea()
        scroll.setWidgetResizable(True)
        scroll.setFrameShape(QFrame.Shape.NoFrame)

        scroll_content = QWidget()
        self.cards_layout = QVBoxLayout(scroll_content)
        self.cards_layout.setAlignment(Qt.AlignmentFlag.AlignTop)
        self.cards_layout.setSpacing(15)
        self.cards_layout.setContentsMargins(5, 5, 5, 5)

        scroll.setWidget(scroll_content)
        layout.addWidget(scroll)

        btns = QHBoxLayout()
        btns.setSpacing(15)

        self.btn_create = QPushButton("Создать заявку")
        self.btn_create.clicked.connect(self._show_create_dialog)
        btns.addWidget(self.btn_create)

        self.btn_edit = QPushButton("Редактировать")
        self.btn_edit.clicked.connect(self._show_edit_dialog)
        btns.addWidget(self.btn_edit)

        self.btn_calculate = QPushButton("Рассчитать")
        self.btn_calculate.clicked.connect(self._show_calculation)
        btns.addWidget(self.btn_calculate)

        self.btn_delete = QPushButton("Удалить")  # Новая кнопка
        self.btn_delete.clicked.connect(self._delete_selected_request)
        btns.addWidget(self.btn_delete)

        self.btn_refresh = QPushButton("Обновить")
        self.btn_refresh.clicked.connect(self._load_requests)
        btns.addWidget(self.btn_refresh)

        layout.addLayout(btns)
        self._load_styles()

    # css
    def _load_styles(self):
        if os.path.exists("gui/style.css"):
            with open("gui/style.css", encoding="utf-8") as f:
                self.setStyleSheet(f.read())

    # карточки
    def _load_requests(self):
        try:
            self._clear_cards()
            for req in self.request_model.get_all():
                self.cards_layout.addWidget(self._create_card(req))
        except Exception as e:
            self._show_error("Не удалось загрузить заявки", e)

    # очистка
    def _clear_cards(self):
        while self.cards_layout.count():
            item = self.cards_layout.takeAt(0)
            if item.widget():
                item.widget().deleteLater()

    # карточка
    def _create_card(self, request: dict) -> QFrame:
        card = QFrame()
        card.setObjectName("requestCard")
        card.setFrameShape(QFrame.Shape.StyledPanel)
        card.setLineWidth(1)

        layout = QHBoxLayout(card)
        layout.setContentsMargins(15, 15, 15, 15)
        layout.setSpacing(20)

        info = QVBoxLayout()
        info.setSpacing(8)

        info.addWidget(QLabel(f"<b>Заявка #{request['request_id']}</b>"))
        info.addWidget(QLabel(f"<b>Партнер:</b> {request['partner_name']}"))

        products = self.request_model.get_request_products(request['request_id'])
        product_text = "<br>".join(f"• {p['product_name']} ({p['quantity']} шт.)" for p in products)
        p_label = QLabel(f"<b>Продукты:</b><br>{product_text}")
        p_label.setWordWrap(True)
        info.addWidget(p_label)

        info.addWidget(QLabel(f"<b>Статус:</b> {request.get('status', 'Новая')}"))
        layout.addLayout(info, stretch=3)

        amount = QVBoxLayout()
        amount.setAlignment(Qt.AlignmentFlag.AlignRight | Qt.AlignmentFlag.AlignTop)
        amount.addWidget(QLabel(f"<h3>{request['total_cost']:.2f} руб.</h3>"))
        layout.addLayout(amount, stretch=1)

        card.request_id = request['request_id']
        card.setProperty('selected', False)
        card.mousePressEvent = lambda e: self._select_card(card)
        return card

    # выбор
    def _select_card(self, card):
        for i in range(self.cards_layout.count()):
            w = self.cards_layout.itemAt(i).widget()
            if w:
                w.setProperty('selected', False)
                w.style().unpolish(w)
                w.style().polish(w)

        card.setProperty('selected', True)
        card.style().unpolish(card)
        card.style().polish(card)

        self.selected_card = card
        self.request_selected.emit(card.request_id)

    # id
    def _get_selected_id(self) -> Optional[int]:
        if not self.selected_card:
            QMessageBox.warning(self, "Ошибка", "Выберите заявку")
            return None
        return self.selected_card.request_id

    # Новый метод удаления заявки
    def _delete_selected_request(self):
        req_id = self._get_selected_id()
        if req_id is None:
            return

        reply = QMessageBox.question(
            self,
            "Подтвердите удаление",
            f"Удалить заявку #{req_id}?",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No
        )

        if reply == QMessageBox.StandardButton.Yes:
            try:
                self.request_model.delete(req_id)
                QMessageBox.information(self, "Удалено", f"Заявка #{req_id} удалена")
                self.selected_card = None
                self._load_requests()
            except Exception as e:
                self._show_error("Ошибка удаления", e)

    # создание
    def _show_create_dialog(self):
        try:
            from gui.dialogs import CreateRequestDialog
            dialog = CreateRequestDialog(self)
            if dialog.exec() == QDialog.DialogCode.Accepted:
                self._process_create(dialog)
        except Exception as e:
            self._show_error("Ошибка открытия диалога", e)

    def _process_create(self, dialog: QDialog):
        name = dialog.partner_input.text().strip()
        products = dialog.selected_products

        if not name:
            QMessageBox.warning(self, "Ошибка", "Введите название партнера")
            return
        if not products:
            QMessageBox.warning(self, "Ошибка", "Добавьте продукт")
            return

        try:
            total = sum(p['price'] * p['quantity'] for p in products)
            req_id = self.request_model.create(name, total)
            self.request_model.add_request_products(req_id, products)
            QMessageBox.information(self, "Успех", f"Заявка #{req_id} создана")
            self._load_requests()
        except Exception as e:
            self._show_error("Ошибка сохранения", e)

    # редактирование
    def _show_edit_dialog(self):
        req_id = self._get_selected_id()
        if req_id is None:
            return

        try:
            from gui.dialogs import CreateRequestDialog
            dialog = CreateRequestDialog(self)
            dialog.setWindowTitle("Редактирование заявки")

            request = self.request_model.get_by_id(req_id)
            if not request:
                QMessageBox.warning(self, "Ошибка", "Заявка не найдена")
                return

            dialog.partner_input.setText(request['partner_name'])

            for p in self.request_model.get_request_products(req_id):
                dialog.product_combo.setCurrentIndex(dialog.product_combo.findData(p['product_id']))
                dialog.quantity_spin.setValue(p['quantity'])
                dialog.add_product()

            if dialog.exec() == QDialog.DialogCode.Accepted:
                self._process_edit(req_id, dialog)
        except Exception as e:
            self._show_error("Ошибка открытия диалога", e)

    def _process_edit(self, req_id: int, dialog: QDialog):
        name = dialog.partner_input.text().strip()
        products = dialog.selected_products

        if not name:
            QMessageBox.warning(self, "Ошибка", "Введите название партнера")
            return
        if not products:
            QMessageBox.warning(self, "Ошибка", "Добавьте продукт")
            return

        try:
            self.request_model.update_request_with_products(req_id, name, products)
            QMessageBox.information(self, "Успех", f"Заявка #{req_id} обновлена")
            self._load_requests()
        except Exception as e:
            self._show_error("Ошибка сохранения", e)

    # расчет
    def _show_calculation(self):
        req_id = self._get_selected_id()
        if req_id is None:
            return

        try:
            products = self.request_model.get_request_products(req_id)
            if not products:
                QMessageBox.warning(self, "Ошибка", "Нет продуктов")
                return

            from db.calculator import ProductionCalculator
            total_materials = total_hours = 0
            details = []

            for p in products:
                materials = ProductionCalculator.calculate_materials(p['product_id'], p['quantity'])
                if materials == -1:
                    QMessageBox.warning(self, "Ошибка", f"Не удалось рассчитать материалы: {p['product_name']}")
                    return

                hours = ProductionCalculator.calculate_production_time(p['product_id'])
                if hours == -1:
                    QMessageBox.warning(self, "Ошибка", f"Не удалось рассчитать время: {p['product_name']}")
                    return

                total_materials += materials
                total_hours += hours
                details.append(
                    f"{p['product_name']} ({p['quantity']} шт.): Материалы: {materials:.2f} руб., Время: {hours:.1f} ч."
                )

            dlg = QDialog(self)
            dlg.setWindowTitle("Расчет материалов и времени")
            dlg.setMinimumWidth(600)

            layout = QVBoxLayout(dlg)
            layout.addWidget(QLabel(f"<b>Заявка #{req_id}</b>"))
            layout.addWidget(QLabel(f"<b>Материалы:</b> {total_materials:.2f} руб."))
            layout.addWidget(QLabel(f"<b>Время:</b> {total_hours:.1f} ч."))
            layout.addWidget(QLabel("<b>Детали:</b>"))
            for d in details:
                layout.addWidget(QLabel(d))

            btn = QPushButton("Закрыть")
            btn.clicked.connect(dlg.accept)
            layout.addWidget(btn)

            dlg.exec()

        except Exception as e:
            self._show_error("Ошибка расчета", e)

    # ошибка
    def _show_error(self, msg: str, exc: Exception = None):
        QMessageBox.critical(self, "Ошибка", msg)
        if exc:
            traceback.print_exc()
