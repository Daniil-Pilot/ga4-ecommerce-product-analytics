# Tracking Plan

Здесь описаны ключевые события для e-commerce и обязательные параметры, которые должны передаваться в систему аналитики (GA4). Если параметр отсутствует значит данные считаются неполными и требуют внимания аналитика.

| Event Name | Описание | Обязательные параметры | Тип данных |
| :--- | :--- | :--- | :--- |
| `view_item` | Пользователь просмотрел карточку товара | `item_id`, `item_name`, `price`, `currency` | string, string, float, string |
| `add_to_cart` | Добавление товара в корзину | `item_id`, `quantity`, `value`, `currency` | string, int, float, string |
| `begin_checkout` | Начало процесса оформления заказа | `value`, `currency`, `items` | float, string, array |
| `purchase` | Успешная оплата заказа | `transaction_id`, `value`, `currency`, `items` | string, float, string, array |

## Правила валидации:
1. `transaction_id` должен быть уникальным для каждой покупки (защита от дублей).
2. `value` не может быть отрицательным или равен нулю.
3. Массив `items` не может быть пустым при событии `purchase`.