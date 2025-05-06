CREATE DATABASE IF NOT EXISTS vacantes_BBDD_2025_RETO;
USE vacantes_BBDD_2025_RETO;

CREATE TABLE IF NOT EXISTS Categorias (
  id_categoria INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(2000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS Usuarios (
  email VARCHAR(45) NOT NULL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  password VARCHAR(100) NOT NULL,
  enabled INT NOT NULL DEFAULT 1,
  fecha_Registro DATE,
  rol VARCHAR(15) NOT NULL,
  CHECK (ROL IN ('EMPRESA', 'ADMON', 'CLIENTE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS Empresas (
  id_empresa INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cif VARCHAR(10) NOT NULL UNIQUE,
  nombre_empresa VARCHAR(100) NOT NULL,
  direccion_fiscal VARCHAR(100),
  pais VARCHAR(45),
  email VARCHAR(45),
  FOREIGN KEY (email) REFERENCES Usuarios(email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS Vacantes (
  id_vacante INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(200) NOT NULL,
  descripcion TEXT NOT NULL,
  fecha DATE NOT NULL,
  salario DOUBLE NOT NULL,
  estatus ENUM('CREADA','CUBIERTA','CANCELADA') NOT NULL,
  destacado TINYINT NOT NULL,
  imagen VARCHAR(250) NOT NULL,
  detalles TEXT NOT NULL,
  id_Categoria INT NOT NULL,
  id_empresa INT NOT NULL,
  PRIMARY KEY (id_vacante),
  FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria),
  FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS Solicitudes (
  id_solicitud INT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  archivo VARCHAR(250) NOT NULL,
  comentarios VARCHAR(2000),
  estado TINYINT NOT NULL DEFAULT 0,
  curriculum VARCHAR(45),
  id_Vacante INT NOT NULL,
  email VARCHAR(45) NOT NULL,
  PRIMARY KEY (id_solicitud),
  UNIQUE (id_Vacante, email),
  FOREIGN KEY (email) REFERENCES Usuarios(email),
  FOREIGN KEY (id_Vacante) REFERENCES Vacantes(id_vacante)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert de usuarios
INSERT INTO Usuarios (email, nombre, apellidos, password, rol, enabled) VALUES
('admin@correo.com', 'Admin', 'Sistema', '{noop}admin', 'ADMON', 1),
('empresa@correo.com', 'Empresa', 'Empresario', '{noop}empresa', 'EMPRESA', 1),
('empresa2@correo.com', 'Empr', 'Empresa', '{noop}empresa2', 'EMPRESA', 1),
('usuario@correo.com', 'Usuario', 'cliente', '{noop}1234', 'CLIENTE', 1);

-- Categorías
INSERT INTO Categorias (nombre, descripcion) VALUES
('Desarrollo Web', 'Trabajos relacionados con desarrollo frontend, backend y full stack.'),
('Marketing Digital', 'Publicidad en línea, SEO, SEM, redes sociales.'),
('Atención al Cliente', 'Soporte a clientes por teléfono, chat o correo.'),
('Diseño Gráfico', 'Diseño de material visual y branding.');

-- Empresas (asociadas a usuarios ya registrados)
INSERT INTO Empresas (cif, nombre_empresa, direccion_fiscal, pais, email) VALUES
('A12345678', 'Tech Solutions S.A.', 'Calle Falsa 123', 'España', 'empresa@correo.com'),
('B87654321', 'Marketing Pro SL', 'Av. Digital 456', 'España', 'empresa2@correo.com');

-- Vacantes
INSERT INTO Vacantes (nombre, descripcion, fecha, salario, estatus, destacado, imagen, detalles, id_categoria, id_empresa) VALUES
('Desarrollador Frontend Angular', 'Se busca frontend con experiencia en Angular.', CURDATE(), 28000, 'CREADA', 1, 'https://picsum.photos/id/237/800/400', 'Trabajo presencial en Madrid.', 1, 1),
('Especialista en SEO', 'Optimización de motores de búsqueda.', CURDATE(), 24000, 'CREADA', 0, 'https://images.unsplash.com/photo-1508830524289-0adcbe822b40?auto=format&fit=crop&w=800&q=80', 'Remoto 100%.', 2, 2),
('Atención al cliente - Chat', 'Responder consultas por chat.', CURDATE(), 18000, 'CREADA', 0, 'https://images.unsplash.com/photo-1585222515068-7201a72c4181?auto=format&fit=crop&w=800&q=80', 'Turno de mañana.', 3, 1),
('Diseñador UI/UX', 'Diseño de interfaces y experiencia de usuario.', CURDATE(), 30000, 'CREADA', 1, 'https://picsum.photos/id/1011/800/400', 'Figma, Adobe XD.', 4, 1);

-- Solicitudes
INSERT INTO Solicitudes (fecha, archivo, comentarios, curriculum, id_vacante, email) VALUES
(CURDATE(), 'cv_usuario.pdf', 'Estoy muy interesado en esta vacante.', 'cv_usuario.pdf', 1, 'usuario@correo.com'),
(CURDATE(), 'cv_usuario.pdf', 'Tengo experiencia previa.', 'cv_usuario.pdf', 2, 'usuario@correo.com');
