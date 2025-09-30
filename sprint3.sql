  USE transactions;
  
-- Creamos la tabla cerdit_card
	CREATE TABLE IF NOT EXISTS credit_card (
		id VARCHAR(20) PRIMARY KEY,
		iban VARCHAR(34),
		pan VARCHAR(225),
		pin VARCHAR(4),
		cvv VARCHAR(3),
		expiring_date VARCHAR(10)
    );

ALTER TABLE credit_card
MODIFY COLUMN pan VARCHAR(255); #Esta modificación la hice porque algunos datos son mayores y con VARCHAR(14)  

-- Relacionar la tabla credit_card con las tablas transaction y company.
-- Esta relación es adecuada porque la tabla transaction ya tiene un foreign key que la relaciona con la tabla company. 
-- Ahora creo una foreign key que la ralaciona con la tabla credit card.
ALTER TABLE transaction
ADD CONSTRAINT fk_credit_card_id_transaction
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

/*
Ejercicio 2: 
El departamento de Recursos Humanos ha identificado un error en 
el número de cuenta asociado a su tarjeta de crédito con ID CcU-2938. 
La información que debe mostrarse para este registro es: TR323456312213576817699999. 
Recuerda mostrar que el cambio se realizó.
*/
UPDATE credit_card 
SET iban = 'TR323456312213576817699999' 
WHERE id = 'CcU-2938'; 

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

/*
Ejercicio 3: En la tabla "transaction" ingresa una nueva transacción con la siguiente información:
*/
-- verificación de existencia de alguna compañia con id= 'b-9999'
SELECT *
FROM company
WHERE id ='b-9999';
-- verificación de existencia de alguna tarjeta de credito con id= 'CcU-9999'
SELECT *
FROM credit_card
WHERE id ='CcU-9999';
-- crear un registro en company con id='b-9999'
INSERT INTO company (id)
VALUES ('b-9999');
-- crear un registro en credit_card con id=
INSERT INTO credit_card (id)
VALUES ('CcU-9999');
-- crear registro en la tabla transaction
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');
/*
Ejercicio 4: 
Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card. 
Recuerda mostrar el cambio realizado.
*/

ALTER TABLE credit_card
DROP COLUMN pan;

/* Nivel 2
Ejercicio 1
Elimina de la tabla transacción el registro con ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos.
*/
DELETE FROM transaction
WHERE ID='000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

/*
Ejercicio 2
La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. 
Será necesario que crees una vista llamada VistaMarketing que contenga la siguiente información: 
Nombre de la compañía. Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía.
Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.
*/


CREATE VIEW VistaMarketing AS
SELECT c.company_name, c.phone, c.country, ROUND(AVG(t.amount),2) AS avg_amount
FROM company c
INNER JOIN transaction t ON c.id =t.company_id
GROUP BY c.id
ORDER BY avg_amount DESC;

/*
Ejercicio 3
Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"
*/
SELECT *
FROM VistaMarketing
WHERE country='Germany';

/*
Nivel 3
Ejercicio 1:
La próxima semana tendrás una nueva reunión con los gerentes de marketing. 
Un compañero de tu equipo realizó modificaciones en la base de datos, pero no recuerda cómo las realizó. 
Te pide que le ayudes a dejar los comandos ejecutados para obtener el siguiente diagrama:
*/

CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);
DESCRIBE transaction;

ALTER TABLE transaction
MODIFY user_id CHAR(10) NOT NULL;

-- verificar existencia de id= '9999' en user
SELECT *
FROM user
WHERE id ='9999';

-- crear un registro en user con id='9999'
INSERT INTO user (id)
VALUES ('9999');

-- Relacionar la tabla transaction con la tabla user
ALTER TABLE transaction
ADD CONSTRAINT fk_user_id_transaction
FOREIGN KEY (user_id) REFERENCES user(id);

-- Eliminar foreing key user_id
ALTER TABLE transaction
  DROP FOREIGN KEY fk_user_id_transaction;
-- renombrar tabla
RENAME TABLE user TO data_user;
-- cracion de nueva columan
ALTER TABLE data_user
ADD id2 INT;

-- Desactivar el modo seguro
SET SQL_SAFE_UPDATES = 0;
-- Copiar los valores de id a id2 convirtiéndolos a entero
UPDATE data_user
SET id2 = CAST(TRIM(id) AS UNSIGNED)
WHERE id IS NOT NULL;
-- Volver a activar el modo seguro
SET SQL_SAFE_UPDATES = 1;
-- renombrar columna email
ALTER TABLE data_user
RENAME COLUMN email TO personal_email;
-- renombrar la columan id a user_id
ALTER TABLE data_user
RENAME COLUMN id TO user_id;
-- renombrar la columan id2 a id
ALTER TABLE data_user
RENAME COLUMN id2 TO id;
-- quitar primary ker de user_id
ALTER TABLE data_user
DROP PRIMARY KEY;
-- hacer primary key a nueva columna id
ALTER TABLE data_user
ADD PRIMARY KEY (id);
-- cambiar id al principio de las columnas
ALTER TABLE data_user
MODIFY COLUMN id INT FIRST;
-- relacionar la tabla transaction con la tabla user_id
-- Agregar una columan nueca user_id_int en transaction
ALTER TABLE transaction
ADD COLUMN user_id_int INT;
-- ubicar la nueva columan despues de la columna_company 
ALTER TABLE transaction
MODIFY COLUMN user_id_int INT AFTER company_id;
-- 
-- Desactivar el modo seguro
SET SQL_SAFE_UPDATES = 0;
-- copiar datos de user_id a user_id_int
UPDATE transaction
SET user_id_int = CAST(TRIM(user_id) AS UNSIGNED)
WHERE user_id IS NOT NULL;
-- Volver a activar el modo seguro
SET SQL_SAFE_UPDATES = 1;
-- renombrar_columan user_id a user_id_anterior
ALTER TABLE transaction
RENAME COLUMN user_id TO user_id_anterior;
-- renombrar_columan user_id_int a user_id
ALTER TABLE transaction
RENAME COLUMN user_id_int TO user_id;

-- Cambios para obetner la tabla credit_card
ALTER TABLE credit_card
MODIFY iban VARCHAR(50) NULL;

ALTER TABLE credit_card
MODIFY cvv INT NULL,
MODIFY expiring_date VARCHAR (20) NULL;

ALTER TABLE credit_card
ADD COLUMN fecha_actual DATE;

/* Todos los cambios para obtener credit_card se pudieron hacer en una query, pero lo hice paso a paso.
Otra forma hubiera sido la siguiente:

ALTER TABLE credit_card
MODIFY iban VARCHAR(50) NULL,
MODIFY cvv INT NULL,
MODIFY expiring_date VARCHAR (20) NULL,
ADD COLUMN fecha_actual DATE;
 */
ALTER TABLE company
DROP COLUMN website;

ALTER TABLE data_user
DROP COLUMN user_id;
ALTER TABLE transaction
DROP COLUMN user_id_anterior;

ALTER TABLE transaction
ADD CONSTRAINT fk_user_id_transaction
FOREIGN KEY (user_id) REFERENCES data_user(id);

-- Ejercicio 2 nivel 3
/*
La empresa también le pide crear una vista llamada "InformeTecnico" que contenga la siguiente información:

•	ID de la transacción
•	Nombre del usuario/a
•	Apellido del usuario/a
•	IBAN de la tarjeta de crédito usada.
•	Nombre de la compañía de la transacción realizada.
•	Asegúrese de incluir información relevante de las tablas que conocerá y utilice alias para cambiar de nombre columnas según sea necesario.

Muestra los resultados de la vista, ordena los resultados de forma descendente en función de la variable ID de transacción.
*/

CREATE VIEW InformeTecnico AS
SELECT t.id AS id_transaccion, d.name AS nombre_usuario, d.surname AS apellido, cc.iban AS IBAN, c.company_name AS compania 
FROM transaction t
INNER JOIN  data_user d ON  t.user_id = d.id
INNER JOIN credit_card cc ON t.credit_card_id =cc.id
INNER JOIN company c ON t.company_id = c.id
ORDER BY id_transaccion DESC; 