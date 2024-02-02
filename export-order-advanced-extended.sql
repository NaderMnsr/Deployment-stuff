SELECT
    o.reference AS OrderReference,
    d.product_reference AS ItemEan,
    d.product_quantity AS Qty,
    '' AS Origin, 
    '' AS ShippingMethod, 
    '' AS ShippingPointRetrait, 
    '' AS ClientCode,
    '' AS ClientGln,
    g.email AS Email,
    CONCAT_WS(' ', g.firstname, g.lastname) AS Name,
    a.phone AS PhoneNumber,
    CONCAT_WS(' ', a.address1) AS Address1,
    a.address2 AS Address2,
    a.postcode AS PostalCode,
    s.name AS shop_name,
    a.city AS City,
    c.name AS Country,
    -- Add more columns as needed
    g.company,
    (
        SELECT IF(count(so.id_order) > 0, 0, 1)
        FROM pskl_orders so
        WHERE (so.id_customer = o.id_customer)
            AND (so.id_order < o.id_order)
        LIMIT 1
    ) AS new,
    o.invoice_number,
    o.delivery_number,
    o.payment,
    cu.`id_customer` IS NULL as `deleted_customer`,
    os.color,
    o.id_customer,
    o.id_currency,
    cur.iso_code,
    o.current_state,
    o.total_paid_tax_incl,
    os.paid,
    osl.name AS osname
FROM
    pskl_order_detail d 
    LEFT JOIN pskl_orders o ON (d.id_order = o.id_order) 
    LEFT JOIN pskl_customer g ON (o.id_customer = g.id_customer) 
    LEFT JOIN pskl_carrier c ON (o.id_carrier = c.id_carrier) 
    LEFT JOIN pskl_address a ON (a.id_address = o.id_address_delivery) 
    LEFT JOIN pskl_order_state os ON o.current_state = os.id_order_state
    LEFT JOIN pskl_order_state_lang osl ON os.id_order_state = osl.id_order_state

GROUP BY
    d.id_order 
ORDER BY
    d.id_order DESC;