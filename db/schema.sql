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

-- Insert data for Usuarios (diferentes roles: EMPRESA, ADMON, CLIENTE)
INSERT INTO Usuarios (email, nombre, apellidos, password, enabled, fecha_Registro, rol) VALUES 
-- Administradores
('admin@empleoreto.com', 'Carlos', 'Rodríguez López', '{noop}admin123', 1, '2024-01-10', 'ADMON'),
('admin2@empleoreto.com', 'Ana', 'García Pérez', '{noop}admin456', 1, '2024-01-15', 'ADMON'),

-- Empresas
('rrhh@tecnosoluciones.com', 'Laura', 'Martínez Sánchez', '{noop}empresa123', 1, '2024-01-20', 'EMPRESA'),
('seleccion@marketingdigital.com', 'Miguel', 'Fernández Gómez', '{noop}empresa456', 1, '2024-01-25', 'EMPRESA'),
('empleo@financonsulting.com', 'Isabel', 'López Torres', '{noop}empresa789', 1, '2024-02-01', 'EMPRESA'),
('talento@recursoshumanos.com', 'Javier', 'González Ruiz', '{noop}empresa101', 1, '2024-02-05', 'EMPRESA'),
('careers@salesforce.com', 'Elena', 'Díaz Moreno', '{noop}empresa202', 1, '2024-02-10', 'EMPRESA'),
('empleo@hospitalcentral.com', 'Alejandro', 'Sánchez Vidal', '{noop}empresa303', 1, '2024-02-15', 'EMPRESA'),
('jobs@universidadmoderna.com', 'Patricia', 'Ramírez Castro', '{noop}empresa404', 1, '2024-02-20', 'EMPRESA'),
('contratacion@bufetejuridico.com', 'Roberto', 'Navarro Ortiz', '{noop}empresa505', 1, '2024-02-25', 'EMPRESA'),
('rrhh@ingenieriaavanzada.com', 'Carmen', 'Molina Serrano', '{noop}empresa606', 1, '2024-03-01', 'EMPRESA'),
('empleo@adminprofesional.com', 'Jorge', 'Herrera Blanco', '{noop}empresa707', 0, '2024-03-05', 'EMPRESA'), -- Empresa deshabilitada

-- Clientes (solicitantes de empleo)
('juan.perez@mail.com', 'Juan', 'Pérez García', '{noop}cliente123', 1, '2024-03-10', 'CLIENTE'),
('maria.lopez@mail.com', 'María', 'López Sánchez', '{noop}cliente456', 1, '2024-03-15', 'CLIENTE'),
('pablo.martinez@mail.com', 'Pablo', 'Martínez Díaz', '{noop}cliente789', 1, '2024-03-20', 'CLIENTE'),
('lucia.rodriguez@mail.com', 'Lucía', 'Rodríguez Gómez', '{noop}cliente101', 1, '2024-03-25', 'CLIENTE'),
('sergio.garcia@mail.com', 'Sergio', 'García Fernández', '{noop}cliente202', 1, '2024-04-01', 'CLIENTE'),
('ana.fernandez@mail.com', 'Ana', 'Fernández Moreno', '{noop}cliente303', 1, '2024-04-05', 'CLIENTE'),
('david.sanchez@mail.com', 'David', 'Sánchez Ruiz', '{noop}cliente404', 1, '2024-04-10', 'CLIENTE'),
('laura.gomez@mail.com', 'Laura', 'Gómez Torres', '{noop}cliente505', 0, '2024-04-15', 'CLIENTE'), -- Cliente deshabilitado
('carlos.torres@mail.com', 'Carlos', 'Torres Vidal', '{noop}cliente606', 1, '2024-04-20', 'CLIENTE'),
('elena.diaz@mail.com', 'Elena', 'Díaz Castro', '{noop}cliente707', 1, '2024-04-25', 'CLIENTE');

-- Insert data for Categorias
INSERT INTO Categorias (nombre, descripcion) VALUES 
('Tecnología', 'Puestos relacionados con desarrollo de software, administración de sistemas, seguridad informática y otras áreas de tecnología.'),
('Marketing', 'Puestos relacionados con marketing digital, relaciones públicas, gestión de redes sociales y estrategias de mercado.'),
('Finanzas', 'Puestos relacionados con contabilidad, análisis financiero, inversiones y gestión económica.'),
('Recursos Humanos', 'Puestos relacionados con selección de personal, formación, gestión del talento y relaciones laborales.'),
('Ventas', 'Puestos relacionados con ventas, desarrollo de negocio, atención al cliente y comercial.'),
('Administración', 'Puestos relacionados con gestión administrativa, secretariado y soporte a dirección.'),
('Sanidad', 'Puestos relacionados con medicina, enfermería, farmacia y otros servicios sanitarios.'),
('Educación', 'Puestos relacionados con enseñanza, formación y divulgación de conocimientos.'),
('Legal', 'Puestos relacionados con asesoría jurídica, abogacía y cumplimiento normativo.'),
('Ingeniería', 'Puestos relacionados con ingeniería civil, mecánica, eléctrica y otras especialidades.');

-- Insert data for Empresas
INSERT INTO Empresas (cif, nombre_empresa, direccion_fiscal, pais, email) VALUES 
('B12345678', 'TecnoSoluciones S.L.', 'Calle Innovación, 23, Madrid', 'España', 'rrhh@tecnosoluciones.com'),
('A87654321', 'Marketing Digital S.A.', 'Av. Publicidad, 45, Barcelona', 'España', 'seleccion@marketingdigital.com'),
('C55555555', 'FinanConsulting S.A.', 'Calle Inversiones, 12, Valencia', 'España', 'empleo@financonsulting.com'),
('D11111111', 'Recursos Humanos Integrales S.L.', 'Av. Talento, 78, Sevilla', 'España', 'talento@recursoshumanos.com'),
('E22222222', 'SalesForce Iberia S.A.', 'Plaza Ventas, Tecnería, 34, Bilbao', 'España', 'careers@salesforce.com'),
('F33333333', 'Hospital Central S.A.', 'Av. Salud, 100, Zaragoza', 'España', 'empleo@hospitalcentral.com'),
('G44444444', 'Universidad Moderna', 'Campus Universitario, s/n, Salamanca', 'España', 'jobs@universidadmoderna.com'),
('H66666666', 'Bufete Jurídico Internacional S.L.P.', 'Calle Justicia, 55, Madrid', 'España', 'contratacion@bufetejuridico.com'),
('J77777777', 'Ingeniería Avanzada S.A.', 'Parque Tecnológico, 88, Valencia', 'España', 'rrhh@ingenieriaavanzada.com'),
('K88888888', 'Administración Profesional S.L.', 'Calle Gestión, 99, Barcelona', 'España', 'empleo@adminprofesional.com');

-- Insert data for Vacantes (con diferentes estados: CREADA, CUBIERTA, CANCELADA)
INSERT INTO Vacantes (nombre, descripcion, fecha, salario, estatus, destacado, imagen, detalles, id_Categoria, id_empresa) VALUES 
-- Vacantes de TecnoSoluciones (id_empresa = 1, categoría Tecnología)
('Desarrollador Full Stack', 'Buscamos desarrollador con experiencia en React y Node.js', '2025-01-15', 35000.00, 'CREADA', 1, 'https://img.freepik.com/free-photo/programming-code-abstract-technology-background_34663-31.jpg', 'Requisitos: 3 años de experiencia, conocimientos avanzados de JavaScript, trabajo en equipo, idioma inglés nivel alto. Ofrecemos: Horario flexible, teletrabajo 3 días a la semana, formación continua, plan de carrera.', 1, 1),
('DevOps Engineer', 'Se necesita ingeniero con experiencia en AWS y Docker', '2025-01-20', 42000.00, 'CREADA', 0, 'https://img.freepik.com/free-photo/server-room-rack-corridor-datacenter_1150-12312.jpg', 'Requisitos: Experiencia en CI/CD, Linux, Kubernetes, monitorización. Ofrecemos: Proyecto estable, equipo internacional, posibilidad de certificaciones pagadas por la empresa.', 1, 1),
('Data Scientist', 'Buscamos científico de datos con experiencia en machine learning', '2025-01-25', 45000.00, 'CUBIERTA', 1, 'https://img.freepik.com/free-photo/data-information-knowledge-research-facts-concept_53876-125219.jpg', 'Requisitos: Conocimientos de Python, R, SQL, estadística avanzada. Proyecto de análisis predictivo para gran empresa del sector financiero.', 1, 1),

-- Vacantes de Marketing Digital (id_empresa = 2, categoría Marketing)
('Social Media Manager', 'Gestión de redes sociales para importantes marcas', '2025-02-01', 28000.00, 'CREADA', 1, 'https://img.freepik.com/free-photo/marketing-strategy-planning-strategy-concept_53876-124441.jpg', 'Requisitos: Experiencia demostrable en gestión de RRSS, analytics, estrategia de contenidos. Se valorará experiencia en sector moda o belleza.', 2, 2),
('SEO Specialist', 'Especialista en posicionamiento orgánico', '2025-02-05', 30000.00, 'CANCELADA', 0, 'https://img.freepik.com/free-photo/digital-marketing-with-icons-business-people_53876-94833.jpg', 'Requisitos: Experiencia en auditorías SEO, análisis de keywords, contenidos optimizados. La posición ha sido cancelada por reestructuración del departamento.', 2, 2),

-- Vacantes de FinanConsulting (id_empresa = 3, categoría Finanzas)
('Analista Financiero', 'Análisis de inversiones y reportes financieros', '2025-02-10', 38000.00, 'CREADA', 1, 'https://img.freepik.com/free-photo/business-planning-concept-side-view_23-2149096063.jpg', 'Requisitos: Experiencia en valoración de empresas, análisis de riesgos, elaboración de informes para dirección. Imprescindible inglés nivel alto.', 3, 3),
('Controller de Gestión', 'Control presupuestario y análisis de desviaciones', '2025-02-15', 36000.00, 'CUBIERTA', 0, 'https://img.freepik.com/free-photo/financial-report-concept-with-team-work_23-2150504199.jpg', 'Requisitos: Experiencia en ERP financieros, reporting, control de costes. Se valorará conocimiento de SAP.', 3, 3),

-- Vacantes de Recursos Humanos Integrales (id_empresa = 4, categoría Recursos Humanos)
('Técnico de Selección', 'Proceso completo de reclutamiento y selección', '2025-02-20', 26000.00, 'CREADA', 0, 'https://img.freepik.com/free-photo/human-resources-concept-with-hand_23-2149155260.jpg', 'Requisitos: Experiencia en IT recruitment, manejo de LinkedIn Recruiter, entrevistas por competencias. Se ofrece plan de carrera.', 4, 4),
('Responsable de Formación', 'Diseño e implementación de planes formativos', '2025-02-25', 32000.00, 'CANCELADA', 1, 'https://img.freepik.com/free-photo/training-development-concept-chart-with-keywords-icons_23-2150166466.jpg', 'Requisitos: Experiencia en detección de necesidades formativas, gestión de proveedores, evaluación de la formación. La vacante ha sido cancelada temporalmente.', 4, 4),

-- Vacantes de SalesForce Iberia (id_empresa = 5, categoría Ventas)
('Key Account Manager', 'Gestión de cuentas clave en sector tecnológico', '2025-03-01', 40000.00, 'CREADA', 1, 'https://img.freepik.com/free-photo/sales-increase-icons-growth-concept_53876-127784.jpg', 'Requisitos: Experiencia comercial B2B, cartera de clientes en sector tech, capacidad de negociación. Se ofrece salario fijo + variable atractivo.', 5, 5),
('Commercial Director', 'Dirección del equipo comercial y estrategia de ventas', '2025-03-05', 60000.00, 'CUBIERTA', 1, 'https://img.freepik.com/free-photo/sales-growth-increase-rise-success-improve-concept_53876-151883.jpg', 'Requisitos: Experiencia dirigiendo equipos comerciales, definición de estrategias, cumplimiento de objetivos. Inglés fluido imprescindible.', 5, 5),

-- Vacantes de Administración Profesional (id_empresa = 10, categoría Administración)
('Administrativo Contable', 'Tareas administrativas y contables', '2025-03-10', 22000.00, 'CREADA', 0, 'https://img.freepik.com/free-photo/paperwork-concept-with-documents-desk_23-2149963481.jpg', 'Requisitos: Experiencia en facturación, contabilidad, atención telefónica. Manejo avanzado de Excel.', 6, 10),
('Secretario/a de Dirección', 'Soporte a dirección general', '2025-03-15', 25000.00, 'CANCELADA', 0, 'https://img.freepik.com/free-photo/closeup-business-woman-typing-computer-keyboard_53876-146162.jpg', 'Requisitos: Organización de agenda, viajes, reuniones. Inglés alto. La vacante ha sido cancelada por cambios internos.', 6, 10),

-- Vacantes de Hospital Central (id_empresa = 6, categoría Sanidad)
('Enfermero/a UCI', 'Enfermería para unidad de cuidados intensivos', '2025-03-20', 28000.00, 'CREADA', 1, 'https://img.freepik.com/free-photo/healthcare-workers-medical-technology-concept_23-2149249484.jpg', 'Requisitos: Experiencia en UCI, manejo de respiradores, monitorización. Turnos rotativos, contrato indefinido.', 7, 6),
('Médico Especialista en Cardiología', 'Cardiólogo para consultas y pruebas', '2025-03-25', 55000.00, 'CUBIERTA', 1, 'https://img.freepik.com/free-photo/medical-concept-with-heart_23-2148308726.jpg', 'Requisitos: Especialidad MIR, experiencia en ecocardiografía, pruebas de esfuerzo. Jornada completa, posibilidad de investigación clínica.', 7, 6),

-- Vacantes de Universidad Moderna (id_empresa = 7, categoría Educación)
('Profesor de Matemáticas', 'Docencia en grado de ingeniería', '2025-04-01', 32000.00, 'CREADA', 0, 'https://img.freepik.com/free-photo/students-listening-their-teacher-class_23-2148877644.jpg', 'Requisitos: Doctorado en matemáticas, experiencia docente, publicaciones científicas. Posibilidad de combinar con investigación.', 8, 7),
('Coordinador de Másteres', 'Gestión académica de programas de postgrado', '2025-04-05', 36000.00, 'CANCELADA', 0, 'https://img.freepik.com/free-photo/medium-shot-woman-teaching-class_23-2149038609.jpg', 'Requisitos: Experiencia en gestión universitaria, coordinación de profesorado, diseño curricular. La vacante queda cancelada por reorganización.', 8, 7),

-- Vacantes de Bufete Jurídico (id_empresa = 8, categoría Legal)
('Abogado Mercantilista', 'Asesoramiento legal a empresas', '2025-04-10', 40000.00, 'CREADA', 1, 'https://img.freepik.com/free-photo/close-up-lawyer-reading-legal-contract_23-2149253458.jpg', 'Requisitos: 5 años de experiencia en derecho mercantil, colegiado, idioma inglés. Se ofrece plan de carrera y formación especializada.', 9, 8),
('Paralegal', 'Apoyo a departamento jurídico', '2025-04-15', 22000.00, 'CUBIERTA', 0, 'https://img.freepik.com/free-photo/law-justice-concept-with-wooden-gavel_23-2149863423.jpg', 'Requisitos: Licenciatura en derecho, redacción de documentos legales, organización de expedientes. Horario flexible.', 9, 8),

-- Vacantes de Ingeniería Avanzada (id_empresa = 9, categoría Ingeniería)
('Ingeniero Civil', 'Proyectos de infraestructuras urbanas', '2025-04-20', 38000.00, 'CREADA', 1, 'https://img.freepik.com/free-photo/engineer-working-with-blueprints-building-project_23-2149860810.jpg', 'Requisitos: Experiencia en diseño de infraestructuras, manejo de AutoCAD, cálculo estructural. Proyectos nacionales e internacionales.', 10, 9),
('Ingeniero de Telecomunicaciones', 'Despliegue de redes 5G', '2025-04-25', 42000.00, 'CANCELADA', 1, 'https://img.freepik.com/free-photo/5g-network-technology-concept-with-digital-devices_53876-102858.jpg', 'Requisitos: Experiencia en radiofrecuencia, planificación de redes móviles. La vacante ha sido cancelada por retraso en el proyecto.', 10, 9);

-- Insert data for Solicitudes (con diferentes estados: 0 presentada, 1 adjudicada)
INSERT INTO Solicitudes (fecha, archivo, comentarios, estado, curriculum, id_Vacante, email) VALUES 
-- Solicitudes para Desarrollador Full Stack (id_Vacante = 1)
('2025-01-18', 'JuanPerez_CV.pdf', 'Me interesa mucho formar parte de su equipo de desarrollo.', 0, 'JuanPerez_CV.pdf', 1, 'juan.perez@mail.com'),
('2025-01-19', 'MariaLopez_CV.pdf', 'Tengo 4 años de experiencia como Full Stack Developer.', 0, 'MariaLopez_CV.pdf', 1, 'maria.lopez@mail.com'),

-- Solicitudes para DevOps Engineer (id_Vacante = 2)
('2025-01-22', 'PabloMartinez_CV.pdf', 'Certificado en AWS y experiencia con Docker y Kubernetes.', 0, 'PabloMartinez_CV.pdf', 2, 'pablo.martinez@mail.com'),

-- Solicitudes para Social Media Manager (id_Vacante = 4)
('2025-02-03', 'LuciaRodriguez_CV.pdf', 'He trabajado con marcas del sector moda y belleza.', 0, 'LuciaRodriguez_CV.pdf', 4, 'lucia.rodriguez@mail.com'),
('2025-02-04', 'SergioGarcia_CV.pdf', 'Especialista en estrategia de contenidos y análisis de métricas.', 0, 'SergioGarcia_CV.pdf', 4, 'sergio.garcia@mail.com'),

-- Solicitudes para Analista Financiero (id_Vacante = 6)
('2025-02-12', 'AnaFernandez_CV.pdf', 'Experiencia en valoración de startups y empresas tecnológicas.', 0, 'AnaFernandez_CV.pdf', 6, 'ana.fernandez@mail.com'),

-- Solicitudes para Data Scientist (id_Vacante = 3, estado CUBIERTA)
('2025-01-26', 'DavidSanchez_CV.pdf', 'Experto en Python y análisis predictivo.', 1, 'DavidSanchez_CV.pdf', 3, 'david.sanchez@mail.com'), -- Adjudicada

-- Solicitudes para Controller de Gestión (id_Vacante = 7, estado CUBIERTA)
('2025-02-16', 'LauraGomez_CV.pdf', 'Experiencia con SAP y reporting financiero.', 1, 'LauraGomez_CV.pdf', 7, 'laura.gomez@mail.com'), -- Adjudicada

-- Solicitudes para Commercial Director (id_Vacante = 11, estado CUBIERTA)
('2025-03-06', 'CarlosTorres_CV.pdf', '10 años liderando equipos comerciales en sector tecnológico.', 1, 'CarlosTorres_CV.pdf', 11, 'carlos.torres@mail.com'), -- Adjudicada

-- Solicitudes para Médico Especialista en Cardiología (id_Vacante = 15, estado CUBIERTA)
('2025-03-26', 'ElenaDiaz_CV.pdf', 'Cardiólogo con experiencia en hospital universitario.', 1, 'ElenaDiaz_CV.pdf', 15, 'elena.diaz@mail.com'), -- Adjudicada

-- Solicitudes para Paralegal (id_Vacante = 19, estado CUBIERTA)
('2025-04-16', 'JuanPerez_CV.pdf', 'Licenciado en derecho con experiencia en documentación mercantil.', 1, 'JuanPerez_CV.pdf', 19, 'juan.perez@mail.com'), -- Adjudicada

-- Solicitudes para Técnico de Selección (id_Vacante = 8)
('2025-02-21', 'MariaLopez_CV.pdf', 'Experiencia en selección IT y entrevistas por competencias.', 0, 'MariaLopez_CV.pdf', 8, 'maria.lopez@mail.com'),
('2025-02-22', 'PabloMartinez_CV.pdf', 'Manejo avanzado de LinkedIn Recruiter y portales de empleo.', 0, 'PabloMartinez_CV.pdf', 8, 'pablo.martinez@mail.com'),

-- Solicitudes para Key Account Manager (id_Vacante = 10)
('2025-03-02', 'LuciaRodriguez_CV.pdf', 'Experiencia en ventas B2B y cartera de clientes tecnológicos.', 0, 'LuciaRodriguez_CV.pdf', 10, 'lucia.rodriguez@mail.com'),

-- Solicitudes para Administrativo Contable (id_Vacante = 12)
('2025-03-11', 'SergioGarcia_CV.pdf', 'Experiencia en tareas administrativas y contabilidad.', 0, 'SergioGarcia_CV.pdf', 12, 'sergio.garcia@mail.com'),

-- Solicitudes para Enfermero/a UCI (id_Vacante = 14)
('2025-03-21', 'AnaFernandez_CV.pdf', 'Enfermera con experiencia en UCI y pacientes críticos.', 0, 'AnaFernandez_CV.pdf', 14, 'ana.fernandez@mail.com'),

-- Solicitudes para Profesor de Matemáticas (id_Vacante = 16)
('2025-04-02', 'CarlosTorres_CV.pdf', 'Doctor en matemáticas con experiencia docente universitaria.', 0, 'CarlosTorres_CV.pdf', 16, 'carlos.torres@mail.com'),

-- Solicitudes para Abogado Mercantilista (id_Vacante = 18)
('2025-04-11', 'ElenaDiaz_CV.pdf', 'Abogada especializada en derecho mercantil e internacional.', 0, 'ElenaDiaz_CV.pdf', 18, 'elena.diaz@mail.com'),

-- Solicitudes para Ingeniero Civil (id_Vacante = 20)
('2025-04-21', 'DavidSanchez_CV.pdf', 'Ingeniero con experiencia en proyectos de infraestructuras.', 0, 'DavidSanchez_CV.pdf', 20, 'david.sanchez@mail.com');
