SELECT
    o.reference AS OrderReference,
    d.product_reference AS ItemEan,
    d.product_quantity AS Qty,
    -- Add more columns as needed
    'OriginValue' AS Origin, -- Replace 'OriginValue' with the actual source/origin information
    'ShippingMethodValue' AS ShippingMethod, -- Replace 'ShippingMethodValue' with the actual shipping method information
    'ShippingPointRetraitValue' AS ShippingPointRetrait, -- Replace 'ShippingPointRetraitValue' with the actual shipping point/retrait information
    '' AS ClientCode,
    '' AS ClientGln, -- Assuming GLN is a column in the customer table
    g.email AS Email,
    CONCAT_WS(' ', g.firstname, g.lastname) AS Name,
    a.phone AS PhoneNumber,
    CONCAT_WS(' ', a.address1) AS Address1,
    a.address2 AS Address2,
    a.postcode AS PostalCode,
    a.city AS City,
    c.name AS Country
    -- Add more columns as needed
FROM
    pskl_order_detail d 
    LEFT JOIN pskl_orders o ON (d.id_order = o.id_order) 
    LEFT JOIN pskl_customer g ON (o.id_customer = g.id_customer) 
    LEFT JOIN pskl_carrier c ON (o.id_carrier = c.id_carrier) 
    LEFT JOIN pskl_address a ON (a.id_address = o.id_address_delivery) 
    -- Add more joins as needed
GROUP BY
    d.id_order 
ORDER BY
    d.id_order DESC;