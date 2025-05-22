from db.database import Database


class Request:
    def __init__(self, db):
        self.db = db

    def create(self, partner_name, total_cost):
        # создать заявку
        with self.db.get_cursor() as cursor:
            cursor.execute(
                "INSERT INTO partner_requests (partner_name, total_cost) VALUES (%s, %s)",
                (partner_name, total_cost)
            )
            self.db.commit()
            return cursor.lastrowid

    def add_request_products(self, request_id, products):
        # добавить продукты
        with self.db.get_cursor() as cursor:
            for p in products:
                cursor.execute(
                    """
                    INSERT INTO request_products 
                    (request_id, product_id, quantity, calculated_cost)
                    VALUES (%s, %s, %s, %s)
                    """,
                    (request_id, p['id'], p['quantity'], p['price'] * p['quantity'])
                )
            self.db.commit()

    def get_all(self):
        # все заявки
        with self.db.get_cursor() as cursor:
            cursor.execute("""
                SELECT request_id, partner_name, total_cost, request_date
                FROM partner_requests
                ORDER BY request_date DESC
            """)
            return cursor.fetchall()

    def get_by_id(self, request_id):
        # заявка по ID
        with self.db.get_cursor() as cursor:
            cursor.execute("""
                SELECT request_id, partner_name, total_cost, request_date
                FROM partner_requests
                WHERE request_id = %s
            """, (request_id,))
            return cursor.fetchone()

    def get_request_products(self, request_id):
        # продукты заявки
        with self.db.get_cursor() as cursor:
            cursor.execute("""
                SELECT rp.product_id, rp.quantity, rp.calculated_cost,
                       p.product_name, p.min_partner_price
                FROM request_products rp
                JOIN products p ON rp.product_id = p.product_id
                WHERE rp.request_id = %s
            """, (request_id,))
            return cursor.fetchall()

    def update(self, request_id, partner_name, total_cost):
        # обновить заявку
        with self.db.get_cursor() as cursor:
            cursor.execute(
                "UPDATE partner_requests SET partner_name = %s, total_cost = %s WHERE request_id = %s",
                (partner_name, total_cost, request_id)
            )
            self.db.commit()

    def delete_request_products(self, request_id):
        # удалить продукты
        with self.db.get_cursor() as cursor:
            cursor.execute(
                "DELETE FROM request_products WHERE request_id = %s",
                (request_id,)
            )
            self.db.commit()

    def update_request_with_products(self, request_id, partner_name, products):
        # обновить заявку и продукты
        with self.db.get_cursor() as cursor:
            total_cost = sum(p['price'] * p['quantity'] for p in products)

            cursor.execute(
                "UPDATE partner_requests SET partner_name = %s, total_cost = %s WHERE request_id = %s",
                (partner_name, total_cost, request_id)
            )

            cursor.execute(
                "DELETE FROM request_products WHERE request_id = %s",
                (request_id,)
            )

            for p in products:
                cursor.execute(
                    """
                    INSERT INTO request_products 
                    (request_id, product_id, quantity, calculated_cost)
                    VALUES (%s, %s, %s, %s)
                    """,
                    (request_id, p['id'], p['quantity'], p['price'] * p['quantity'])
                )

            self.db.commit()

    def delete(self, request_id):
        # удалить заявку и продукты
        with self.db.get_cursor() as cursor:
            cursor.execute(
                "DELETE FROM request_products WHERE request_id = %s",
                (request_id,)
            )
            cursor.execute(
                "DELETE FROM partner_requests WHERE request_id = %s",
                (request_id,)
            )
            self.db.commit()
