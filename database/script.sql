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
	`nombre_carrera` VARCHAR(45) NOT NULL,
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
	`apellido_materno` VARCHAR(48) NOT NULL,
	PRIMARY KEY (`email`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `siger`.`materias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `siger`.`materias` ;

CREATE TABLE IF NOT EXISTS `siger`.`materias` (
	`clave` CHAR(8) NOT NULL,
	`nombre` VARCHAR(48) NOT NULL,
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
	`fijo` TINYINT NOT NULL DEFAULT 0,
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
	`aprobado` TINYINT NOT NULL DEFAULT 0,
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
	`fecha` VARCHAR(14) NOT NULL,
	`evaluacion_externa` VARCHAR(24) NOT NULL,
	`observaciones_externas` VARCHAR(128) NOT NULL,
	`evaluacion_interna` VARCHAR(17) NOT NULL,
	`observaciones_internas` VARCHAR(128) NOT NULL,
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
	`fecha` VARCHAR(14) NOT NULL,
	`evaluacion_externa` VARCHAR(28) NOT NULL,
	`observaciones_externas` VARCHAR(128) NOT NULL,
	`evaluacion_interna` VARCHAR(28) NOT NULL,
	`observaciones_internas` VARCHAR(128) NOT NULL,
	`id_residencia` INT NOT NULL,
	PRIMARY KEY (`idanexo_30`),
	INDEX `fk_anexo_30_residencia1_idx` (`id_residencia` ASC), -- VISIBLE,
	CONSTRAINT `fk_anexo_30_residencia1`
		FOREIGN KEY (`id_residencia`)
		REFERENCES `siger`.`residencias` (`idresidencia`)
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
	Regresa un string con el nombre completo del 
	residente, docente, o administrador cuyo email 
	concuerde con [v_email].

	Si no encuentra un registro con email [v_email],
	regresará una cadena vacía [''].
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
		) AS t
	);
END;;

DELIMITER ;

/* --------------------------------------------------------

	STORED PROCEDURES.

-------------------------------------------------------- */
DELIMITER ;;

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
	select 
		r.email, substring(r.email, 2, 8) as `noControl`, r.nombre, r.apellido_paterno, r.apellido_materno,
		(select t.telefono from telefonos_residentes as t where r.email = t.email_residente and fijo = 0) as `celular`,
		(select t.telefono from telefonos_residentes as t where r.email = t.email_residente and fijo = 1) as `tel`,
		r.fecha_creacion, c.nombre_carrera as `carrera`
	from 
		residentes as r join carreras as c 
			on c.clave = r.clave_carrera
	where 
		aprobado = 0 and
	c.admin_email = v_email_admin
	order by 
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
		ELSEIF (SELECT COUNT(*) FROM `siger`.`residentes` AS r WHERE r.email = v_email_residente AND r.aprobado = 0) = 0 THEN BEGIN
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
  v_aprobado TINYINT,
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

  START TRANSACTION;
    INSERT INTO `siger`.`residencias`
      (nombre_proyecto, objetivo, justificacion, periodo, ano, descripcion_actividades,aprobado,email_residente,fecha_elaboracion)
    VALUES
      (v_nombre_proyecto, v_objetivo, v_justificacion, v_periodo, v_ano, v_descripcion_actividades, v_aprobado, v_email_residente, v_fecha_elaboracion);

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
	Regresa una lista de docentes cuyo correo electrónico,
	nombre, o apellidos se asemejen al criterio de 
	búsqueda [v_query].
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
		d.email LIKE CONCAT('%',v_query,'%') OR
		nombreCompleto(d.email) LIKE CONCAT('%',v_query,'%');
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
	('itic-2010-225', 'Ingeniería en TICs', 'roberto.ds@piedrasnegras.tecnm.mx');

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

-- ---------------------------------------------
-- residencias
-- ---------------------------------------------
call SP_RegistroResidencia(
	'Volt Breaker', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 1, 2020, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 0, 'L17430001@piedrasnegras.tecnm.mx', '1586570609000', 'Twilight Electronics', 'Amir Obrero', 'Olive Street', 'Kugate', '8781234567', 'twilightelectronics@gmail.com', 'Sistemas y Computación', 'amirobrero@gmail.com', 'Amir Obrero', 'Jefe de departamento', 'Licenciatura', '8781234568'
);
call SP_RegistraHorarios('01:00', '07:00', 1);
call SP_RegistroResidencia(
	'Alpha Entangler', 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 
	1, 2021, 
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 0, 
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
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 0, 
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
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 0, 
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
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 0, 
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
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 0, 
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

-- ---------------------------------------------
-- docentes
-- ---------------------------------------------
-- Las contraseñas de estos docentes fueron encriptadas usando la clave secreta [H5n7jMcgSA^&Rz%ZxyFE@&E#zSteW$jx].
INSERT INTO docentes
VALUES 
	('marti.pd@piedrasnegras.tecnm.mx', '4551b7f81bb877c27da5cd4109bce58c4ae8cd51656473b191558340c23c400b99f1928ccf6e69549ec00a80f11d300b218dd2da314182fc2f7ecab7b854fd4ca041e60877725c4013613b2665bbe7aa', 'Marti', 'Peralta', 'Durán'),
	('rafael.cc@piedrasnegras.tecnm.mx', 'afb8baa57eeed18dfe253d4ad257e8e26f00645032d0b40e53365bff42077839cdc3793a64455e429018bd1e1d1e38a053407764e8890664cbfa1748d598d03d797b9c3fa0cc4a9f3f404021f48e0338', 'Rafael', 'Contador', 'Cueva'),
	('izan.mm@piedrasnegras.tecnm.mx', '12f3d773c7b5a99b82ef470a27c2c9995bafc695968d9783488e304a87b7710582eb7eb9ba383bf43ee45309a5481a765dce26536881b7f24fec94f9ba6a237faac087879700ecc0a4ab828a5dd43eb0', 'Izan', 'Martín', 'Malillos'),
	('rafael.am@piedrasnegras.tecnm.mx', '5c3d248a3bca0aa3d11f656ae1f7bc2e478ae0a101e7fb66f6270292834be634b33fe2d9c8b0f9723a7036b7086579f432577afd17a0f03cf70c340cedd38e06aced19b89f306ea62115ba01e28474a2', 'Rafael', 'Alcaide', 'Mallén'),
	('alonso.sm@piedrasnegras.tecnm.mx', '73c94b2912b5915146ba1e5258451d4262a3f05617a63ae94c05f4695cb78ab7290a37451f9597791b0a2e568deca927593a20ac30619256d5b84320694d4631cdc4a832a6614f0372ff98920c84fe25', 'Alonso', 'Sánchez', 'Montemayor'),
	('adriana.sb@piedrasnegras.tecnm.mx', '8ec5e9bb7aea1f86f50723ba625dd326e69f1b07deaef71f936fac5b1d0f33ee8cfdd2b83e2d2e7fb7b23f3a265a71bfe765d832574a9691e83dd77e494401ec0807bd532d0efd1a7642725468c9b512', 'Adriana', 'Sevilla', 'Bolívar'),
	('rosa.gc@piedrasnegras.tecnm.mx', 'cd406867e7428e7aeace45793637aef06c590e1b980061587caa03590b8d20d5240625e9aaaddb4003db49cffd338f88b8aa7ed3a06a9830fa938561215931a7ca774b20bc7abb5a462e3d7ea118b82f', 'Rosa', 'Gallego', 'Colina'),
	('maria.gm@piedrasnegras.tecnm.mx', 'ac30e7658f0dfb0c66235730cf31a7976101ce88aa55ffa4350878d33df36c5c8df45d7bc37fbca71fe02bfdf0c593023e80020316079fe51061abcbecc712df22117263e3e2f25e6820e9b07d235a17', 'Maria José', 'Gutiérrez', 'Malillos'),
	('sandra.fs@piedrasnegras.tecnm.mx', 'afdc6e60a07d7821e3ab51555bc805cc1d45453ba4d0a5141217dcb6a78342bdb62b4d256db8ef6549b9ee915720b1ddceb0f229dffac62e84f1cd0253945dc64ac2a1cc3ba543a0166ac698e6b313ff', 'Sandra', 'Fidalgo', 'Sabaté'),
	('celia.pd@piedrasnegras.tecnm.mx', 'a0d4c93f29656492dbd4cbeca385fbaa1e0915f3c47d5cc8dd23bead85754427b33c670c061df4d080d1fb4386db4c9fc41435fbc5475189caa54f05e8988b720be20ac2a118778d55db6f3fced60b2e', 'Celia', 'Pastor', 'Domínguez');
