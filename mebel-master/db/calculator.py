from db.database import Database


class ProductionCalculator:
    @staticmethod
    def calculate_materials(product_id, quantity):
        try:
            with Database().get_cursor() as cursor:
                cursor.execute("""
                    SELECT p.*, mt.loss_percentage, pc.category_coefficient 
                    FROM products p
                    JOIN material_types mt ON p.main_material_id = mt.material_type_id
                    JOIN product_categories pc ON p.category_id = pc.category_id
                    WHERE p.product_id = %s
                """, (product_id,))
                data = cursor.fetchone()

                if not data:
                    return -1

                required = (data['min_partner_price'] * quantity *
                            data['category_coefficient'] * (1 + data['loss_percentage']))
                return round(required, 2)
        except Exception as e:
            print(f"Calculation error: {e}")
            return -1

    @staticmethod
    def calculate_production_time(product_id):
        try:
            with Database().get_cursor() as cursor:
                cursor.execute("""
                    SELECT SUM(production_time_hours) as total_time 
                    FROM production_steps 
                    WHERE product_id = %s
                """, (product_id,))
                data = cursor.fetchone()
                return data['total_time'] if data and data['total_time'] else 0
        except Exception as e:
            print(f"Time calculation error: {e}")
            return -1