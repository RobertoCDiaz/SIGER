-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema siger
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `siger` ;

-- -----------------------------------------------------
-- Schema siger
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `siger` ;
USE `siger` ;

-- -----------------------------------------------------
-- Table `siger`.`administradores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`administradores` ;

CREATE TABLE IF NOT EXISTS `siger`.`administradores` (
	`email` VARCHAR(64) NOT NULL,
	`contrasena` VARCHAR(160) NOT NULL,
	`nombre` VARCHAR(48) NOT NULL,
	`apellido_paterno` VARCHAR(48) NOT NULL,
	`apellido_materno` VARCHAR(48) NOT NULL,
	PRIMARY KEY (`email`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`carreras`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`carreras` ;

CREATE TABLE IF NOT EXISTS `siger`.`carreras` (
	`clave` CHAR(13) NOT NULL,
	`nombre_carrera` VARCHAR(64) NOT NULL,
	`admin_email` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`clave`),
	INDEX `fk_carreras_admin1_idx` (`admin_email` ASC), -- VISIBLE,
	CONSTRAINT `fk_carreras_admin1`
		FOREIGN KEY (`admin_email`)
		REFERENCES `siger`.`administradores` (`email`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`residentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`residentes` ;

CREATE TABLE IF NOT EXISTS `siger`.`residentes` (
	`email` VARCHAR(64) NOT NULL,
	`contrasena` VARCHAR(160) NOT NULL,
	`nombre` VARCHAR(48) NOT NULL,
	`apellido_paterno` VARCHAR(48) NOT NULL,
	`apellido_materno` VARCHAR(48) NULL,
	`aprobado` TINYINT NOT NULL DEFAULT 0,
	`fecha_creacion` VARCHAR(14) NOT NULL,
	`clave_carrera` CHAR(13) NOT NULL,
	PRIMARY KEY (`email`),
	INDEX `fk_residentes_carreras1_idx` (`clave_carrera` ASC), -- VISIBLE,
	CONSTRAINT `fk_residentes_carreras1`
		FOREIGN KEY (`clave_carrera`)
		REFERENCES `siger`.`carreras` (`clave`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`docentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`docentes` ;

CREATE TABLE IF NOT EXISTS `siger`.`docentes` (
	`email` VARCHAR(64) NOT NULL,
	`contrasena` VARCHAR(160) NOT NULL,
	`nombre` VARCHAR(48) NOT NULL,
	`apellido_paterno` VARCHAR(48) NOT NULL,
	`apellido_materno` VARCHAR(48) NULL,
	`confirmado` TINYINT NOT NULL DEFAULT 0,
	PRIMARY KEY (`email`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`materias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`materias` ;

CREATE TABLE IF NOT EXISTS `siger`.`materias` (
	`clave` CHAR(8) NOT NULL,
	`nombre` VARCHAR(96) NOT NULL,
	PRIMARY KEY (`clave`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`competente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`competente` ;

CREATE TABLE IF NOT EXISTS `siger`.`competente` (
	`email_docente` VARCHAR(64) NOT NULL,
	`clave_materia` CHAR(8) NOT NULL,
	PRIMARY KEY (`email_docente`, `clave_materia`),
	INDEX `fk_docentes_has_materias_materias1_idx` (`clave_materia` ASC), -- VISIBLE,
	INDEX `fk_docentes_has_materias_docentes1_idx` (`email_docente` ASC), -- VISIBLE,
	CONSTRAINT `fk_docentes_has_materias_docentes1`
		FOREIGN KEY (`email_docente`)
		REFERENCES `siger`.`docentes` (`email`)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT `fk_docentes_has_materias_materias1`
		FOREIGN KEY (`clave_materia`)
		REFERENCES `siger`.`materias` (`clave`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`telefonos_residentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`telefonos_residentes` ;

CREATE TABLE IF NOT EXISTS `siger`.`telefonos_residentes` (
	`telefono` CHAR(10) NOT NULL,
	`fijo` TINYINT NOT NULL DEFAULT 0,
	`email_residente` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`telefono`),
	INDEX `fk_telefonos_residentes_residentes1_idx` (`email_residente` ASC), -- VISIBLE,
	CONSTRAINT `fk_telefonos_residentes_residentes1`
		FOREIGN KEY (`email_residente`)
		REFERENCES `siger`.`residentes` (`email`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`telefonos_docentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`telefonos_docentes` ;

CREATE TABLE IF NOT EXISTS `siger`.`telefonos_docentes` (
	`telefono` CHAR(10) NOT NULL,
	`email_docente` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`telefono`),
	INDEX `fk_telefonos_docentes_docentes1_idx` (`email_docente` ASC), -- VISIBLE,
	CONSTRAINT `fk_telefonos_docentes_docentes1`
		FOREIGN KEY (`email_docente`)
		REFERENCES `siger`.`docentes` (`email`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`residencias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`residencias` ;

CREATE TABLE IF NOT EXISTS `siger`.`residencias` (
	`idresidencia` INT NOT NULL AUTO_INCREMENT,
	`nombre_proyecto` VARCHAR(128) NOT NULL,
	`objetivo` VARCHAR(512) NOT NULL,
	`justificacion` VARCHAR(512) NOT NULL,
	`periodo` TINYINT NOT NULL DEFAULT 0,
	`ano` CHAR(4) NOT NULL,
	`descripcion_actividades` VARCHAR(1024) NOT NULL,
	`fecha_elaboracion` VARCHAR(14) NOT NULL,
	`email_residente` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`idresidencia`),
	INDEX `fk_residencia_residentes1_idx` (`email_residente` ASC), -- VISIBLE,
	CONSTRAINT `fk_residencia_residentes1`
		FOREIGN KEY (`email_residente`)
		REFERENCES `siger`.`residentes` (`email`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`empresas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`empresas` ;

CREATE TABLE IF NOT EXISTS `siger`.`empresas` (
  `idempresa` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(128) NOT NULL,
  `representante` VARCHAR(128) NOT NULL,
  `direccion` VARCHAR(128) NOT NULL,
  `ciudad` VARCHAR(64) NOT NULL,
  `telefono` CHAR(10) NOT NULL,
  `email` VARCHAR(64) NOT NULL,
  `departamento` VARCHAR(64) NOT NULL,
  `id_residencia` INT NOT NULL,
  PRIMARY KEY (`idempresa`),
  INDEX `fk_empresa_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
  CONSTRAINT `fk_empresa_residencia1`
    FOREIGN KEY (`id_residencia`)
    REFERENCES `siger`.`residencias` (`idresidencia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`asesores_externos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`asesores_externos` ;

CREATE TABLE IF NOT EXISTS `siger`.`asesores_externos` (
	`idasesores_externos` INT NOT NULL AUTO_INCREMENT,
	`email` VARCHAR(64) NOT NULL,
	`nombre_completo` VARCHAR(128) NOT NULL,
	`puesto` VARCHAR(64) NOT NULL,
	`grado_estudios` VARCHAR(48) NOT NULL,
	`telefono` CHAR(10) NOT NULL,
	`id_residencia` INT NOT NULL,
	PRIMARY KEY (`idasesores_externos`),
	INDEX `fk_asesores_externos_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
	CONSTRAINT `fk_asesores_externos_residencia1`
		FOREIGN KEY (`id_residencia`)
		REFERENCES `siger`.`residencias` (`idresidencia`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`horarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`horarios` ;

CREATE TABLE IF NOT EXISTS `siger`.`horarios` (
  `idhorarios` INT NOT NULL AUTO_INCREMENT,
  `inicio` CHAR(5) NOT NULL,
  `fin` CHAR(5) NOT NULL,
  `id_residencia` INT NOT NULL,
  PRIMARY KEY (`idhorarios`),
  INDEX `fk_horarios_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
  CONSTRAINT `fk_horarios_residencia1`
    FOREIGN KEY (`id_residencia`)
    REFERENCES `siger`.`residencias` (`idresidencia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`involucrados`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`involucrados` ;

CREATE TABLE IF NOT EXISTS `siger`.`involucrados` (
	`email_docente` VARCHAR(64) NOT NULL,
	`id_residencia` INT NOT NULL,
	`es_asesor` TINYINT NOT NULL DEFAULT 0,
	PRIMARY KEY (`email_docente`, `id_residencia`),
	INDEX `fk_docentes_has_residencia_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
	INDEX `fk_docentes_has_residencia_docentes1_idx` (`email_docente` ASC), -- VISIBLE,
	CONSTRAINT `fk_docentes_has_residencia_docentes1`
		FOREIGN KEY (`email_docente`)
		REFERENCES `siger`.`docentes` (`email`)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT `fk_docentes_has_residencia_residencia1`
		FOREIGN KEY (`id_residencia`)
		REFERENCES `siger`.`residencias` (`idresidencia`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`anexo_29`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`anexo_29` ;

CREATE TABLE IF NOT EXISTS `siger`.`anexo_29` (
	`idanexo_29` INT NOT NULL AUTO_INCREMENT,
	`fecha_activacion` VARCHAR(14) NOT NULL,
	`fecha_externa` VARCHAR(14) NULL,
	`fecha_interna` VARCHAR(14) NULL,
	`evaluacion_externa` VARCHAR(24) NULL,
	`observaciones_externas` VARCHAR(128) NULL,
	`evaluacion_interna` VARCHAR(17) NULL,
	`observaciones_internas` VARCHAR(128) NULL,
	`id_residencia` INT NOT NULL,
	PRIMARY KEY (`idanexo_29`),
	INDEX `fk_anexo_29_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
	CONSTRAINT `fk_anexo_29_residencia1`
		FOREIGN KEY (`id_residencia`)
		REFERENCES `siger`.`residencias` (`idresidencia`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`anexo_30`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`anexo_30` ;

CREATE TABLE IF NOT EXISTS `siger`.`anexo_30` (
	`idanexo_30` INT NOT NULL AUTO_INCREMENT,
	`fecha_activacion` VARCHAR(14) NOT NULL,
	`fecha_externa` VARCHAR(14) NULL,
	`fecha_interna` VARCHAR(14) NULL,
	`evaluacion_externa` VARCHAR(28) NULL,
	`observaciones_externas` VARCHAR(128) NULL,
	`evaluacion_interna` VARCHAR(28) NULL,
	`observaciones_internas` VARCHAR(128) NULL,
	`id_residencia` INT NOT NULL,
	PRIMARY KEY (`idanexo_30`),
	INDEX `fk_anexo_30_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
	CONSTRAINT `fk_anexo_30_residencia1`
		FOREIGN KEY (`id_residencia`)
		REFERENCES `siger`.`residencias` (`idresidencia`)
		ON DELETE CASCADE
		ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`confirmaciones_docentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`confirmaciones_docentes` ;

CREATE TABLE IF NOT EXISTS `siger`.`confirmaciones_docentes` (
  `id` VARCHAR(256) NOT NULL,
  `fecha_registro` VARCHAR(14) NOT NULL,
  `confirmado` TINYINT NOT NULL DEFAULT 0,
  `docentes_email` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_confirmaciones_docentes_docentes1_idx` (`docentes_email` ASC), -- VISIBLE,
  CONSTRAINT `fk_confirmaciones_docentes_docentes1`
    FOREIGN KEY (`docentes_email`)
    REFERENCES `siger`.`docentes` (`email`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`enlaces_anexo29`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`enlaces_anexo29` ;

CREATE TABLE IF NOT EXISTS `siger`.`enlaces_anexo29` (
  `id` VARCHAR(256) NOT NULL,
  `es_asesor_externo` TINYINT NOT NULL DEFAULT 0,
  `evaluado` TINYINT NOT NULL DEFAULT 0,
  `id_anexo29` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_enlaces_anexo29_anexo_291_idx` (`id_anexo29` ASC), -- VISIBLE,
  CONSTRAINT `fk_enlaces_anexo29_anexo_291`
    FOREIGN KEY (`id_anexo29`)
    REFERENCES `siger`.`anexo_29` (`idanexo_29`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`enlaces_anexo30`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`enlaces_anexo30` ;

CREATE TABLE IF NOT EXISTS `siger`.`enlaces_anexo30` (
  `id` VARCHAR(256) NOT NULL,
  `es_asesor_externo` TINYINT NOT NULL DEFAULT 0,
  `evaluado` TINYINT NOT NULL DEFAULT 0,
  `id_anexo30` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_enlaces_anexo30_anexo_301_idx` (`id_anexo30` ASC), -- VISIBLE,
  CONSTRAINT `fk_enlaces_anexo30_anexo_301`
    FOREIGN KEY (`id_anexo30`)
    REFERENCES `siger`.`anexo_30` (`idanexo_30`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/* --------------------------------------------------------

	FUNCTIONS.

-------------------------------------------------------- */
DELIMITER ;;

/*
	Comprueba si el adminstrador cuyo correo electrónico es
	[v_email_admin] tiene la capacidad de validar al residente
	con correo [v_email_residente].

	Regresa 1 si dicho administrador puede validar al residente.
	Regresa 0 si no.
*/	
DROP FUNCTION IF EXISTS puedeValidarResidente;;
CREATE FUNCTION puedeValidarResidente(
	v_email_residente VARCHAR(64),
	v_email_admin VARCHAR(64)
) RETURNS TINYINT DETERMINISTIC BEGIN 
	set @realAdminEmail = (
		select 
			c.admin_email
		from 
			residentes as r join carreras as c
				on c.clave = r.clave_carrera
		where r.email = v_email_residente
	);

	IF v_email_admin = @realAdminEmail THEN BEGIN
		RETURN 1;
	END; END IF;

	RETURN 0;
END;;


/*
	Regresa un VARCHAR con el nombre completo del 
	residente, docente, o administrador cuyo email 
	concuerde con [v_email].

	Si no encuentra un registro con email [v_email]
	en ninguna de las tablas posibles (residentes,
	docentes, o administradores), regresará una 
	cadena vacía [''].
*/
DROP FUNCTION IF EXISTS nombreCompleto;;
CREATE FUNCTION nombreCompleto(
	v_email VARCHAR(64)
) RETURNS VARCHAR(256) DETERMINISTIC BEGIN

	IF v_email IN (SELECT email FROM residentes) THEN BEGIN
		RETURN (
			SELECT 
				CONCAT(t.nombre, ' ', t.apellido_paterno, ' ', COALESCE(t.apellido_materno, ''))
			FROM 
				residentes as t
			WHERE
				t.email = v_email
		);
	END; ELSEIF v_email IN (SELECT email FROM docentes) THEN BEGIN
		RETURN (
			SELECT 
				CONCAT(t.nombre, ' ', t.apellido_paterno, ' ', COALESCE(t.apellido_materno, ''))
			FROM 
				docentes as t
			WHERE
				t.email = v_email
		);
	END; ELSEIF v_email IN (SELECT email FROM administradores) THEN BEGIN
		RETURN (
			SELECT 
				CONCAT(t.nombre, ' ', t.apellido_paterno, ' ', COALESCE(t.apellido_materno, ''))
			FROM 
				administradores as t
			WHERE
				t.email = v_email
		);
	END; END IF;

	RETURN '';
END;;


/*
	Dado el id de una residencia, concatena todos los horarios
	del residente en una empresa en una sola cadena de caracteres,
	separando cada jornada con una coma.

	Por ejemplo, si a una residencia le corresponden los siguientes horarios
	----------------
	|entrada|salida|
	----------------
	|09:00	|12:00 |
	----------------
	|16:00	|20:00 |
	----------------

	Esta función arrojará el siguiente VARCHAR:
	"09:00 - 12:00,16:00 - 20:00"
*/
DROP FUNCTION IF EXISTS concatenarHorarios;;
CREATE FUNCTION concatenarHorarios(
	v_id_residencia INT
) RETURNS VARCHAR(64) DETERMINISTIC BEGIN
	RETURN (
		SELECT 
			GROUP_CONCAT(t.jornada SEPARATOR ', ')
		FROM (
			SELECT 
				CONCAT(h.inicio, " - ", h.fin) as 'jornada'
			FROM 
				horarios AS h 
			WHERE 
				h.id_residencia = v_id_residencia
			ORDER BY
				CONCAT(h.inicio, " - ", h.fin)
		) AS t
	);
END;;


/*
	Regresa el valor que indica si el docente con email
	[v_email_docente] está confirmado.

	0 -> No lo está.
	1 -> Está confirmado.
*/
DROP FUNCTION IF EXISTS docenteConfirmado;;
CREATE FUNCTION docenteConfirmado(
	v_email_docente VARCHAR(64)
) RETURNS TINYINT DETERMINISTIC BEGIN
	IF 
		(SELECT confirmado FROM docentes AS d WHERE d.email = v_email_docente) = 1 AND 
		(SELECT confirmado FROM confirmaciones_docentes AS cd WHERE cd.docentes_email = v_email_docente)
	THEN BEGIN
		RETURN 1;
	END; ELSE BEGIN
		RETURN 0;
	END; END IF;
END;;


/*
	Regresa el valor que indica si el residente con email
	[v_email] está aprobado.

	0 -> No lo está.
	1 -> Está confirmado.
*/
DROP FUNCTION IF EXISTS residenteConfirmado;;
CREATE FUNCTION residenteConfirmado(
	v_email VARCHAR(64)
) RETURNS TINYINT DETERMINISTIC BEGIN
	RETURN (
		SELECT
			aprobado
		FROM 
			residentes AS r
		WHERE 
			r.email = v_email
	);
END;;


/*
	Regresa un valor numérico dependiendo del estado
	actual del residente con email [v_email].

	Cada valor corresponde a un estado distinto:

		0: Sin confirmar.
			- Cerrar sesión.

		1: Confirmado.
			- Nuevo proyecto.
			- Documentos.
			- Cerrar sesión.

		2. Con residencia aprobada.
			- Progreso actual.
			- Documentos.
			- Chat.
			- Cerrar
*/
DROP FUNCTION IF EXISTS estadoResidente;;
CREATE FUNCTION estadoResidente(
	v_email VARCHAR(64)
) RETURNS INT DETERMINISTIC BEGIN
	SET @estado = 0;

	IF residenteConfirmado(v_email) = 1 THEN BEGIN
		SET @estado := 1;
	END; END IF;

	IF v_email IN (SELECT email_residente FROM residencias AS r WHERE residenciaAprobada(r.idresidencia) = 1) THEN BEGIN
		SET @estado := 2;
	END; END IF;

	RETURN @estado;	
END;;


/*
	Esta función comprueba si una residencia ha sido
	aprobada, es decir, que ya tenga docentes asignados
	como asesor interno y revisores.

	Si la residencia está aprobada, regresará 1.
	Regresará 0 si no hay docentes asignados.
*/
DROP FUNCTION IF EXISTS residenciaAprobada;;
CREATE FUNCTION residenciaAprobada(
	v_id_residencia INT
) RETURNS TINYINT DETERMINISTIC BEGIN

	IF v_id_residencia IN (SELECT DISTINCT id_residencia FROM involucrados) THEN BEGIN
		RETURN 1;
	END; END IF;

	RETURN 0;
	
END;;


/*
	Regresa un valor numérico dependiendo del estado
	actual del docente con email [v_email].

	Cada valor corresponde a un estado distinto:

		0: Sin confirmar.
			- Cerrar sesión.

		1: Confirmado.
			- Lista de residentes asesorados.
            Para cada residente habrá opción de:
				- Documentos.
                - Progreso.
                - Chat.
                
			- Cerrar sesión.
*/
DROP FUNCTION IF EXISTS estadoDocente;;
CREATE FUNCTION estadoDocente(
	v_email VARCHAR(64)
) RETURNS INT DETERMINISTIC BEGIN
	SET @estado = 0;

	IF docenteConfirmado(v_email) = 1 THEN BEGIN
		SET @estado := 1;
	END; END IF;

	RETURN @estado;	
END;;


/*
	Regresa la cantidad de registros que hay
	en la tabla [anexo_29] asociados a la 
	residencia con id [v_id_residencia].
*/
DROP FUNCTION IF EXISTS cantidadDeAnexos29;;
CREATE FUNCTION cantidadDeAnexos29(
	v_id_residencia INT
) RETURNS INT DETERMINISTIC BEGIN
	RETURN (
		SELECT 
			count(a29.idanexo_29)
		FROM
			anexo_29 as a29
		WHERE 
			a29.id_residencia = v_id_residencia
	);
END;;


/*
	Regresa la cantidad de registros que hay
	en la tabla [anexo_30] asociados a la 
	residencia con id [v_id_residencia].
*/
DROP FUNCTION IF EXISTS cantidadDeAnexos30;;
CREATE FUNCTION cantidadDeAnexos30(
	v_id_residencia INT
) RETURNS INT DETERMINISTIC BEGIN
	RETURN (
		SELECT 
			count(a30.idanexo_30)
		FROM
			anexo_30 as a30
		WHERE 
			a30.id_residencia = v_id_residencia
	);
END;;


/*
	Comprueba si la residencia con id [v_id_residencia] tiene
	por lo menos algún anexo 29 pendiente de calificación.

	Regresa
		0 -> No tiene algún anexo 29 pendiente.
		1 -> Tiene por lo menos un anexo 29 pendiente.
*/
DROP FUNCTION IF EXISTS tieneAnexo29Pendiente;;
CREATE FUNCTION tieneAnexo29Pendiente(
	v_id_residencia INT
) RETURNS INT DETERMINISTIC BEGIN
	RETURN (
		SELECT
			IF (
				(0 IN (
					SELECT 
						IF (a29.fecha_externa IS NOT NULL AND a29.fecha_interna IS NOT NULL, 1, 0)
					FROM 
						residencias AS r LEFT JOIN anexo_29 AS a29
							ON r.idresidencia = a29.id_residencia
					WHERE
						r.idresidencia = v_id_residencia
				)) AND cantidadDeAnexos29(v_id_residencia) != 0,
				1,
				0
			)
	);
END;;


/*
	Comprueba si la residencia con id [v_id_residencia] tiene
	por lo menos algún anexo 30 pendiente de calificación.

	Regresa
		0 -> No tiene algún anexo 30 pendiente.
		1 -> Tiene por lo menos un anexo 30 pendiente.
*/
DROP FUNCTION IF EXISTS tieneAnexo30Pendiente;;
CREATE FUNCTION tieneAnexo30Pendiente(
	v_id_residencia INT
) RETURNS INT DETERMINISTIC BEGIN
	RETURN (
		SELECT
			IF (
				(0 IN (
					SELECT 
						IF (a30.fecha_externa IS NOT NULL AND a30.fecha_interna IS NOT NULL, 1, 0)
					FROM 
						residencias AS r LEFT JOIN anexo_30 AS a30
							ON r.idresidencia = a30.id_residencia
					WHERE
						r.idresidencia = v_id_residencia
				)) AND cantidadDeAnexos30(v_id_residencia) != 0,
				1,
				0
			)
	);
END;;


/*
	Comprueba si una residencia ya está terminada.
	Para que una residencia se considere terminada,
	esta debe de tener un anexo 30 registrado por completo,
	es decir, que cuente con evaluación del Asesor Interno
	y Externo.

	Regresa
		0 -> La residencia aún no está terminada.
		1 -> La residencia ha sido terminada.
*/
DROP FUNCTION IF EXISTS residenciaTerminada;;
CREATE FUNCTION residenciaTerminada(
	v_id_residencia INT
) RETURNS INT DETERMINISTIC BEGIN
	RETURN (
		SELECT IF (
			cantidadDeAnexos30(v_id_residencia) >= 1 AND
			tieneAnexo30Pendiente(v_id_residencia) = 0
		, 1, 0)
	);
END;;


/*
	Comprueba si una residencia es apta para comenzar
	un nuevo periodo de evaluación (ya sea con el
	anexo 29 o 30).

	Para que una residencia sea apta, la residencia debe
	estar aprobada, NO estar terminada, y NO contar con
	ninguna evaluación pendiente (Anexo 29 o 30).

	Regresa
		0 -> La residencia no es apta.
		1 -> Sí es apta.
*/
DROP FUNCTION IF EXISTS residenciaAptaParaEvaluacion;;
CREATE FUNCTION residenciaAptaParaEvaluacion(
	v_id_residencia INT
) RETURNS INT DETERMINISTIC BEGIN
	
	RETURN (
		SELECT 
			IF (
				tieneAnexo29Pendiente(v_id_residencia) = 0 AND
				tieneAnexo30Pendiente(v_id_residencia) = 0 AND 
				residenciaAprobada(v_id_residencia) = 1 AND 
				residenciaTerminada(v_id_residencia) = 0
			, 1, 0)
	);

END;;

/*
	Regresa el ID del registro en la tabla [anexo_29] que 
	corresponde a un url único, ya sea de un A.I. o A.E.
*/
DROP FUNCTION IF EXISTS idAnexo29DeURL;;
CREATE FUNCTION idAnexo29DeURL(
	v_url VARCHAR(256)
) RETURNS INT DETERMINISTIC BEGIN
	RETURN (
		SELECT 
			e.id_anexo29
		FROM 
			enlaces_anexo29 AS e
		WHERE
			e.id = v_url
	);
END;;


/* --------------------------------------------------------

	STORED PROCEDURES.

-------------------------------------------------------- */

/*
	Muestra una lista simplificada de las carreras disponibles.
	Esta lista solo contendrá la clave de la carrera, así como 
	el nombre de esta.
*/
DROP PROCEDURE IF EXISTS SP_MostrarCarreras;;
CREATE PROCEDURE SP_MostrarCarreras() BEGIN
	select clave, nombre_carrera from carreras order by nombre_carrera;
END;;


/*
	A partir de los datos proporcionados como parámetros,
	crea las filas en las tablas necesarias para el 
	registro de un nuevo residente en el sistema.
	Este residente nuevo no estará confirmado.

	[output] será 1 si todo salió bien.
	Si ocurre alguna excepción en la transacción,
	[output] será -1, mientras [message] indica el
	origen de la excepción.
*/
DROP PROCEDURE IF EXISTS SP_RegistroResidente;;
CREATE PROCEDURE SP_RegistroResidente(
	v_email VARCHAR(64),
	v_contrasena VARCHAR(160),
	v_nombre VARCHAR(48),
	v_apellido_paterno VARCHAR(48),
	v_apellido_materno VARCHAR(48),
	v_fecha_creacion VARCHAR(14),
	v_clave_carrera CHAR(13),
	v_tel_cel CHAR(10),
	v_tel_fijo CHAR(10)
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	START TRANSACTION;
		INSERT INTO `siger`.`residentes`
			(email, contrasena, nombre, apellido_paterno, apellido_materno, fecha_creacion, clave_carrera)
		VALUES
			(v_email, v_contrasena, v_nombre, v_apellido_paterno, v_apellido_materno, v_fecha_creacion, v_clave_carrera);

	
		INSERT INTO `siger`.`telefonos_residentes` 
			(telefono, email_residente, fijo)
		VALUES
			(v_tel_cel, v_email, 0),
			(v_tel_fijo, v_email, 1);

		SELECT "1" AS output, "Transaction committed successfully" AS message;
	COMMIT;
END;;


/*
	Muestra una lista de los residentes que actualmente están sin validar y que
	pertenecen a alguna de las carreras administradas por el dueño del correo
	electrónico [v_email_admin].
*/
DROP PROCEDURE IF EXISTS SP_ResidentesNoValidados;;
CREATE PROCEDURE SP_ResidentesNoValidados(
	v_email_admin VARCHAR(64)
) BEGIN
	SELECT 
		r.email, substring(r.email, 2, 8) AS `noControl`, r.nombre, r.apellido_paterno, r.apellido_materno,
		(SELECT t.telefono FROM telefonos_residentes AS t WHERE r.email = t.email_residente AND fijo = 0) AS `celular`,
		(SELECT t.telefono FROM telefonos_residentes AS t WHERE r.email = t.email_residente AND fijo = 1) AS `tel`,
		r.fecha_creacion, c.nombre_carrera AS `carrera`
	FROM 
		residentes AS r JOIN carreras AS c 
			on c.clave = r.clave_carrera
	WHERE 
		aprobado = 0 AND
		c.admin_email = v_email_admin
	ORDER BY 
		r.fecha_creacion, `noControl`;
END;;


/*
	Valida al residente con correo [v_email_residente] 
	solo si el administrador con el correo electrónico 
	[v_email_admin] tiene la capacidad de hacerlo.

	El [output] será 1 si se logró validar al residente.
	Será 0 si hay algún problema, además de informarse con
	[message].
	En caso de ocurrir alguna excepción en la transacción,
	[output] será -1. La razón será proporcionada a [message].
*/
DROP PROCEDURE IF EXISTS SP_ValidarResidente;;
CREATE PROCEDURE SP_ValidarResidente(
	v_email_residente VARCHAR(64),
	v_email_admin VARCHAR(64)
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	START TRANSACTION;

	IF (puedeValidarResidente(v_email_residente, v_email_admin)) != 1 THEN BEGIN
		SELECT "0" AS output, "Este administrador no puede validar a este residente" AS message;
		END; 
	ELSEIF (SELECT COUNT(*) FROM `siger`.`residentes` AS r WHERE r.email = v_email_residente) = 0 THEN BEGIN
			SELECT "0" AS output, "No existe un residente con este email" AS message;
		END; 
		-- ELSEIF (SELECT COUNT(*) FROM `siger`.`residentes` AS r WHERE r.email = v_email_residente AND r.aprobado = 0) = 0 THEN BEGIN
		ELSEIF (estadoResidente(v_email_residente)) >= 1 THEN BEGIN
			SELECT "0" AS output, "Este residente ya está validado" AS message;
		END; ELSE BEGIN
			UPDATE `siger`.`residentes` AS r SET r.aprobado = 1 WHERE r.email = v_email_residente;

			SELECT "1" AS output, "Residente validado con éxito" AS message; 
		END; END IF;
	
	COMMIT;
END;;


DROP PROCEDURE IF EXISTS SP_RegistroResidencia;;
CREATE PROCEDURE SP_RegistroResidencia(
  v_nombre_proyecto VARCHAR(128),
  v_objetivo VARCHAR(512),
  v_justificacion VARCHAR(512),
  v_periodo TINYINT,
  v_ano CHAR(4),
  v_descripcion_actividades VARCHAR(1024),
  v_email_residente VARCHAR(64),
  v_fecha_elaboracion VARCHAR(14),
  v_nombre_empresa varchar(128),
  v_representante varchar (128),
  v_direccion varchar(128),
  v_ciudad varchar (64),
  v_telefono char(10),
  v_email varchar(64),
  v_departamento varchar(64),
  v_email_ae varchar(64),
  v_nombre_ae varchar(128),
  v_puesto varchar(64),
  v_grado_estudios varchar(48),
  v_tel_ae char(10)
)
BEGIN
  DECLARE exit handler for SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1
    @p2 = MESSAGE_TEXT;
    
    SELECT "0" AS output, @p2 AS message;
    
    ROLLBACK;
  END;

  IF estadoResidente(v_email_residente) < 1 THEN BEGIN

	SELECT "0" AS output, 'El residente no ha sido confirmado por un administrador' AS message;

  END; ELSE BEGIN 

	START TRANSACTION;
		INSERT INTO `siger`.`residencias`
		(nombre_proyecto, objetivo, justificacion, periodo, ano, descripcion_actividades, email_residente,fecha_elaboracion)
		VALUES
		(v_nombre_proyecto, v_objetivo, v_justificacion, v_periodo, v_ano, v_descripcion_actividades, v_email_residente, v_fecha_elaboracion);

		set @idr = last_insert_id();
		
		INSERT INTO `siger`.`empresas` 
		(nombre, representante, direccion, ciudad, telefono, email, departamento, id_residencia)
		VALUES
		(v_nombre_empresa, v_representante, v_direccion,v_ciudad, v_telefono, v_email, v_departamento, @idr);
		
		INSERT INTO `siger`.`asesores_externos` 
		(email, nombre_completo, puesto, grado_estudios, telefono, id_residencia)
		VALUES
		(v_email_ae, v_nombre_ae, v_puesto,v_grado_estudios, v_tel_ae, @idr);

		SELECT "1" AS output, "Transaction committed successfully" AS message, @idr AS `idresidencia`;
	COMMIT;

  END; END IF;
END;;

DROP procedure IF EXISTS `SP_RegistraHorarios`;;
CREATE PROCEDURE `SP_RegistraHorarios`(
  v_inicio CHAR(5),
  v_fin CHAR(5),
  v_idresidencia INT
)
BEGIN
  DECLARE exit handler for SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1
    @p2 = MESSAGE_TEXT;
    
    SELECT "0" AS output, @p2 AS message;
    
    ROLLBACK;
  END;

  START TRANSACTION;
    INSERT INTO `siger`.`horarios`
      (inicio, fin, id_residencia)
    VALUES
      (v_inicio, v_fin, v_idresidencia);

    SELECT "1" AS output, "Transaction committed successfully" AS message;
  COMMIT;
END;;

/*
	Procedimientos que envían datos relacionados al avance
    del residente.
*/
DROP PROCEDURE IF EXISTS SP_MostrarAnexo29;;
CREATE PROCEDURE `SP_MostrarAnexo29`(
v_email VARCHAR(64)
)
BEGIN
	select "1" as output, "Transaction commited successfully" AS message,
    evaluacion_externa as ee, observaciones_externas as oe,
    evaluacion_interna as ei, observaciones_internas as ie 
    from residencias join anexo_29 on anexo_29.id_residencia=residencias.idresidencia
	where residencias.email_residente=v_email;
END;;

DROP PROCEDURE IF EXISTS SP_MostrarAnexo30;;
CREATE PROCEDURE SP_MostrarAnexo30(
v_email VARCHAR(64)
)
BEGIN
	select "1" as output, "Transaction commited successfully" AS message,
    evaluacion_externa as ee, observaciones_externas as oe,
    evaluacion_interna as ei, observaciones_internas as ie 
    from residencias join anexo_30 on anexo_30.id_residencia=residencias.idresidencia
	where residencias.email_residente=v_email;
END;;

DROP PROCEDURE IF EXISTS SP_MostrarAprobado;;
CREATE PROCEDURE `SP_MostrarAprobado`(
v_email VARCHAR(64)
)
BEGIN
	select "1" as output, "Transaction commited successfully" AS message, aprobado, nombre_proyecto as proyecto, fecha_elaboracion as fecha
    from residencias join residentes on residencias.email_residente=residentes.email
    where residencias.email_residente=v_email;
END;;

DROP PROCEDURE IF EXISTS SP_MostrarAsesor;;
CREATE PROCEDURE `SP_MostrarAsesor`(
v_email VARCHAR(64)
)
BEGIN
	select "1" as output, "Transaction commited successfully" AS message,
    nombre as nombre, apellido_paterno as ap, apellido_materno as am, es_asesor as asesor
    from residencias join involucrados on residencias.idresidencia=involucrados.id_residencia
    join docentes on docentes.email=involucrados.email_docente
    where residencias.email_residente=v_email and es_asesor=1;
END;;

DROP PROCEDURE IF EXISTS SP_MostrarRevisores;;
CREATE PROCEDURE SP_MostrarRevisores(
v_email VARCHAR(64)
)
BEGIN
	select "1" as output, "Transaction commited successfully" AS message,
    nombre as nombre, apellido_paterno as ap, apellido_materno as am, es_asesor as asesor
    from residencias join involucrados on residencias.idresidencia=involucrados.id_residencia
    join docentes on docentes.email=involucrados.email_docente
    where residencias.email_residente=v_email and es_asesor!=1;
END;;


/*
	Muestra una lista de residencias sin confirmar que administra 
	el usuario con correo electrónico [v_admin_email].
	[v_query] es un parámetro que servirá para filtrar las residencias
	a mostrar. Este filtro se comparará con el nombre del proyecto,
	nombre de la empresa, nombre completo del residente, y correo
	electrónico del residente.
*/
DROP PROCEDURE IF EXISTS SP_ListaResidenciasSinDocentes;;
CREATE PROCEDURE SP_ListaResidenciasSinDocentes(
	v_email_admin VARCHAR(64),
	v_query VARCHAR(128)
) BEGIN
	SELECT 
		r.idresidencia as 'id', r.nombre_proyecto AS 'proyecto', e.nombre AS 'empresa',
		c.nombre_carrera AS 'carrera', nombreCompleto(res.email) AS 'residente',
		res.email AS 'email', r.fecha_elaboracion AS 'fecha', r.periodo AS 'periodo', 
		r.ano AS 'ano'
	FROM 
		residencias AS r JOIN empresas AS e
			on r.idresidencia = e.id_residencia
		JOIN residentes AS res
			on r.email_residente = res.email
		JOIN carreras AS c
			on c.clave = res.clave_carrera
	WHERE 
		residenciaAprobada(r.idresidencia) != 1 AND
		c.admin_email = v_email_admin AND (
			r.nombre_proyecto LIKE CONCAT('%', v_query, '%') OR
			e.nombre LIKE CONCAT('%', v_query, '%') OR
			res.email LIKE CONCAT('%', v_query, '%') OR
			nombreCompleto(res.email) LIKE CONCAT('%', v_query, '%')
		);
END;;


/*
	Muestra la información necesaria para generar el formato
	preliminar de la residencia con id [v_id_residencia], siempre 
	y cuando el correo electrónico [v_email_admin] sea
	encargado de asignar docentes al proyecto.
*/
DROP PROCEDURE IF EXISTS SP_FormatoPreliminar;;
CREATE PROCEDURE SP_FormatoPreliminar(
	v_id_residencia INT,
	v_email_admin VARCHAR(64)
) BEGIN
	SELECT 
		DISTINCT r.idresidencia,
		r.fecha_elaboracion AS 'fecha', r.nombre_proyecto AS 'proyecto',
		r.objetivo AS 'objetivo', r.justificacion AS 'justificacion',
		r.periodo AS 'periodo', r.ano AS 'ano', r.descripcion_actividades AS 'actividades',

		e.nombre AS 'empresa', e.representante as 'representante_e', e.direccion AS 'direccion_e',
		e.telefono AS 'telefono_e', e.ciudad AS 'ciudad_e', e.email AS 'email_e', e.departamento AS 'departamento_e',

		ae.nombre_completo AS 'nombre_ae', ae.puesto AS 'puesto_ae', ae.grado_estudios AS 'grado_ae', 
		ae.telefono AS 'telefono_ae', ae.email AS 'email_ae',

		nombreCompleto(res.email) as 'nombre_res', SUBSTRING(res.email, 2, 8) as 'noControl_res',
		c.nombre_carrera as 'carrera', 
		(
			SELECT telefono FROM telefonos_residentes WHERE email_residente = res.email AND fijo = 1
		) as 'tel_casa',
		(
			SELECT telefono FROM telefonos_residentes WHERE email_residente = res.email AND fijo = 0
		) as 'celular',
		res.email as 'email_res',
		concatenarHorarios(r.idresidencia) as 'horarios'
	FROM 
		residencias AS r LEFT JOIN empresas AS e
			ON r.idresidencia = e.id_residencia
		LEFT JOIN asesores_externos AS ae
			ON r.idresidencia = ae.id_residencia
		JOIN horarios AS h
			ON r.idresidencia = h.id_residencia
		LEFT JOIN residentes AS res
			ON r.email_residente = res.email
		LEFT JOIN carreras AS c
			ON res.clave_carrera = c.clave
	WHERE
		r.idresidencia = v_id_residencia AND
		c.admin_email = v_email_admin;
END;;


/*
	Regresa una lista de docentes confirmados cuyo correo 
	electrónico, nombre, o apellidos se asemejen al criterio 
	de  búsqueda [v_query].
*/
DROP PROCEDURE IF EXISTS SP_BuscarDocente;;
CREATE PROCEDURE SP_BuscarDocente(
	v_query VARCHAR(256)
) BEGIN
	SELECT 
		d.email as 'email',
		nombreCompleto(d.email) as 'nombre'
	FROM 
		docentes AS d
	WHERE
		docenteConfirmado(d.email) = 1 AND (
			d.email LIKE CONCAT('%',v_query,'%') OR
			nombreCompleto(d.email) LIKE CONCAT('%',v_query,'%')
		);
END;;


/*
	Asigna al docente con email [email_ai] como asesor interno del proyecto
	con id [id_residencia]. Además, asigna como revisores del mismo proyecto
	a los docentes con correos [email_r1] o [email_r2].

	Si la asignación salió bien, [output] será 1.
	Si alguno de los docentes no está confirmado, entonces [output] será 0.
	Si ocurrió algún error de otro tipo, [output] será -1, mientras
	[message] indicará el error ocurrido.
*/
DROP PROCEDURE IF EXISTS SP_AsignarDocentesAProyecto;;
CREATE PROCEDURE SP_AsignarDocentesAProyecto(
	v_id_residencia INT,
	v_email_ai VARCHAR(64),
	v_email_r1 VARCHAR(64),
	v_email_r2 VARCHAR(64)
) BEGIN

	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	IF v_id_residencia IN (SELECT DISTINCT id_residencia FROM involucrados) THEN BEGIN

		SELECT "0" AS output, "Esta residencia ya tiene docentes asociados" AS message;

	END; ELSEIF docenteConfirmado(v_email_ai) != 1 THEN BEGIN

		SELECT "0" AS output, "El asesor interno no ha confirmado su registro" AS message;

	END; ELSEIF docenteConfirmado(v_email_r1) != 1 OR docenteConfirmado(v_email_r2) != 1 THEN BEGIN

		SELECT "0" AS output, "Uno de los revisores no ha confirmado su registro" AS message;

	END; ELSE BEGIN

		START TRANSACTION;
			INSERT INTO involucrados VALUES (v_email_ai, v_id_residencia, 1);
			INSERT INTO involucrados VALUES (v_email_r1, v_id_residencia, default);
			INSERT INTO involucrados VALUES (v_email_r2, v_id_residencia, default);

			SELECT "1" AS output, "Transaction committed successfully" AS message;
		COMMIT;

	END; END IF;	
END;;


/**
	Regresa una lista de materias cuya nombre o clave
	se asemeje al criterio [v_query] ordenadas
	de manera alfabética con base en el nombre.
*/
DROP PROCEDURE IF EXISTS SP_BuscarMateria;;
CREATE PROCEDURE SP_BuscarMateria(
	v_query VARCHAR(256)
) BEGIN
	SELECT 
		*
	FROM
		materias as m
	WHERE
		m.clave LIKE CONCAT('%', v_query, '%') OR
		m.nombre LIKE CONCAT('%', v_query, '%')
	ORDER BY 
		m.nombre;
END;;

/*
	Inserta información en las tablas necesarias para el
	registro de un nuevo docente.
*/
DROP PROCEDURE IF EXISTS SP_RegistrarDocente;;
CREATE PROCEDURE SP_RegistrarDocente(
	v_email VARCHAR(64),
	v_pass VARCHAR(160),
	v_nombre VARCHAR(48),
	v_apellido_paterno VARCHAR(48),
	v_apellido_materno VARCHAR(48),
	v_telefono CHAR(10),
	v_url VARCHAR(256)	-- ID única generada para la confirmación del registro.
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	START TRANSACTION;
		IF v_email IN (SELECT d.email FROM docentes AS d WHERE d.confirmado = 1) THEN BEGIN
			SELECT "0" AS output, "Este email ya está registrado como docente" AS message;
		END; ELSE BEGIN
			IF v_email IN (SELECT d.email FROM docentes AS d WHERE d.confirmado = 0) THEN BEGIN
				DELETE FROM docentes WHERE email = v_email;
			END; END IF;

			INSERT INTO docentes VALUES (v_email, v_pass, v_nombre, v_apellido_paterno,v_apellido_materno, default);

			INSERT INTO confirmaciones_docentes VALUES (v_url, UNIX_TIMESTAMP() * 1000, default, v_email);

			INSERT INTO telefonos_docentes VALUES (v_telefono, v_email);

			SELECT "1" AS output, "Transaction committed successfully" AS message;
		END; END IF;
	COMMIT;
END;;


/*
	Confirmar el registro de un docente.
*/
DROP PROCEDURE IF EXISTS SP_ConfirmarDocente;;
CREATE PROCEDURE SP_ConfirmarDocente(
	v_url VARCHAR(256)
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	START TRANSACTION;
		SET @email = (SELECT docentes_email FROM confirmaciones_docentes WHERE id = v_url);

		IF v_url NOT IN (SELECT id FROM confirmaciones_docentes) THEN BEGIN
			SELECT "0" AS output, "Esta no es una dirección de confirmación válida" AS message;
		END; ELSEIF docenteConfirmado(@email) = 1 THEN BEGIN
			SELECT "0" AS output, "Ya ha confirmado su cuenta" AS message;
		END; ELSE BEGIN
			UPDATE docentes SET confirmado = 1 WHERE email = @email;
			UPDATE confirmaciones_docentes SET confirmado = 1 WHERE id = v_url;

			SELECT "1" AS output, "Transaction committed successfully" AS message;
		END; END IF;

	COMMIT;
END;;


/*
	Define al docente con email [v_email_docente] como competente
	en la asignatura con clave [v_clave_materia].
*/
DROP PROCEDURE IF EXISTS SP_AsociarDocenteMateria;;
CREATE PROCEDURE SP_AsociarDocenteMateria(
	v_email_docente VARCHAR(64),
	v_clave_materia CHAR(8)
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	START TRANSACTION;
		IF (SELECT COUNT(*) FROM competente AS c WHERE c.email_docente = v_email_docente AND c.clave_materia = v_clave_materia) = 1 THEN BEGIN

			SELECT "0" AS output, "Este docente ya es competente en esta materia" AS message;

		END; ELSE BEGIN

			INSERT INTO competente VALUES (v_email_docente, v_clave_materia);

			SELECT "1" AS output, "Transaction committed successfully" AS message;

		END; END IF;
	COMMIT;
END;;


/*
	Se crea un nuevo registro en la tabla [anexo_29] para que el
	asesor interno y externo puedan emitir una evaluación del 
	avance en la residencia.
*/
DROP PROCEDURE IF EXISTS SP_ActivarAnexo29;;
CREATE PROCEDURE SP_ActivarAnexo29(
	v_id_residencia INT,
	v_admin_email VARCHAR(64),
	urlAI VARCHAR(256),
	urlAE VARCHAR(256)
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	START TRANSACTION;

		SET @residente_email = (SELECT r.email_residente FROM residencias AS r WHERE r.idresidencia = v_id_residencia);

		IF puedeValidarResidente(@residente_email, v_admin_email) != 1 THEN BEGIN

			SELECT "0" AS output, "Este usuario no puede activar evaluaciones para esta residencia" AS message;

		END; ELSEIF residenciaAptaParaEvaluacion(v_id_residencia) != 1 THEN BEGIN 

			SELECT "0" AS output, "Esta residencia aún es apta para evaluación" AS message;

		END; ELSE BEGIN 

			-- Crear el anexo 29.
			INSERT INTO 
				anexo_29 (fecha_activacion, id_residencia)
			VALUES 
				(UNIX_TIMESTAMP() * 1000, v_id_residencia);

			SET @id = LAST_INSERT_ID();

			-- Crear enlaces únicos para evaluación.
			INSERT INTO 
				enlaces_anexo29
			VALUES 
				(urlAI, 0, default, @id), -- Asesor interno.
				(urlAE, 1, default, @id); -- Asesor externo.

			SELECT 
				"1" AS output, 
				"Transaction committed successfully" AS message,

				-- Información necesaria en el cliente.
				ae.email AS 'ae_email',
				i.email_docente AS 'ai_email',
				r.nombre_proyecto as 'proyecto',
				nombreCompleto(r.email_residente) AS 'residente'
			FROM 
				residencias AS r JOIN involucrados AS i
					ON r.idresidencia = i.id_residencia
				JOIN asesores_externos AS ae
					ON r.idresidencia = ae.id_residencia
			WHERE
				r.idresidencia = v_id_residencia AND
				i.es_asesor = 1;


		END; END IF;

	COMMIT;
END;;


/*
	Se crea un nuevo registro en la tabla [anexo_30] para que el
	asesor interno y externo puedan emitir una evaluación del 
	avance en la residencia.
*/
DROP PROCEDURE IF EXISTS SP_ActivarAnexo30;;
CREATE PROCEDURE SP_ActivarAnexo30(
	v_id_residencia INT,
	v_admin_email VARCHAR(64),
	urlAI VARCHAR(256),
	urlAE VARCHAR(256)
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;

	START TRANSACTION;

		SET @residente_email = (SELECT r.email_residente FROM residencias AS r WHERE r.idresidencia = v_id_residencia);

		IF puedeValidarResidente(@residente_email, v_admin_email) != 1 THEN BEGIN

			SELECT "0" AS output, "Este usuario no puede activar evaluaciones para esta residencia" AS message;

		END; ELSEIF residenciaAptaParaEvaluacion(v_id_residencia) != 1 THEN BEGIN 

			SELECT "0" AS output, "Esta residencia aún es apta para evaluación" AS message;

		END; ELSE BEGIN 

			-- Crear el anexo 30.
			INSERT INTO 
				anexo_30 (fecha_activacion, id_residencia)
			VALUES 
				(UNIX_TIMESTAMP() * 1000, v_id_residencia);

			SET @id = LAST_INSERT_ID();

			-- Crear enlaces únicos para evaluación.
			INSERT INTO 
				enlaces_anexo30
			VALUES 
				(urlAI, 0, default, @id), -- Asesor interno.
				(urlAE, 1, default, @id); -- Asesor externo.

			SELECT 
				"1" AS output, 
				"Transaction committed successfully" AS message,

				-- Información necesaria en el cliente.
				ae.email AS 'ae_email',
				i.email_docente AS 'ai_email',
				r.nombre_proyecto as 'proyecto',
				nombreCompleto(r.email_residente) AS 'residente'
			FROM 
				residencias AS r JOIN involucrados AS i
					ON r.idresidencia = i.id_residencia
				JOIN asesores_externos AS ae
					ON r.idresidencia = ae.id_residencia
			WHERE
				r.idresidencia = v_id_residencia AND
				i.es_asesor = 1;

		END; END IF;

	COMMIT;
END;;


/*
	Lista de residencias aptas para evaluación.

	Para que una residencia sea apta, la residencia debe
	estar aprobada, NO estar terminada, y NO contar con
	ninguna evaluación pendiente (Anexo 29 o 30).
*/
DROP PROCEDURE IF EXISTS SP_ResidenciasDisponiblesEvaluacion;;
CREATE PROCEDURE SP_ResidenciasDisponiblesEvaluacion(
	v_admin_email VARCHAR(64)
) BEGIN
	SELECT 
		r.idresidencia as 'id',
		r.nombre_proyecto AS 'proyecto', nombreCompleto(r.email_residente) AS 'residente',
		e.nombre AS 'empresa', cantidadDeAnexos29(r.idresidencia) AS 'anexos29'
	FROM
		residencias AS r JOIN empresas AS e
			ON r.idresidencia = e.id_residencia
	WHERE
		residenciaAptaParaEvaluacion(r.idresidencia) = 1 AND
		puedeValidarResidente(r.email_residente, v_admin_email) = 1;
END;;


/*
	Regresa una lista de las residencia que actualmente están siendo
	evaluadas.

	La información que incluirá cada fila será el ID de la residencia,
	el nombre del proyecto, nombre completo del residente, anexo pendiente,
	email y nombre del A.I y A.E, además de si indicar cuál de los asesores 
	aún está pendiente de evaluación.
*/
DROP PROCEDURE IF EXISTS SP_ResidenciasEnEvaluacion;;
CREATE PROCEDURE SP_ResidenciasEnEvaluacion(
	v_admin_email VARCHAR(64)
) BEGIN
	SELECT 
		r.idresidencia as 'id', r.nombre_proyecto AS 'proyecto', 
		nombreCompleto(r.email_residente) AS 'residente',
		e.nombre AS 'empresa',
		ae.email AS 'ae_email',
		ae.nombre_completo AS 'ae_nombre',
		IF(
			(
				SELECT 
					COUNT(*)
				FROM
					anexo_29
				WHERE
					fecha_externa IS NULL AND
					id_residencia = r.idresidencia
			) >= 1 OR 
			(
				SELECT 
					COUNT(*)
				FROM
					anexo_30
				WHERE
					fecha_externa IS NULL AND
					id_residencia = r.idresidencia
			) >= 1
		, 1, 0) AS 'ae_pendiente',
		d.email AS 'ai_email',
		nombreCompleto(d.email) AS 'ai_nombre',
		IF(
			(
				SELECT 
					COUNT(*)
				FROM
					anexo_29
				WHERE
					fecha_interna IS NULL AND
					id_residencia = r.idresidencia
			) >= 1 OR 
			(
				SELECT 
					COUNT(*)
				FROM
					anexo_30
				WHERE
					fecha_interna IS NULL AND
					id_residencia = r.idresidencia
			) >= 1
		, 1, 0) AS 'ai_pendiente',
		IF (
			tieneAnexo29Pendiente(r.idresidencia) = 1
		, 29, 30) AS 'anexo_pendiente'
	FROM
		residencias AS r JOIN empresas AS e
			ON r.idresidencia = e.id_residencia
		JOIN asesores_externos AS ae
			ON r.idresidencia = ae.id_residencia
		JOIN involucrados AS i
			ON r.idresidencia = i.id_residencia
		JOIN docentes AS d
			ON i.email_docente = d.email
	WHERE
		i.es_asesor = 1 AND 
		residenciaAprobada(r.idresidencia) = 1 AND
		residenciaTerminada(r.idresidencia) = 0 AND
		residenciaAptaParaEvaluacion(r.idresidencia) = 0 AND
		puedeValidarResidente(r.email_residente, v_admin_email) = 1;
END;;


/*
	Recupera información destacable para mostrar en un anexo 29 durante
	una evaluación.
*/
DROP PROCEDURE IF EXISTS SP_InformacionResidenciaParaAnexo29;;
CREATE PROCEDURE SP_InformacionResidenciaParaAnexo29(
	v_url VARCHAR(256)
) BEGIN

	IF v_url NOT IN (SELECT id FROM enlaces_anexo29 WHERE evaluado = 0) THEN BEGIN

		SELECT "0" AS output, "URL inválido." AS message;

	END; ELSE BEGIN
		SELECT 
			"1" AS output, "Success" AS message,
			r.nombre_proyecto AS 'proyecto',
			nombreCompleto(r.email_residente) AS 'residente',
			r.email_residente AS 'correo_residente'
		FROM
			residencias AS r JOIN anexo_29 AS a
				ON r.idresidencia = a.id_residencia
		WHERE
			a.idanexo_29 = idAnexo29DeURL(v_url);
	END; END IF;

END;;


/*
	Registra la evaluación de un asesor sobre una residencia profesional,
	sin importar si es un asesor interno o externo.

	[v_url] es el ID único que se le asignó a la evaluación en curso.
	[v_evaluación] es una cadena de texto que contiene la calificación
	asignada por el asesor en cada rubro, separada por una coma [,].
*/
DROP PROCEDURE IF EXISTS SP_EvaluacionA29;;
CREATE PROCEDURE SP_EvaluacionA29(
	v_url VARCHAR(256),
	v_evaluacion VARCHAR(24),
	v_observaciones VARCHAR(128)
) BEGIN
	DECLARE exit handler for SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
		
		SELECT "-1" AS output, @p2 AS message;
		
		ROLLBACK;
	END;
	START TRANSACTION;
		IF v_url NOT IN (SELECT id FROM enlaces_anexo29 WHERE evaluado = 0) THEN BEGIN

			SELECT "0" AS output, "URL inválido." AS message;

		END; ELSE BEGIN

			IF (SELECT e.es_asesor_externo FROM enlaces_anexo29 AS e WHERE id = v_url) = 0 THEN BEGIN
				-- Es asesor interno.
				UPDATE anexo_29 SET 
					fecha_interna = UNIX_TIMESTAMP() * 1000, 
					evaluacion_interna = v_evaluacion, 
					observaciones_internas = v_observaciones
				WHERE
					idanexo_29 = idAnexo29DeURL(v_url);
			END; ELSE BEGIN
				-- Es asesor externo.
				UPDATE anexo_29 SET 
					fecha_externa = UNIX_TIMESTAMP() * 1000, 
					evaluacion_externa = v_evaluacion, 
					observaciones_externas = v_observaciones
				WHERE
					idanexo_29 = idAnexo29DeURL(v_url);
			END; END IF;

			UPDATE enlaces_anexo29 SET
				evaluado = 1
			WHERE
				id = v_url;

			SELECT "1" AS output, "Transaction committed successfully" AS message;

		END; END IF;
	COMMIT;
END;;


DELIMITER ;

/* --------------------------------------------------------

	INSERTS.

-------------------------------------------------------- */
-- ---------------------------------------------
-- administradores
-- ---------------------------------------------
-- Las contraseñas de estos administradores fueron encriptadas usando la clave [H5n7jMcgSA^&Rz%ZxyFE@&E#zSteW$jx].
INSERT INTO `siger`.`administradores` 
	(email, contrasena, nombre, apellido_paterno, apellido_materno)
VALUES
	('daniel.hs@piedrasnegras.tecnm.mx', '972f6b2e8738af3347b546d00bf721e6899994c2da737a3c062878bfdafd4e498a9a9f868bcf3c91726223ba745b566a59843db4d2507c499bca8db65c05f9a30fa949e656db5299f468b3f64d4d223f', 'Daniel', 'Hernández', 'Sánchez'),
	('roberto.ds@piedrasnegras.tecnm.mx', 'd9078571e8c5bd3321237d557aee5293f942a4036fc2426b8ce1a7f4131282aa1e09388354adcf7dac24e073caeaf90ea8d4565147d136511e547cad118465a2cee26c36b675ffe73975fbc601095a63', 'Roberto Carlos', 'Díaz', 'Sánchez');

-- ---------------------------------------------
-- carreras
-- ---------------------------------------------
INSERT INTO `siger`.`carreras`
	(clave, nombre_carrera, admin_email)
VALUES
	('copu-2010-205', 'Contador Público', 'daniel.hs@piedrasnegras.tecnm.mx'),
	('ielc-2010-211', 'Ingeniería Electrónica', 'daniel.hs@piedrasnegras.tecnm.mx'),
	('igem-2009-201', 'Ingeniería en Gestión Empresarial', 'daniel.hs@piedrasnegras.tecnm.mx'),
	('iind-2010-227', 'Ingeniería Industrial', 'daniel.hs@piedrasnegras.tecnm.mx'),
	('imce-2010-229', 'Ingeniería Mecatrónica', 'roberto.ds@piedrasnegras.tecnm.mx'),
	('imec-2010-228', 'Ingeniería Mecánica', 'roberto.ds@piedrasnegras.tecnm.mx'),
	('isic-2010-204', 'Ingeniería en Sistemas Computacionales', 'roberto.ds@piedrasnegras.tecnm.mx'),
	('itic-2010-225', 'Ingeniería en Tecnologías de la Información y Comunicaciones', 'roberto.ds@piedrasnegras.tecnm.mx');

-- ---------------------------------------------
-- residentes
-- ---------------------------------------------
call SP_RegistroResidente(
  'L17430001@piedrasnegras.tecnm.mx', 'f890c6ee7325af3ad3a651e2d8135d8db74cf7f6ef0cf4758dad5bf022f3ac480dbfad4ded3a2602a23a9edd99a73c9e05efac396d52b992cf1e424222f2bd9d9ec1b8e7fdbc8c5c25cf56688911d42b', 'Xavier', 'Arroyo', 'Valdéz', '1586229655325', 'isic-2010-204', '8781234567', '8787654321'
);
call SP_RegistroResidente(
  'L17430002@piedrasnegras.tecnm.mx', 'f890c6ee7325af3ad3a651e2d8135d8db74cf7f6ef0cf4758dad5bf022f3ac480dbfad4ded3a2602a23a9edd99a73c9e05efac396d52b992cf1e424222f2bd9d9ec1b8e7fdbc8c5c25cf56688911d42b', 'Francisco', 'Sáenz', null, '1586229655325', 'iind-2010-227', '8782582582', '8788528528'
);
call SP_RegistroResidente(
  'L17430003@piedrasnegras.tecnm.mx', 'f890c6ee7325af3ad3a651e2d8135d8db74cf7f6ef0cf4758dad5bf022f3ac480dbfad4ded3a2602a23a9edd99a73c9e05efac396d52b992cf1e424222f2bd9d9ec1b8e7fdbc8c5c25cf56688911d42b', 'Eva', 'Burgos', 'Herrera', '1586229655325', 'imec-2010-228', '8781597535', '8789513575'
);
call SP_RegistroResidente(
  'L17430004@piedrasnegras.tecnm.mx', 'f890c6ee7325af3ad3a651e2d8135d8db74cf7f6ef0cf4758dad5bf022f3ac480dbfad4ded3a2602a23a9edd99a73c9e05efac396d52b992cf1e424222f2bd9d9ec1b8e7fdbc8c5c25cf56688911d42b', 'Zoe', 'Lérida', 'Ramírez', '1586229655325', 'isic-2010-204', '8781111111', '8782222222'
);
call SP_RegistroResidente(
  'L17430005@piedrasnegras.tecnm.mx', 'f890c6ee7325af3ad3a651e2d8135d8db74cf7f6ef0cf4758dad5bf022f3ac480dbfad4ded3a2602a23a9edd99a73c9e05efac396d52b992cf1e424222f2bd9d9ec1b8e7fdbc8c5c25cf56688911d42b', 'Saúl', 'Baztán', 'Escudero', '1586229655325', 'ielc-2010-211', '8783333333', '8784444444'
);
call SP_RegistroResidente(
  'L17430006@piedrasnegras.tecnm.mx', 'f890c6ee7325af3ad3a651e2d8135d8db74cf7f6ef0cf4758dad5bf022f3ac480dbfad4ded3a2602a23a9edd99a73c9e05efac396d52b992cf1e424222f2bd9d9ec1b8e7fdbc8c5c25cf56688911d42b', 'Paula', 'Caballero', null, '1586229655325', 'igem-2009-201', '8785555555', '8786666666'
);

call SP_ValidarResidente('L17430001@piedrasnegras.tecnm.mx', 'roberto.ds@piedrasnegras.tecnm.mx');
call SP_ValidarResidente('L17430002@piedrasnegras.tecnm.mx', 'daniel.hs@piedrasnegras.tecnm.mx');
call SP_ValidarResidente('L17430003@piedrasnegras.tecnm.mx', 'roberto.ds@piedrasnegras.tecnm.mx');
call SP_ValidarResidente('L17430005@piedrasnegras.tecnm.mx', 'daniel.hs@piedrasnegras.tecnm.mx');

-- ---------------------------------------------
-- docentes
-- ---------------------------------------------
-- Las contraseñas de estos docentes fueron encriptadas usando la clave secreta [H5n7jMcgSA^&Rz%ZxyFE@&E#zSteW$jx].
-- Por defecto, solo los primeros 4 docentes serán confirmados.

CALL SP_RegistrarDocente('marti.pd@piedrasnegras.tecnm.mx', '4551b7f81bb877c27da5cd4109bce58c4ae8cd51656473b191558340c23c400b99f1928ccf6e69549ec00a80f11d300b218dd2da314182fc2f7ecab7b854fd4ca041e60877725c4013613b2665bbe7aa', 'Marti', 'Peralta', 'Durán', '8781111111', '8c61d46312dd46385c5f7080e6bb416e3d9b51c9405a7801615223f80bd5933c53908a9f988806f92cc4067782479c92c5fedb90c99a59735d354cc19956c9e1b48e7a355b776b19166a10c14efd67ba');
CALL SP_ConfirmarDocente('8c61d46312dd46385c5f7080e6bb416e3d9b51c9405a7801615223f80bd5933c53908a9f988806f92cc4067782479c92c5fedb90c99a59735d354cc19956c9e1b48e7a355b776b19166a10c14efd67ba');
CALL SP_RegistrarDocente('rafael.am@piedrasnegras.tecnm.mx', '5c3d248a3bca0aa3d11f656ae1f7bc2e478ae0a101e7fb66f6270292834be634b33fe2d9c8b0f9723a7036b7086579f432577afd17a0f03cf70c340cedd38e06aced19b89f306ea62115ba01e28474a2', 'Rafael', 'Alcaide', 'Mallén', '8782222222', 'd656f1c3c1780e811ee05594cc9469fbf4d9b60ff718c5f2dca6162f4ef83b12d5ec2375200843f15767ca21d82920108ca97bed3299483daf65df6dc29ce25deba80718ab2e842707f8a41319e7c143');
CALL SP_ConfirmarDocente('d656f1c3c1780e811ee05594cc9469fbf4d9b60ff718c5f2dca6162f4ef83b12d5ec2375200843f15767ca21d82920108ca97bed3299483daf65df6dc29ce25deba80718ab2e842707f8a41319e7c143');
CALL SP_RegistrarDocente('sandra.fs@piedrasnegras.tecnm.mx', 'afdc6e60a07d7821e3ab51555bc805cc1d45453ba4d0a5141217dcb6a78342bdb62b4d256db8ef6549b9ee915720b1ddceb0f229dffac62e84f1cd0253945dc64ac2a1cc3ba543a0166ac698e6b313ff', 'Sandra', 'Fidalgo', 'Sabaté', '8783333333', '96d7333de2b8f773102e06cd5bed53a83a8b25090512d4d9ba6a676122f6bbce9ff8801f059d9a6297a3afecf5e0cfb4df9febe9f9d660af0e977513ace8ece4c73ba08f4dbe3d42f34559642e7a148e');
CALL SP_ConfirmarDocente('96d7333de2b8f773102e06cd5bed53a83a8b25090512d4d9ba6a676122f6bbce9ff8801f059d9a6297a3afecf5e0cfb4df9febe9f9d660af0e977513ace8ece4c73ba08f4dbe3d42f34559642e7a148e');
CALL SP_RegistrarDocente('adriana.sb@piedrasnegras.tecnm.mx', '8ec5e9bb7aea1f86f50723ba625dd326e69f1b07deaef71f936fac5b1d0f33ee8cfdd2b83e2d2e7fb7b23f3a265a71bfe765d832574a9691e83dd77e494401ec0807bd532d0efd1a7642725468c9b512', 'Adriana', 'Sevilla', 'Bolívar', '8784444444', '1d7e7b4674107a43440455dfd043f507ebfef1d3d2d2a76c5cc2195e4a1efd36ac13f4166f21c7b58688b55568f5d145a20df0ef5031ae392b7ec756599b821621efd258e38d6275f24564b20377f929');
CALL SP_ConfirmarDocente('1d7e7b4674107a43440455dfd043f507ebfef1d3d2d2a76c5cc2195e4a1efd36ac13f4166f21c7b58688b55568f5d145a20df0ef5031ae392b7ec756599b821621efd258e38d6275f24564b20377f929');
CALL SP_RegistrarDocente('izan.mm@piedrasnegras.tecnm.mx', '12f3d773c7b5a99b82ef470a27c2c9995bafc695968d9783488e304a87b7710582eb7eb9ba383bf43ee45309a5481a765dce26536881b7f24fec94f9ba6a237faac087879700ecc0a4ab828a5dd43eb0', 'Izan', 'Martín', 'Malillos', '8785555555 ', '12d705ba659e85d42431a18ea3f9f91bc528cdc8a6317f61a1e9171d5921715b30dcbf87e38a320b518f413debe8fc04bd13ff44dd40432907296c958f21c11d7f7b700d61ef6f4d92b11b15cf6dbc65');
CALL SP_ConfirmarDocente('12d705ba659e85d42431a18ea3f9f91bc528cdc8a6317f61a1e9171d5921715b30dcbf87e38a320b518f413debe8fc04bd13ff44dd40432907296c958f21c11d7f7b700d61ef6f4d92b11b15cf6dbc65');
CALL SP_RegistrarDocente('alonso.sm@piedrasnegras.tecnm.mx', '73c94b2912b5915146ba1e5258451d4262a3f05617a63ae94c05f4695cb78ab7290a37451f9597791b0a2e568deca927593a20ac30619256d5b84320694d4631cdc4a832a6614f0372ff98920c84fe25', 'Alonso', 'Sánchez', 'Montemayor', '8786666666', '325a8a4770d780f73d40f04bddb42003007fa2bd605832bddb5860782f77ea327b5afe23be1745f7a10b6ec8e863af1113d3f8aa4669a0dc3cc71825b521e7ec4973d1ec0ed35776cac8000150fd7940');
CALL SP_RegistrarDocente('rosa.gc@piedrasnegras.tecnm.mx', 'cd406867e7428e7aeace45793637aef06c590e1b980061587caa03590b8d20d5240625e9aaaddb4003db49cffd338f88b8aa7ed3a06a9830fa938561215931a7ca774b20bc7abb5a462e3d7ea118b82f', 'Rosa', 'Gallego', 'Colina', '8787777777', '5629987dc40b58f7334850d1788b13665d0bea8ecd489697a30ebf221891da15b3a395a192eb0520b872636e017e9f5218aa4407fdafb7d364a9dc1e980f7d0cf08b153264297aeb4555c1ea7e4e7bde');
CALL SP_RegistrarDocente('maria.gm@piedrasnegras.tecnm.mx', 'ac30e7658f0dfb0c66235730cf31a7976101ce88aa55ffa4350878d33df36c5c8df45d7bc37fbca71fe02bfdf0c593023e80020316079fe51061abcbecc712df22117263e3e2f25e6820e9b07d235a17', 'Maria José', 'Gutiérrez', 'Malillos', '8788888888', 'acde321dcf98ce192877beed7b2f30753e9f98073d2ec379fbd885ee96f1bea23314d69929fb352d235955bf39c7f91856cb9ccc65a1c8dd06a919f1b7591d67a9dda24c17344a663d8e337e9f17f9c2');
CALL SP_RegistrarDocente('rafael.cc@piedrasnegras.tecnm.mx', 'afb8baa57eeed18dfe253d4ad257e8e26f00645032d0b40e53365bff42077839cdc3793a64455e429018bd1e1d1e38a053407764e8890664cbfa1748d598d03d797b9c3fa0cc4a9f3f404021f48e0338', 'Rafael', 'Contador', 'Cueva', '8780000000', '58c9b3fc6ef05bb20fb08e2895dc308b4b783ca41a3557ff881d54c13c390c967406d992f496dd8c471b7ef161fa84d2c17c5fffb96af4e1ada2047cecbf0036c957774127672d148e838aa5c576e308');
CALL SP_RegistrarDocente('celia.pd@piedrasnegras.tecnm.mx', 'a0d4c93f29656492dbd4cbeca385fbaa1e0915f3c47d5cc8dd23bead85754427b33c670c061df4d080d1fb4386db4c9fc41435fbc5475189caa54f05e8988b720be20ac2a118778d55db6f3fced60b2e', 'Celia', 'Pastor', 'Domínguez', '8789999999', '1eb3cf32577c04293c1975b56d2548b1ff38b1298f20329a617942f4e12c86ddced23328206093d56179961d79533699207cc066fd1680839b287ddc0a8341909d2795f3ae62cfefe5e2a92877274c9d');

-- ---------------------------------------------
-- residencias
-- ---------------------------------------------
call SP_RegistroResidencia(
	'Volt Breaker', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 1, 2020, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',/* 0,*/ 'L17430001@piedrasnegras.tecnm.mx', '1586570609000', 'Twilight Electronics', 'Amir Obrero', 'Olive Street', 'Kugate', '8781234567', 'twilightelectronics@gmail.com', 'Sistemas y Computación', 'amirobrero@gmail.com', 'Amir Obrero', 'Jefe de departamento', 'Licenciatura', '8781234568'
);
call SP_RegistraHorarios('01:00', '07:00', 1);
call SP_RegistroResidencia(
	'Alpha Entangler', 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 
	1, 2021, 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',/* 0, */
	'L17430002@piedrasnegras.tecnm.mx', 
	'1586570609000', 
	'Butterfly Media', 
	'Oliver Linares', 
	'Ebon Avenue', 
	'Gardelita', '8781234567', 
	'butterflymedia@gmail.com', 
	'Sistemas y Computación', 
	'oliverlinares@gmail.com',
	'Oliver Linares', 
	'Jefe de departamento', 'Licenciatura', '8781234568'
);
call SP_RegistraHorarios('15:00', '20:00', 2);
call SP_RegistroResidencia(
	'Harmonic Diverter', 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 
	2, 2021, 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',/* 0, */
	'L17430003@piedrasnegras.tecnm.mx', 
	'1586570609000', 
	'Prodigy Aviation', 
	'Izan Madrid', 
	'Starfall Route', 
	'San Ancazu', 
	'8781234567', 
	'prodigyaviation@gmail.com', 
	'Sistemas y Computación', 
	'izanmadrid@gmail.com',
	'Izan Madrid', 
	'Jefe de departamento', 'Licenciatura', '8781234568'
);
call SP_RegistraHorarios('13:00', '16:00', 3);
call SP_RegistraHorarios('17:30', '20:30', 3);
call SP_RegistroResidencia(
	'Cosmic Reactor', 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 
	2, 2020, 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',/* 0, */
	'L17430004@piedrasnegras.tecnm.mx', 
	'1586570609000', 
	'Alphacom', 
	'Sergi Ferrero', 
	'Windmill Avenue', 
	'San Ancazu', 
	'8781234567', 
	'alphacom@gmail.com', 
	'Sistemas y Computación', 
	'sergiferrero@gmail.com',
	'Sergi Ferrero', 
	'Jefe de departamento', 'Licenciatura', '8781234568'
);
call SP_RegistraHorarios('13:00', '14:00', 4);
call SP_RegistraHorarios('15:00', '17:00', 4);
call SP_RegistraHorarios('20:00', '24:00', 4);
call SP_RegistroResidencia(
	'Particle Shaper', 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 
	2, 2020, 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',/* 0, */
	'L17430005@piedrasnegras.tecnm.mx', 
	'1586570609000', 
	'Alphacom', 
	'Sergi Ferrero', 
	'Windmill Avenue', 
	'San Ancazu', 
	'8781234567', 
	'alphacom@gmail.com', 
	'Sistemas y Computación', 
	'sergiferrero@gmail.com',
	'Sergi Ferrero', 
	'Jefe de departamento', 'Licenciatura', '8781234568'
);
call SP_RegistraHorarios('13:30', '15:30', 5);
call SP_RegistraHorarios('17:00', '19:00', 5);
call SP_RegistroResidencia(
	'Kwolek Communicator', 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 
	2, 2021, 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',/* 0, */
	'L17430006@piedrasnegras.tecnm.mx', 
	'1586570609000', 
	'Oracleutions', 
	'Mateo Escrivá', 
	'Noble Route', 
	'San Fracillo', 
	'8781234567', 
	'oracleutions@gmail.com', 
	'Sistemas y Computación', 
	'mateoescriva@gmail.com',
	'Mateo Escrivá', 
	'Jefe de departamento', 'Licenciatura', '8781234568'
);
call SP_RegistraHorarios('15:00', '20:00', 6);


/* --------------------------------------------------------

	Materias

-------------------------------------------------------- */
-- ISC. Desarrollo Web y Aplicaciones Móviles.
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('scd-1008', 'Fundamentos de Programacion');
INSERT INTO materias VALUES ('scd-1020', 'Programación Orientada a Objetos');
INSERT INTO materias VALUES ('aed-1026', 'Estructura de Datos');
INSERT INTO materias VALUES ('scc-1017', 'Métodos Numéricos');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('aec-1008', 'Contabilidad Financiera');
INSERT INTO materias VALUES ('scc-1005', 'Cultura Empresarial');
INSERT INTO materias VALUES ('aef-1041', 'Matemáticas Discretas');
INSERT INTO materias VALUES ('aec-1058', 'Química');
INSERT INTO materias VALUES ('scc-1013', 'Investigación de Operaciones');
INSERT INTO materias VALUES ('aef-1031', 'Fundamentos de Bases de Datos');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('sca-1026', 'Taller de Sistemas Operativos');
INSERT INTO materias VALUES ('aef-1052', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('scf-1006', 'Física General');
INSERT INTO materias VALUES ('scd-1018', 'Principios Eléctricos y Aplicaciones Digitales');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('scd-1015', 'Lenguajes y Autómatas I');
INSERT INTO materias VALUES ('scd-1016', 'Lenguajes y Autómatas II');
INSERT INTO materias VALUES ('scc-1019', 'Programación Lógica y Funcional');
INSERT INTO materias VALUES ('scc-1012', 'Inteligencia Artificial');
INSERT INTO materias VALUES ('aec-1034', 'Fundamentos de Telecomunicaciones');
INSERT INTO materias VALUES ('scd-1021', 'Redes de Computadora');
INSERT INTO materias VALUES ('scd-1004', 'Comunicación y Enrutamiento de Redes de Datos');
INSERT INTO materias VALUES ('sca-1002', 'Administración de redes');
INSERT INTO materias VALUES ('dwb-1404', 'Programación Multiplataforma para Aplicaciones Móviles (Especialidad)');
INSERT INTO materias VALUES ('sca-1025', 'Taller de Bases de Datos');
INSERT INTO materias VALUES ('scb-1001', 'Administración de Bases de Datos');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('dwd-1405', 'Diseño para Aplicaciones Móviles (Especialidad)');
INSERT INTO materias VALUES ('scd-1022', 'Simulación');
INSERT INTO materias VALUES ('aeb-1055', 'Programación Web');
INSERT INTO materias VALUES ('dwb-1401', 'Programación Web II (Especialidad)');
INSERT INTO materias VALUES ('scc-1010', 'Graficación');
INSERT INTO materias VALUES ('scc-1007', 'Fundamentos de Ingeniería de Software');
INSERT INTO materias VALUES ('scd-1011', 'Ingeniería de Software');
INSERT INTO materias VALUES ('scg-1009', 'Gestión de Proyectos de Software');
INSERT INTO materias VALUES ('dwb-1402', 'Programación de Aplicaciones Nativas para Móviles (Especialidad)');
INSERT INTO materias VALUES ('scd-1003', 'Arquitectura de Computadoras');
INSERT INTO materias VALUES ('scc-1014', 'Lenguajes de Interfaz');
INSERT INTO materias VALUES ('scc-1023', 'Sistemas Programables');
INSERT INTO materias VALUES ('dwd-1403', 'Diseño e Implementación de Sitios Web (Especialidad)');
INSERT INTO materias VALUES ('scd-1027', 'Topicos Avanzados de Programación');
INSERT INTO materias VALUES ('aec-1061', 'Sistemas Operativos I');
INSERT INTO materias VALUES ('sch-1024', 'Taller de Administración');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');

-- ISC. Teconologías Emergentes.
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('scd-1008', 'Fundamentos de Programacion');
INSERT INTO materias VALUES ('scd-1020', 'Programación Orientada a Objetos');
INSERT INTO materias VALUES ('aed-1026', 'Estructura de Datos');
INSERT INTO materias VALUES ('scc-1017', 'Métodos Numéricos');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('aec-1008', 'Contabilidad Financiera');
INSERT INTO materias VALUES ('scc-1005', 'Cultura Empresarial');
INSERT INTO materias VALUES ('scd-1027', 'Topicos Avanzados de Programación');
INSERT INTO materias VALUES ('aef-1041', 'Matemáticas Discretas');
INSERT INTO materias VALUES ('aec-1058', 'Química');
INSERT INTO materias VALUES ('scc-1013', 'Investigación de Operaciones');
INSERT INTO materias VALUES ('aef-1031', 'Fundamentos de Bases de Datos');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('aec-1061', 'Sistemas Operativos I');
INSERT INTO materias VALUES ('sca-1026', 'Taller de Sistemas Operativos');
INSERT INTO materias VALUES ('aef-1052', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('scf-1006', 'Física General');
INSERT INTO materias VALUES ('scd-1018', 'Principios Eléctricos y Aplicaciones Digitales');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('scd-1015', 'Lenguajes y Autómatas I');
INSERT INTO materias VALUES ('scd-1016', 'Lenguajes y Autómatas II');
INSERT INTO materias VALUES ('scc-1019', 'Programación Lógica y Funcional');
INSERT INTO materias VALUES ('scc-1012', 'Inteligencia Artificial');
INSERT INTO materias VALUES ('aec-1034', 'Fundamentos de Telecomunicaciones');
INSERT INTO materias VALUES ('scd-1021', 'Redes de Computadora');
INSERT INTO materias VALUES ('scd-1004', 'Comunicación y Enrutamiento de Redes de Datos');
INSERT INTO materias VALUES ('sca-1002', 'Administración de redes');
INSERT INTO materias VALUES ('ted-1404', 'Tecnologías de Virtualización (Especialidad)');
INSERT INTO materias VALUES ('sca-1025', 'Taller de Bases de Datos');
INSERT INTO materias VALUES ('scb-1001', 'Administración de Bases de Datos');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('ted-1405', 'Planes y Respuestas a Contingencias (Especialidad)');
INSERT INTO materias VALUES ('scd-1022', 'Simulación');
INSERT INTO materias VALUES ('aeb-1055', 'Programación Web');
INSERT INTO materias VALUES ('teb-1401', 'Programación Web II (Especialidad)');
INSERT INTO materias VALUES ('scc-1010', 'Graficación');
INSERT INTO materias VALUES ('scc-1007', 'Fundamentos de Ingeniería de Software');
INSERT INTO materias VALUES ('scd-1011', 'Ingeniería de Software');
INSERT INTO materias VALUES ('scg-1009', 'Gestión de Proyectos de Software');
INSERT INTO materias VALUES ('teb-1402', 'Programación de Bases de Datos (Especialidad)');
INSERT INTO materias VALUES ('scd-1003', 'Arquitectura de Computadoras');
INSERT INTO materias VALUES ('scc-1014', 'Lenguajes de Interfaz');
INSERT INTO materias VALUES ('scc-1023', 'Sistemas Programables');
INSERT INTO materias VALUES ('tef-1403', 'Inteligencia de Negocios (Especialidad)');
INSERT INTO materias VALUES ('sch-1024', 'Taller de Administración');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');

-- Ingeniería Electrónica.
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('aef-1042', 'Mecánica Clásica');
INSERT INTO materias VALUES ('aee-1051', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('aef-1020', 'Electromagnetismo');
INSERT INTO materias VALUES ('etf-1004', 'Circuitos Eléctricos I');
INSERT INTO materias VALUES ('aec-1058', 'Química');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('etp-1020', 'Marco Legal de la Empresa');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('etd-1021', 'Mediciones Eléctricas');
INSERT INTO materias VALUES ('etf-1017', 'Física de Semiconductores');
INSERT INTO materias VALUES ('etf-1003', 'Análisis Numérico');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('etf-1027', 'Tópicos Selectos de Física');
INSERT INTO materias VALUES ('etd-1024', 'Programación Estructurada');
INSERT INTO materias VALUES ('etf-1014', 'Diseño Digital');
INSERT INTO materias VALUES ('etq-1006', 'Comunicación Humana');
INSERT INTO materias VALUES ('etq-1009', 'Desarrollo Humano');
INSERT INTO materias VALUES ('etd-1025', 'Programación Visual');
INSERT INTO materias VALUES ('etf-1005', 'Circuitos Eléctricos II');
INSERT INTO materias VALUES ('aef-1009', 'Control I');
INSERT INTO materias VALUES ('aef-1010', 'Control II');
INSERT INTO materias VALUES ('etf-1007', 'Control Digital');
INSERT INTO materias VALUES ('eto-1011', 'Desarrollo y Evaluación de Proyectos');
INSERT INTO materias VALUES ('etf-1012', 'Diodos y Transistores');
INSERT INTO materias VALUES ('etf-1013', 'Diseño con Transistores');
INSERT INTO materias VALUES ('etf-1002', 'Amplificadores Operacionales');
INSERT INTO materias VALUES ('etf-1008', 'Controladores Lógicos Programables');
INSERT INTO materias VALUES ('auf-1405', 'Redes de Comunicación Industrial (Especialidad)');
INSERT INTO materias VALUES ('etf-1026', 'Teoría Electromagnética');
INSERT INTO materias VALUES ('etp-1018', 'Fundamentos Financieros');
INSERT INTO materias VALUES ('aef-1038', 'Instrumentación');
INSERT INTO materias VALUES ('etf-1016', 'Electrónica de Potencia');
INSERT INTO materias VALUES ('auf-1406', 'Tópicos Selectos de Automatización (Especialidad)');
INSERT INTO materias VALUES ('aef-1040', 'Máquinas Eléctricas');
INSERT INTO materias VALUES ('etd-1022', 'Microcrontroladores');
INSERT INTO materias VALUES ('etf-1028', 'Optoelectrónica');
INSERT INTO materias VALUES ('etr-1001', 'Administración Gerencial');
INSERT INTO materias VALUES ('etf-1015', 'Diseño Digital con VHDL');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('etf-1019', 'Introducción a las Telecomunicaciones');
INSERT INTO materias VALUES ('auf-1402', 'Adquisición de Datos (Especialidad)');
INSERT INTO materias VALUES ('eto-1010', 'Desarrollo Profesional');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('auf-1403', 'Circuitos Hidráulicos y Neumáticos (Especialidad)');
INSERT INTO materias VALUES ('auf-1401', 'Diseño Asistido Por Computadora (Especialidad)');
INSERT INTO materias VALUES ('auf-1404', 'Robótica (Especialidad)');

-- Ingeniería Mecánica.
INSERT INTO materias VALUES ('mev-1006', 'Dibujo Mecánico');
INSERT INTO materias VALUES ('mec-1023', 'Probabiliad y Estadística');
INSERT INTO materias VALUES ('med-1010', 'Estatica');
INSERT INTO materias VALUES ('med-1020', 'Mecánica de Materiales I');
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('aeh-1393', 'Metrología y Normalización');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('mec-1003', 'Calidad');
INSERT INTO materias VALUES ('aed-1391', 'Dinámica');
INSERT INTO materias VALUES ('mec-1026', 'Química');
INSERT INTO materias VALUES ('mef-1013', 'Ingeniería de Materiales Metálicos');
INSERT INTO materias VALUES ('mef-1014', 'Ingeniería de Materiales No Metálicos');
INSERT INTO materias VALUES ('med-1025', 'Procesos de Manufactura');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('mea-1001', 'Algoritmos y Programación');
INSERT INTO materias VALUES ('aef-1020', 'Electromagnetismo');
INSERT INTO materias VALUES ('med-1030', 'Sistemas Electrónicos');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('mer-1024', 'Proceso Administrativo');
INSERT INTO materias VALUES ('mer-1005', 'Contabilidad y Costos');
INSERT INTO materias VALUES ('aec-1046', 'Métodos Numéricos');
INSERT INTO materias VALUES ('med-1021', 'Mecánica de Materiales II');
INSERT INTO materias VALUES ('med-1008', 'Diseño Mecánico I');
INSERT INTO materias VALUES ('med-1009', 'Diseño Mecánico II');
INSERT INTO materias VALUES ('mec-1016', 'Mantenimiento');
INSERT INTO materias VALUES ('aed-1043', 'Mecanismos');
INSERT INTO materias VALUES ('aed-1067', 'Vibraciones Mecánicas');
INSERT INTO materias VALUES ('mer-1012', 'Higiene y Seguridad Industrial');
INSERT INTO materias VALUES ('mel-1028', 'Sistemas de Generación de Energía');
INSERT INTO materias VALUES ('mef-1031', 'Termodinámica');
INSERT INTO materias VALUES ('mef-1032', 'Transferencia de Calor');
INSERT INTO materias VALUES ('mee-1017', 'Máquinas de Fluidos Compresibles');
INSERT INTO materias VALUES ('med-1027', 'Refrigeración y Aire Acondicionado');
INSERT INTO materias VALUES ('mec-1019', 'Mecánica de Fluidos');
INSERT INTO materias VALUES ('med-1029', 'Sistemas e Instalaciones Hidráulicas');
INSERT INTO materias VALUES ('mef-1018', 'Máquinas de Fluidos Incompresibles');
INSERT INTO materias VALUES ('mec-1011', 'Gestión de Proyectos');
INSERT INTO materias VALUES ('med-1004', 'Circuitos y Máquinas Eléctricas');
INSERT INTO materias VALUES ('mef-1015', 'Instrumentación y Control');
INSERT INTO materias VALUES ('mef-1002', 'Automatización Industrial');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');

-- Ingeniería Mecatrónica.
INSERT INTO materias VALUES ('aec-1058', 'Química');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('acf-0905', 'Ecuaciones Diferenciales');
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('mtc-1022', 'Procesos de Fabricación');
INSERT INTO materias VALUES ('mtc-1017', 'Fundamentos de Termodinámica');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('mtf-1004', 'Ciencia e Ingeniería de los Materiales');
INSERT INTO materias VALUES ('aef-1020', 'Electromagnetismo');
INSERT INTO materias VALUES ('mtj-1020', 'Mecánica de Materiales');
INSERT INTO materias VALUES ('aea-1013', 'Dibujo Asistido por Computadora');
INSERT INTO materias VALUES ('mtd-1024', 'Programación Básica');
INSERT INTO materias VALUES ('mtc-1015', 'Estática');
INSERT INTO materias VALUES ('mtc-1008', 'Dinámica');
INSERT INTO materias VALUES ('aec-1047', 'Metrología y Normalización');
INSERT INTO materias VALUES ('mtc-1014', 'Estadística y Control de Calidad');
INSERT INTO materias VALUES ('aec-1046', 'Métodos Numéricos');
INSERT INTO materias VALUES ('mtj-1002', 'Análisis de Circuitos Eléctricos');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('mtc-1001', 'Administración y Contabilidad');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('aef-1040', 'Máquinas Eléctricas');
INSERT INTO materias VALUES ('mtj-1012', 'Electrónica de Potencia Aplicada');
INSERT INTO materias VALUES ('mtf-1009', 'Dinámica de Sistemas');
INSERT INTO materias VALUES ('mtj-1006', 'Control');
INSERT INTO materias VALUES ('mtf-1025', 'Robótica');
INSERT INTO materias VALUES ('mtj-1011', 'Electrónica Analógica');
INSERT INTO materias VALUES ('aef-1038', 'Instrumentación');
INSERT INTO materias VALUES ('mtd-1019', 'Manufactura Avanzada');
INSERT INTO materias VALUES ('mto-1016', 'Formulación y Evaluación de Proyectos');
INSERT INTO materias VALUES ('atf-1404', 'Redes de Comunicación Industrial (Especialidad)');
INSERT INTO materias VALUES ('aed-1043', 'Mecanismos');
INSERT INTO materias VALUES ('mtf-1010', 'Diseño de Elementos Mecánicos');
INSERT INTO materias VALUES ('mtg-1005', 'Circuitos Hidráulicos y Neumáticos');
INSERT INTO materias VALUES ('mtd-1007', 'Controladores Lógicos Programables');
INSERT INTO materias VALUES ('atf-1405', 'Tópicos Selectos de Automatización (Especialidad)');
INSERT INTO materias VALUES ('mtc-1003', 'Análisis de Fluidos');
INSERT INTO materias VALUES ('mtf-1013', 'Electrónica Digital');
INSERT INTO materias VALUES ('mtf-1018', 'Mantenimiento');
INSERT INTO materias VALUES ('atf-1401', 'Adquisición de Datos (Especialidad)');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aed-1067', 'Vibraciones Mecánicas');
INSERT INTO materias VALUES ('mtf-1021', 'Microcontroladores');
INSERT INTO materias VALUES ('atf-1402', 'Diseño Asistido por Computadora (Especialidad)');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('mtg-1023', 'Programación Avanzada');
INSERT INTO materias VALUES ('atf-1403', 'Diseño Digital con VHDL (Especialidad)');

-- Ingeniería Industrial.
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('inc-1009', 'Electricidad y Electrónica Industrial');
INSERT INTO materias VALUES ('aec-1047', 'Metrología y Normalización');
INSERT INTO materias VALUES ('inc-1023', 'Procesos de Fabricación');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('inc-1024', 'Propiedad de los Materiales');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('inc-1013', 'Física');
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('acf-0904', 'Cálculo Vectorial');
INSERT INTO materias VALUES ('inc-1005', 'Algoritmos y Lenguajes de Programación');
INSERT INTO materias VALUES ('inh-1029', 'Taller de Herramientas Intelectuales');
INSERT INTO materias VALUES ('inr-1017', 'Ingeniería de Sistemas');
INSERT INTO materias VALUES ('aec-1018', 'Economía');
INSERT INTO materias VALUES ('inc-1018', 'Investigación de Operaciones I');
INSERT INTO materias VALUES ('inc-1025', 'Química');
INSERT INTO materias VALUES ('aec-1053', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('aef-1024', 'Estadística Inferencial I');
INSERT INTO materias VALUES ('aef-1025', 'Estadística Inferencial II');
INSERT INTO materias VALUES ('inn-1008', 'Dibujo Industrial');
INSERT INTO materias VALUES ('inq-1006', 'Análisis de la Realidad Nacional');
INSERT INTO materias VALUES ('inj-1011', 'Estudio del Trabajo I');
INSERT INTO materias VALUES ('inj-1012', 'Estudio del Trabajo II');
INSERT INTO materias VALUES ('inc-1030', 'Taller de Liderazgo');
INSERT INTO materias VALUES ('inf-1016', 'Higiene y Seguridad Industrial');
INSERT INTO materias VALUES ('inr-1003', 'Administración de Proyectos');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('aed-1030', 'Formulación y Evaluación de Proyectos');
INSERT INTO materias VALUES ('inc-1014', 'Gestión de Costos');
INSERT INTO materias VALUES ('aec-1037', 'Ingeniería Económica');
INSERT INTO materias VALUES ('inc-1021', 'Planeación Financiera');
INSERT INTO materias VALUES ('inc-1026', 'Relaciones Industriales');
INSERT INTO materias VALUES ('inc-1001', 'Administración de las Operaciones I');
INSERT INTO materias VALUES ('inc-1002', 'Administración de las Operaciones II');
INSERT INTO materias VALUES ('inc-1022', 'Planeación y Diseño de Instalaciones');
INSERT INTO materias VALUES ('inc-1019', 'Investigación de Operaciones II');
INSERT INTO materias VALUES ('inc-1027', 'Simulación');
INSERT INTO materias VALUES ('inf-1028', 'Sistemas de Manufactura');
INSERT INTO materias VALUES ('inf-1007', 'Control Estadístico de la Calidad');
INSERT INTO materias VALUES ('inc-1004', 'Administración del Mantenimiento');
INSERT INTO materias VALUES ('inh-1020', 'Logística y Cadenas de Suministro');
INSERT INTO materias VALUES ('inc-1015', 'Gestión de los Sistemas de Calidad');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');

-- Ingeniería en Gestión Empresarial.
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('geb-0931', 'Software de Aplicación Ejecutivo');
INSERT INTO materias VALUES ('gec-0926', 'Marco Legal de las Organizaciones');
INSERT INTO materias VALUES ('gef-0922', 'Ingeniería Económica');
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('gef-0929', 'Probabilidad y Estadística Descriptiva');
INSERT INTO materias VALUES ('geg-0910', 'Estadística Inferencial I');
INSERT INTO materias VALUES ('ged-0904', 'Cont. Orientada a los Negocios');
INSERT INTO materias VALUES ('ged-0905', 'Costos Empresariales');
INSERT INTO materias VALUES ('ged-0923', 'Inst. de Presup. Empresarial');
INSERT INTO materias VALUES ('gef-0915', 'Fund. de Gestión Empresarial');
INSERT INTO materias VALUES ('aec-1014', 'Dinámica Social');
INSERT INTO materias VALUES ('gec-0919', 'Habilidades Directivas I');
INSERT INTO materias VALUES ('gec-0920', 'Habilidades Directivas II');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('gef-0907', 'Economía Empresarial');
INSERT INTO materias VALUES ('gef-0909', 'Entorno Macroeconómico');
INSERT INTO materias VALUES ('gef-0914', 'Fundamentos de Química');
INSERT INTO materias VALUES ('gee-0925', 'Legislación Laboral');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('gef-0924', 'Investigación de Operaciones');
INSERT INTO materias VALUES ('gef-0912', 'Finanzas en las Organizaciones');
INSERT INTO materias VALUES ('gef-0901', 'Adm. de la Salud Seg. Ocupacional');
INSERT INTO materias VALUES ('ged-0903', 'Calidad Apda. a la Gest. Empresarial');
INSERT INTO materias VALUES ('rhm-1701', 'Gestión de Remu. y Prestaciones (Especialidad) ');
INSERT INTO materias VALUES ('rhj-1705', 'Administración de la Seg. Ind. y Salud Ocupac. (Especialidad)');
INSERT INTO materias VALUES ('geg-0911', 'Estadística Inferencial II');
INSERT INTO materias VALUES ('ged-0908', 'El Emprendedor y la Innovación');
INSERT INTO materias VALUES ('ged-0928', 'Plan de Negocios');
INSERT INTO materias VALUES ('rhm-1702', 'Psicología de Ingeniería (Especialidad)');
INSERT INTO materias VALUES ('gef-0921', 'Ingeniería de Procesos');
INSERT INTO materias VALUES ('gef-0902', 'Cadena de Suministros');
INSERT INTO materias VALUES ('geg-0918', 'Gestión del Capital Humano');
INSERT INTO materias VALUES ('aed-1015', 'Diseño Organizacional');
INSERT INTO materias VALUES ('aed-1035', 'Gestión Estratégica');
INSERT INTO materias VALUES ('rhg-1703', 'Alta Dirección (Especialidad)');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('rhg-1704', 'Integración del Talento Humano (Especialidad)');
INSERT INTO materias VALUES ('gef-0927', 'Mercadotecnia');
INSERT INTO materias VALUES ('gec-0930', 'Sist. de la Inf. de la Mercadotecnia');
INSERT INTO materias VALUES ('aeb-1045', 'Mercadotecnia Electrónica');
INSERT INTO materias VALUES ('gec-0905', 'Desarrollo Humano ');
INSERT INTO materias VALUES ('gec-0909', 'Fundamentos de Física');
INSERT INTO materias VALUES ('gec-0911', 'Gestión de la Producción I');
INSERT INTO materias VALUES ('gec-0912', 'Gestión de la Producción II');

-- ITICs. Desarrollo Web y Aplicaciones Móviles.
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('tie-1018', 'Matematicas Aplicadas a la Comunicacion');
INSERT INTO materias VALUES ('tid-1004', 'Analisis de Señal y Sistemas de Comunicacion');
INSERT INTO materias VALUES ('scd-1008', 'Fundamentos de Programacion');
INSERT INTO materias VALUES ('scd-1020', 'Programación Orientada a Objetos');
INSERT INTO materias VALUES ('aed-1026', 'Estructura de Datos');
INSERT INTO materias VALUES ('tib-1024', 'Programacion II');
INSERT INTO materias VALUES ('tif-1019', 'Matematicas Discretas I');
INSERT INTO materias VALUES ('tif-1020', 'Matematicas Discretas II');
INSERT INTO materias VALUES ('tic-1002', 'Administracion Gerencial');
INSERT INTO materias VALUES ('tif-1021', 'Matematicas Para Toma de Deciciones');
INSERT INTO materias VALUES ('tip-1017', 'Introducción a las TICs');
INSERT INTO materias VALUES ('aef-1052', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('aef-1031', 'Fundamentos de Bases de Datos');
INSERT INTO materias VALUES ('aeh-1063', 'Taller de bases de Datos');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('tif-1009', 'Contabilidad y Costos');
INSERT INTO materias VALUES ('tic-1011', 'Electricidad y Magnetismo');
INSERT INTO materias VALUES ('tid-1008', 'Circuitos Electricos y Electronicos');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('tic-1014', 'Ingenieria de Software');
INSERT INTO materias VALUES ('tif-1013', 'Fundamentos de Redes');
INSERT INTO materias VALUES ('tif-1026', 'Redes de computadora');
INSERT INTO materias VALUES ('tif-1027', 'Redes emergentes');
INSERT INTO materias VALUES ('tif-1003', 'Administracion y Seguridad de Redes');
INSERT INTO materias VALUES ('tif-1030', 'Telecomunicaciones');
INSERT INTO materias VALUES ('tib-1025', 'Programacion Web');
INSERT INTO materias VALUES ('aeb-1011', 'Desarrollo de Aplicaciones para Dispositivos Moviles');
INSERT INTO materias VALUES ('tic-1006', 'Auditoria en Tecnologias de Informacion');
INSERT INTO materias VALUES ('dwb-1404', 'Programación Multiplataforma para Aplicaciones Móviles (Especialidad)');
INSERT INTO materias VALUES ('tif-1001', 'Administracion de Proyectos');
INSERT INTO materias VALUES ('tid-1010', 'Desarrollo de emprendedores');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('tih-1016', 'Interaccion Humano Computadora');
INSERT INTO materias VALUES ('dwd-1405', 'Diseño para Aplicaciones Móviles (Especialidad)');
INSERT INTO materias VALUES ('tif-1007', 'Base de Datos Distribuidas');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('dwb-1401', 'Programación Web II (Especialidad)');
INSERT INTO materias VALUES ('tic-1015', 'Ingenieria del Conocimiento');
INSERT INTO materias VALUES ('tic-1005', 'Arquitectura de computadoras');
INSERT INTO materias VALUES ('aec-1061', 'Sistemas Operativos I');
INSERT INTO materias VALUES ('aed-1062', 'Sistemas Operativos II');
INSERT INTO materias VALUES ('dwb-1402', 'Programación de Aplicaciones Nativas para Móviles (Especialidad)');
INSERT INTO materias VALUES ('tic-1028', 'Taller de Ingenieria de Software');
INSERT INTO materias VALUES ('tic-1029', 'Tecnologias Inalambricas');
INSERT INTO materias VALUES ('dwd-1403', 'Diseño e Implementación de Sitios Web (Especialidad)');
INSERT INTO materias VALUES ('tic-1022', 'Negocios Electronicos I');
INSERT INTO materias VALUES ('tic-1023', 'Negocios Electronicos II');

-- ITICs. Tecnologías Emergentes.
INSERT INTO materias VALUES ('acf-0901', 'Cálculo Diferencial');
INSERT INTO materias VALUES ('acf-0902', 'Cálculo Integral');
INSERT INTO materias VALUES ('tie-1018', 'Matematicas Aplicadas a la Comunicacion');
INSERT INTO materias VALUES ('tid-1004', 'Analisis de Señal y Sistemas de Comunicacion');
INSERT INTO materias VALUES ('scd-1008', 'Fundamentos de Programacion');
INSERT INTO materias VALUES ('scd-1020', 'Programación Orientada a Objetos');
INSERT INTO materias VALUES ('aed-1026', 'Estructura de Datos');
INSERT INTO materias VALUES ('tib-1024', 'Programacion II');
INSERT INTO materias VALUES ('tif-1019', 'Matematicas Discretas I');
INSERT INTO materias VALUES ('tif-1020', 'Matematicas Discretas II');
INSERT INTO materias VALUES ('tic-1002', 'Administracion Gerencial');
INSERT INTO materias VALUES ('tif-1021', 'Matematicas Para Toma de Deciciones');
INSERT INTO materias VALUES ('tip-1017', 'Introducción a las TICs');
INSERT INTO materias VALUES ('aef-1052', 'Probabilidad y Estadística');
INSERT INTO materias VALUES ('aef-1031', 'Fundamentos de Bases de Datos');
INSERT INTO materias VALUES ('aeh-1063', 'Taller de bases de Datos');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('tif-1009', 'Contabilidad y Costos');
INSERT INTO materias VALUES ('tic-1011', 'Electricidad y Magnetismo');
INSERT INTO materias VALUES ('tid-1008', 'Circuitos Electricos y Electronicos');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('tic-1014', 'Ingenieria de Software');
INSERT INTO materias VALUES ('tif-1013', 'Fundamentos de Redes');
INSERT INTO materias VALUES ('tif-1026', 'Redes de computadora');
INSERT INTO materias VALUES ('tif-1027', 'Redes emergentes');
INSERT INTO materias VALUES ('tif-1003', 'Administracion y Seguridad de Redes');
INSERT INTO materias VALUES ('tif-1030', 'Telecomunicaciones');
INSERT INTO materias VALUES ('tib-1025', 'Programacion Web');
INSERT INTO materias VALUES ('aeb-1011', 'Desarrollo de Aplicaciones para Dispositivos Moviles');
INSERT INTO materias VALUES ('tic-1006', 'Auditoria en Tecnologias de Informacion');
INSERT INTO materias VALUES ('ted-1404', 'Tecnologías de Virtualización (Especialidad)');
INSERT INTO materias VALUES ('tif-1001', 'Administracion de Proyectos');
INSERT INTO materias VALUES ('tid-1010', 'Desarrollo de emprendedores');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('tih-1016', 'Interaccion Humano Computadora');
INSERT INTO materias VALUES ('ted-1405', 'Planes y Respuestas a Contingencias (Especialidad)');
INSERT INTO materias VALUES ('tif-1007', 'Base de Datos Distribuidas');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('teb-1401', 'Programación Web II (Especialidad)');
INSERT INTO materias VALUES ('tic-1015', 'Ingenieria del Conocimiento');
INSERT INTO materias VALUES ('tic-1005', 'Arquitectura de computadoras');
INSERT INTO materias VALUES ('aec-1061', 'Sistemas Operativos I');
INSERT INTO materias VALUES ('aed-1062', 'Sistemas Operativos II');
INSERT INTO materias VALUES ('teb-1402', 'Programación de Bases de Datos (Especialidad)');
INSERT INTO materias VALUES ('tic-1028', 'Taller de Ingenieria de Software');
INSERT INTO materias VALUES ('tic-1029', 'Tecnologias Inalambricas');
INSERT INTO materias VALUES ('tef-1403', 'Inteligencia de Negocios (Especialidad)');
INSERT INTO materias VALUES ('tic-1022', 'Negocios Electronicos I');
INSERT INTO materias VALUES ('tic-1023', 'Negocios Electronicos II');

-- Contador Público.
INSERT INTO materias VALUES ('cpm-1030', 'Intr. a la Contabilidad Financiera');
INSERT INTO materias VALUES ('cpm-1012', 'Contabilidad Financiera I');
INSERT INTO materias VALUES ('cpm-1013', 'Contabilidad Financiera II');
INSERT INTO materias VALUES ('cpd-1011', 'Contabilidad de Sociedades');
INSERT INTO materias VALUES ('cpc-1001', 'Administración');
INSERT INTO materias VALUES ('aca-0907', 'Taller de Ética');
INSERT INTO materias VALUES ('cpc-1033', 'Mercadotecnia');
INSERT INTO materias VALUES ('cpd-1038', 'Sistemas de Costos Históricos.');
INSERT INTO materias VALUES ('acf-0903', 'Álgebra Lineal');
INSERT INTO materias VALUES ('cpd-1008', 'Cálculo Diferencial e Integral');
INSERT INTO materias VALUES ('cpc-1032', 'Matemáticas Financieras');
INSERT INTO materias VALUES ('cpc-1034', 'Microeconomía');
INSERT INTO materias VALUES ('cpc-1025', 'Fundamentos de Derecho');
INSERT INTO materias VALUES ('cpd-1016', 'Derecho Mercantil');
INSERT INTO materias VALUES ('cpc-1015', 'Derecho Laboral y Seguridad Social');
INSERT INTO materias VALUES ('cpc-1017', 'Derecho Tributario');
INSERT INTO materias VALUES ('cpc-1018', 'Desarrollo Humano');
INSERT INTO materias VALUES ('cpc-1019', 'Dinámica Social');
INSERT INTO materias VALUES ('cpc-1026', 'Gestión del Talento Humano');
INSERT INTO materias VALUES ('cpc-1024', 'Fundamentos de Auditoría');
INSERT INTO materias VALUES ('acc-0906', 'Fundamentos de Investigación');
INSERT INTO materias VALUES ('cpc-1022', 'Estadística Administrativa I');
INSERT INTO materias VALUES ('cpc-1023', 'Estadística Administrativa II');
INSERT INTO materias VALUES ('aca-0909', 'Taller de Investigación I');
INSERT INTO materias VALUES ('cpc-1009', 'Comunicación Humana');
INSERT INTO materias VALUES ('cpc-1040', 'Taller de Informática I');
INSERT INTO materias VALUES ('acd-0908', 'Desarrollo Sustentable');
INSERT INTO materias VALUES ('cpd-1010', 'Contabilidad Avanzada');
INSERT INTO materias VALUES ('cpd-1014', 'Contabilidad Internacional');
INSERT INTO materias VALUES ('cdo-1037', 'Seminario de Contaduría');
INSERT INTO materias VALUES ('imd-1801', 'Impuestos Especiales I (Especialidad)');
INSERT INTO materias VALUES ('imd-1803', 'Sem. de Imp. para Personas Físicas. (Especialidad)');
INSERT INTO materias VALUES ('cpc-1039', 'Sistema de Costos Predeterminados');
INSERT INTO materias VALUES ('cpf-1027', 'Gestión y Toma de Decisiones');
INSERT INTO materias VALUES ('cpc-1002', 'Administración Estratégica');
INSERT INTO materias VALUES ('imd-1802', 'Impuestos Especiales II (Especialidad)');
INSERT INTO materias VALUES ('cpc-1031', 'Macroeconomía');
INSERT INTO materias VALUES ('cpc-1003', 'Admón. de la Prod. y de las Operaciones');
INSERT INTO materias VALUES ('cph-1021', 'Elab. y Eval. de Proyectos de Inv.');
INSERT INTO materias VALUES ('cpj-1028', 'Impuestos Personas Morales');
INSERT INTO materias VALUES ('cpj-1029', 'Impuestos Personas Físicas');
INSERT INTO materias VALUES ('cpj-1035', 'Otros impuestos y Contribuciones');
INSERT INTO materias VALUES ('imd-1804', 'Sem. de Imp. para Personas Morales (Especialidad)');
INSERT INTO materias VALUES ('cpd-1006', 'Auditoría para Efectos Financieros');
INSERT INTO materias VALUES ('cpd-1007', 'Auditoría para Efectos Fiscales');
INSERT INTO materias VALUES ('imf-1805', 'Planeación Fiscal (Especialidad) ');
INSERT INTO materias VALUES ('aca-0910', 'Taller de Investigación II');
INSERT INTO materias VALUES ('cpc-1020', 'Economía Internacional');
INSERT INTO materias VALUES ('cpa-1041', 'Taller de Informática II');
INSERT INTO materias VALUES ('cpc-1005', 'Análisis e Interpretación de Estados Financieros');
INSERT INTO materias VALUES ('cpc-1036', 'Planeación Financiera');
INSERT INTO materias VALUES ('cpc-1004', 'Alternativas de Inversión y Financiamiento');