-- Crear usuario de aplicación si no existe
CREATE USER IF NOT EXISTS 'vacantes_user'@'%' IDENTIFIED BY 'vacantespass2025';

-- Otorgar privilegios sobre la base de datos
GRANT ALL PRIVILEGES ON vacantes_BBDD_2025_RETO.* TO 'vacantes_user'@'%';

-- Aplicar cambios
FLUSH PRIVILEGES;
