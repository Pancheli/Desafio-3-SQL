-- Se crea la base de datos:
CREATE DATABASE desafio3_Francisco_Arce_003;

-- Se crea la tabla de los usuarios:
CREATE TABLE usuarios(
    id SERIAL,
    email VARCHAR,
    nombre VARCHAR,
    apellido VARCHAR rol VARCHAR
);

--Se agregan los 5 usuarios a la tabla:
INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES (
        'pancho.arce@fmail.com',
        'Francisco',
        'Arce',
        'Administrador'
    );

INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES (
        'morty.smith@fmail.com',
        'Morty',
        'Smith',
        'Administrador'
    );

INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES (
        'jim.halper@fmail.com',
        'Jim',
        'Halper',
        'Usuario'
    );

INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES (
        'pam.beesley@fmail.com',
        'Pamela',
        'Beesley',
        'Usuario'
    );

INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES (
        'dwight.schrute@fmail.com',
        'Dwight',
        'Schrute',
        'Usuario'
    );

--Se crea la tabla de articulos:
CREATE TABLE articulos(
    id SERIAL,
    titulo VARCHAR,
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT
);

-- Se agregan 5 posts:
INSERT INTO articulos (
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado,
        usuario_id
    )
VALUES (
        'Saludos!',
        'Holaa ! tanto tiempoooo! muy buena página!',
        '01/01/2001',
        '01/02/2021',
        true,
        1
    );
INSERT INTO articulos (
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado,
        usuario_id
    )
VALUES (
        '¡Hola!',
        '¡Hola! ¡Cómo están!',
        '07/07/2007 09:01:01',
        '07/07/2027 09:01:00',
        true,
        2
    );
INSERT INTO articulos (
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado,
        usuario_id
    )
VALUES (
        'Muy buenos días!!!',
        '¡Holaaa!, muy buenos días! ¿cómo están?, es un excelente día para madrugaaaaar',
        '01/12/2004 05:00:00',
        '19/12/2022 05:00:01',
        true,
        3
    );
INSERT INTO articulos (
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado,
        usuario_id
    )
VALUES (
        '¡¡¡ Felices fiestaasss !!!',
        'Les deseo unas felices Fiestas a todos!, hoy es un gran día, para festejar y sonreir',
        '04/04/2010 10:00:00',
        '29/07/2022 12:00:00',
        false,
        4
    );
INSERT INTO articulos (
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado
    )
VALUES (
        '¡¡¡Feliz Año Nuevo!!!',
        'FELIZ AÑO NUEVO A TODOOOOOOOOOOOS!!',
        '31/12/2022 12:00:10',
        '31/12/2030 14:00:00',
        true
    );

--Se crea la tabla de comentarios:
CREATE TABLE comentarios(
    id SERIAL,
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);

--Se agregan los comentarios en la tabla:
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('¡Muy buen comentario!!', '05/12/2030', 1, 1);

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('¡La vida es bellllaaaaa!', '12/12/2040', 2, 1);

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('¡¡¡ Síii !!!, Sonreir hace bien para la salud', '30/12/2050', 3, 1);

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('¡¡¡ Jajaja reirse es geniaaal!!!', '25/11/2090', 1, 2);

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('¡¡¡ Qué buenaaaa :DDDD!!!', '20/12/2090', 2, 2);


-- Paso 2: Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas: nombre e email del usuario, junto al título y contenido del post
SELECT usuarios.nombre,
    usuarios.email,
    articulos.titulo,
    articulos.contenido
FROM usuarios
    INNER JOIN articulos ON usuarios.id = articulos.usuario_id;

-- Paso 3:!! Muestra el id, título y contenido de los posts de los Administradores. El Administrador puede ser cualquier id y debe ser seleccionado dinámicamente!
SELECT articulos.id,
    articulos.titulo,
    articulos.contenido
FROM articulos
    INNER JOIN usuarios ON usuarios.id = articulos.usuario_id
    AND rol = 'Administrador';

-- 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario, junto con la cantidad de posts de cada usuario :DD! 
--*Aquí hay una diferencia entre utilizar INNER JOIN, LEFT JOIN o RIGHT JOIN, prueba con todas, y con eso determina cuál es la correcta :DDD! No da lo mismo desde cual tabla partes:
SELECT usuarios.id,
    usuarios.email,
    COUNT(articulos.id)
FROM usuarios
    LEFT JOIN articulos ON usuarios.id = articulos.usuario_id
GROUP BY usuarios.id,
    usuarios.email;

-- 5. Muestra el email del usuario que ha creado más posts.
-- Aquí la tabla resultante tiene un único registro y muestra solo el email:
SELECT usuarios.email
FROM usuarios
    INNER JOIN (
        SELECT usuario_id,
            count(usuario_id) AS contandoarticulos
        FROM articulos
        GROUP BY usuario_id
        ORDER BY contandoarticulos DESC
        LIMIT 1
    ) AS moreposts ON usuarios.id = moreposts.usuario_id;

-- 6. Muestra la fecha del último posts de cada usuario *
--Utiliza la función de agregado MAX sobre la fecha de creación:
SELECT usuarios.nombre,
    MAX(articulos.fecha_creacion) AS ultimopost
FROM usuarios
    INNER JOIN articulos ON usuarios.id = articulos.usuario_id
GROUP BY usuarios.nombre;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios:
SELECT titulo,
    contenido
FROM articulos
    JOIN (
        SELECT post_id,
            COUNT(post_id)
        FROM comentarios
        GROUP BY post_id
        ORDER BY COUNT(post_id) DESC
        LIMIT 1
    ) AS content ON articulos.id = content.post_id;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post
-- y el contenido de cada comentario asociado a lo posts mostrados junto con el email del usuario que lo escribió:
SELECT articulos.titulo,
    articulos.contenido,
    comentarios.contenido,
    usuarios.email
FROM articulos
    LEFT JOIN comentarios ON articulos.id = comentarios.post_id
    INNER JOIN usuarios ON articulos.usuario_id = usuarios.id;

-- 9. Muestra el contenido del último comentario de cada usuario:
SELECT comentarios.contenido
FROM comentarios
    INNER JOIN (
        SELECT usuario_id,
            MAX(fecha_creacion) AS maxfechawenaonda
        FROM comentarios
        GROUP BY usuario_id
    ) AS commentuserid ON commentuserid.maxfechawenaonda = comentarios.fecha_creacion;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario:
SELECT usuarios.email
FROM usuarios
    LEFT JOIN comentarios ON usuarios.id = comentarios.usuario_id
GROUP BY usuarios.email
HAVING count(comentarios.usuario_id) = 0;