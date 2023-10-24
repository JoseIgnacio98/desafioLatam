--- CREACION TABLA ----
CREATE TABLE usuarios (
    id serial PRIMARY KEY,
    email varchar(50),
    nombre varchar(50),
    apellido varchar(50),
    rol varchar(50),
    CHECK (rol IN ('administrador', 'usuario'))
);
INSERT INTO usuarios (email,nombre,apellido,rol) values ('usuario1@gmail.com', 'Jose', 'Toledo','administrador');
INSERT INTO usuarios (email,nombre,apellido,rol) values ('usuario2@gmail.com', 'Ignacio', 'Rebolledo','usuario');
INSERT INTO usuarios (email,nombre,apellido,rol) values ('usuario3@gmail.com', 'Juan', 'Perez','usuario');
INSERT INTO usuarios (email,nombre,apellido,rol) values ('usuario4@gmail.com', 'Pedro', 'Gonzalez','usuario');
INSERT INTO usuarios (email,nombre,apellido,rol) values('usuario5@gmail.com', 'Victor', 'Galvez','administrador');

CREATE TABLE posts (
    id serial PRIMARY KEY,
    titulo varchar(50),
    contenido text,
    fecha_creacion timestamp,
    fecha_actualizacion timestamp,
    destacado boolean,
	usuario_id bigint
);

INSERT INTO posts (titulo,contenido,fecha_creacion,fecha_actualizacion,usuario_id) values ('Game Of Thrones', 'Danza y LLuvia', '10-10-2016','10-10-2021','1');
INSERT INTO posts (titulo,contenido,fecha_creacion,fecha_actualizacion,usuario_id) values ('Harry Potter', 'Piedra Filosofal', '07-31-2001','10-10-2010','1');
INSERT INTO posts (titulo,contenido,fecha_creacion,fecha_actualizacion,usuario_id) values ('El señor de los Anillos', 'Tomo1 ', '10-01-2002','05-23-2008','2');
INSERT INTO posts (titulo,contenido,fecha_creacion,fecha_actualizacion,usuario_id) values ('It', 'Primera Parte', '10-03-1998','10-10-1999','4');
INSERT INTO posts (titulo,contenido,fecha_creacion,fecha_actualizacion,usuario_id) values ('Star Wars', 'Jedi','03-02-1985','10-10-1985',null);

CREATE TABLE comentarios (
    id serial PRIMARY KEY,
    contenido varchar(50),
    fecha_creacion timestamp,
	usuario_id bigint,
	post_id bigint
);

INSERT INTO comentarios (contenido,fecha_creacion,usuario_id,post_id) values ('Inicio del libro lento', '10-10-2016','1','1');
INSERT INTO comentarios (contenido,fecha_creacion,usuario_id,post_id) values ('Buena historia', '07-31-2001','2','1');
INSERT INTO comentarios (contenido,fecha_creacion,usuario_id,post_id) values ('Libro muy extenso','10-01-2002','3','1');
INSERT INTO comentarios (contenido,fecha_creacion,usuario_id,post_id) values ('Novela llena de suspenso','10-01-2003','1','2');
INSERT INTO comentarios (contenido,fecha_creacion,usuario_id,post_id) values ('Entretenida de principio a fin','10-01-2001','2','2');

select * from comentarios;

SELECT u.nombre, u.email, p.titulo, p.contenido from usuarios u INNER JOIN posts p ON p.usuario_id = u.id;


/* 3. Muestra el id, título y contenido de los posts de los administradores.
a. El administrador puede ser cualquier id.
(1 Punto). */
SELECT u.id, p.titulo, p.contenido from usuarios u INNER JOIN posts p ON p.usuario_id = u.id WHERE u.rol = 'administrador';

/* 4. Cuenta la cantidad de posts de cada usuario.
a. La tabla resultante debe mostrar el id e email del usuario junto con la
cantidad de posts de cada usuario. (1 Punto)
Hint: Aquí hay diferencia entre utilizar inner join, left join o right join, prueba con todas y con eso determina cuál es la correcta. No da lo mismo la tabla desde la que se parte. */

SELECT u.id , u.email , count(p.usuario_id) CONTADOR_PUBLICACION FROM usuarios u LEFT JOIN posts p ON p.usuario_id = u.id GROUP BY u.id, u.email ORDER BY CONTADOR_PUBLICACION DESC ;

/* 5. Muestra el email del usuario que ha creado más posts.
a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
(1 Punto) */

select u.email from usuarios as u left join posts as p on u.id = p.usuario_id group by u.email order by count (u.id) desc limit 1;

/* 6. Muestra la fecha del último post de cada usuario. (1 Punto) */
SELECT u.id, u.email AS correo_usuario, MAX(p.fecha_actualizacion) 
FROM usuarios AS u
LEFT JOIN posts AS p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

/* 7 Muestra el título y contenido del post (artículo) con más comentarios.
(1 Punto) */
select p.titulo, p.contenido from posts p INNER JOIN comentarios c ON c.post_id = p.id group by p.id ORDER by count(p.id) desc limit 1;

/* 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, 
junto con el email del usuario que lo escribió.
(1 Punto) */
select p.titulo, p.contenido, c.contenido, u.email FROM posts p INNER JOIN comentarios c ON c.post_id = p.id INNER JOIN usuarios u ON u.id = p.usuario_id;

/* 9. Muestra el contenido del último comentario de cada usuario. (1 Punto) */
SELECT u.email, u.nombre , c.contenido AS ultimo_comentario
FROM usuarios AS u
LEFT JOIN comentarios AS c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (
    SELECT MAX(fecha_creacion)
    FROM comentarios
    WHERE usuario_id = u.id
);
/* 10. Muestra los emails de los usuarios que no han escrito ningún comentario. (1 Punto) */

SELECT  u.email FROM  usuarios u LEFT JOIN comentarios c ON c.usuario_id = u.id WHERE c.id is null;
