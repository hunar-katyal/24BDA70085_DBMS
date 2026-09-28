DROP TABLE bank_customer;

CREATE TABLE bank_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    balance NUMERIC(10,2)
);

DROP TABLE customer_audit;

CREATE TABLE customer_audit (
    audit_id SERIAL PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(50),
    action VARCHAR(20),
    action_time TIMESTAMP
);

INSERT INTO bank_customer VALUES
(1, 'Rahul', 50000),
(2, 'Neha', 75000);



CREATE FUNCTION audit_customer()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO customer_audit
        VALUES (DEFAULT, NEW.customer_id, NEW.customer_name,
                'ADDED', CURRENT_TIMESTAMP);

    ELSE
        INSERT INTO customer_audit
        VALUES (DEFAULT, OLD.customer_id, OLD.customer_name,
                'REMOVED', CURRENT_TIMESTAMP);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER customer_trigger
AFTER INSERT OR DELETE ON bank_customer
FOR EACH ROW
EXECUTE FUNCTION audit_customer();

INSERT INTO bank_customer VALUES
(3, 'Rahul', 50000),
(4, 'Neha', 75000);

DELETE FROM bank_customer WHERE customer_id = 3;

SELECT * FROM customer_audit;