-- prestashop default orders query
SELECT CONCAT(LEFT(cu.`firstname`, 1), '. ', cu.`lastname`) AS `customer`,
    o.id_order,
    o.reference,
    o.total_paid_tax_incl,
    os.paid,
    osl.name AS osname,
    o.id_currency,
    cur.iso_code,
    o.current_state,
    o.id_customer,
    cu.`id_customer` IS NULL as `deleted_customer`,
    os.color,
    o.payment,
    s.name AS shop_name,
    o.date_add,
    cu.company,
    cl.name AS country_name,
    o.invoice_number,
    o.delivery_number,
    (
        SELECT IF(count(so.id_order) > 0, 0, 1)
        FROM pskl_orders so
        WHERE (so.id_customer = o.id_customer)
            AND (so.id_order < o.id_order)
        LIMIT 1
    ) AS new
FROM pskl_orders o
    LEFT JOIN pskl_customer cu ON o.id_customer = cu.id_customer
    LEFT JOIN pskl_currency cur ON o.id_currency = cur.id_currency
    INNER JOIN pskl_address a ON o.id_address_delivery = a.id_address
    LEFT JOIN pskl_order_state os ON o.current_state = os.id_order_state
    LEFT JOIN pskl_shop s ON o.id_shop = s.id_shop
    INNER JOIN pskl_country c ON a.id_country = c.id_country
    INNER JOIN pskl_country_lang cl ON c.id_country = cl.id_country
    AND cl.id_lang = 1
    LEFT JOIN pskl_order_state_lang osl ON os.id_order_state = osl.id_order_state
    AND osl.id_lang = 1
WHERE o.`id_shop` IN ('1')
ORDER BY o.`date_add` desc
LIMIT 100;