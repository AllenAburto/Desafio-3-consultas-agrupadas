-- CREAR TABLAS

create table usuarios (id serial primary key, email varchar(255) not null, nombre varchar(255) not null, apellido varchar(255) not null, rol varchar (50) not null);

create table posts (id serial PRIMARY KEY, titulo varchar(255) not null, contenido text not null, fecha_creacion TIMESTAMP not null, fecha_actualizacion TIMESTAMP not null, destacado BOOLEAN not null, usuario_id BIGINT REFERENCES usuarios(id));

create table comentarios (id serial PRIMARY KEY, contenido text not null, fecha_creacion TIMESTAMP not null, usuario_id BIGINT REFERENCES usuarios(id), post_id BIGINT REFERENCES posts(id));


--INGRESO DE DATOS

INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('Dario@DESAFIO.com', 'Dario', 'Perez', 'administrador'), ('mario@LATAM.com', 'Mario', 'lopez', 'usuario'), ('carlita@PROGRAM.com', 'Carlita', 'Garcia', 'usuario'), ('ana@MINSAIT.com', 'Ana', 'Sanchez', 'usuario'), ('luis@DEKOS.com', 'Luis', 'Ramirez', 'usuario');

INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('la vida de hoy', 'ya nada es como antes', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, true, 1), ('SQL la nueva forma de trabajo', 'hoy en dia los trabajos son mas sencillos en cuanto a volumetría de informacion', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false, 1), ('¿Qué mas debemos esperar?', 'trabajo trabajo y mas trabajo para ser alguien', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, true, 2), ('asi no mas con las cosas', 'que mas decir, asi no mas ☹', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false, 3), ('falto poco para terminar realmente estoy escribiendo por escribir', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false, NULL);

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES ('podemos definir que este comentario es voraz', CURRENT_TIMESTAMP, 1, 1), ('que seguir haciendo con mas comentarios como este', CURRENT_TIMESTAMP, 2, 1), ('que me puedo preguntar, si ya me he preguntado todo.', CURRENT_TIMESTAMP, 3, 1), ('parece de tres chiflados', CURRENT_TIMESTAMP, 1, 2), ('asi no mas con la vida, es lo mismo pero todo lo contrario', CURRENT_TIMESTAMP, 2, 2);


--Requerimiento 2

SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
JOIN posts p ON u.id = p.usuario_id;

--Requerimiento 3

SELECT p.id, p.titulo, p.contenido
FROM posts p
JOIN usuarios u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';


--Requerimiento 4

SELECT u.id, u.email, COUNT(p.id) as total_posts
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

--Requerimiento 5

SELECT u.email
FROM usuarios u
JOIN posts p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

--Requerimiento 6

SELECT u.nombre, MAX(p.fecha_creacion) as "ultima fecha post"
FROM usuarios u
JOIN posts p ON u.id = p.usuario_id
GROUP BY u.nombre;

--Requerimiento 7

SELECT p.titulo, p.contenido
FROM posts p
JOIN comentarios c ON p.id = c.post_id
GROUP BY p.id
ORDER BY COUNT(c.id) DESC
LIMIT 1;

--Requerimiento 8

SELECT p.titulo, p.contenido, c.contenido as comentario, u.email
FROM posts p
JOIN comentarios c ON p.id = c.post_id
JOIN usuarios u ON c.usuario_id = u.id;

--Requerimiento 9

SELECT u.email, c.contenido
FROM usuarios u
JOIN comentarios c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (
    SELECT MAX(fecha_creacion)
    FROM comentarios
    WHERE usuario_id = u.id);

--Requerimiento 10

SELECT u.email
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;